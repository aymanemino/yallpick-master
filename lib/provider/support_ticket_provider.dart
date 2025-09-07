import 'package:flutter_sixvalley_ecommerce/data/model/response/support_reply_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/support_ticket_body.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/support_ticket_repo.dart';

class SupportTicketProvider extends ChangeNotifier {
  final SupportTicketRepo supportTicketRepo;
  SupportTicketProvider({required this.supportTicketRepo});

  List<SupportTicketModel> _supportTicketList;
  List<SupportReplyModel> _supportReplyList;
  bool _isLoading = false;

  List<SupportTicketModel> get supportTicketList => _supportTicketList ?? [];
  List<SupportReplyModel> get supportReplyList => _supportReplyList != null
      ? _supportReplyList.reversed.toList()
      : _supportReplyList;
  bool get isLoading => _isLoading;

  void sendSupportTicket(
      SupportTicketBody supportTicketBody,
      Function(bool isSuccess, String message) callback,
      BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
    await supportTicketRepo.sendSupportTicket(supportTicketBody);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data["message"];
      callback(true, message);
      _isLoading = false;
      _supportTicketList.add(SupportTicketModel(
          description: supportTicketBody.description,
          type: supportTicketBody.type,
          subject: supportTicketBody.subject,
          createdAt: DateConverter.formatDate(DateTime.now()),
          status: 'open'));
      getSupportTicketList(context);
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSupportTicketList(BuildContext context) async {
    print('🔍 [DEBUG] getSupportTicketList called');
    ApiResponse apiResponse = await supportTicketRepo.getSupportTicketList();
    print('🔍 [DEBUG] API Response: ${apiResponse.response?.statusCode}');

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      print('🔍 [DEBUG] API Success - Data: ${apiResponse.response.data}');
      print('🔍 [DEBUG] Data type: ${apiResponse.response.data.runtimeType}');
      print('🔍 [DEBUG] Data length: ${apiResponse.response.data.length}');

      _supportTicketList = [];
      apiResponse.response.data.forEach((supportTicket) {
        print('🔍 [DEBUG] Processing ticket: $supportTicket');
        try {
          SupportTicketModel ticket =
          SupportTicketModel.fromJson(supportTicket);
          print('🔍 [DEBUG] Ticket parsed successfully: ${ticket.subject}');
          _supportTicketList.add(ticket);
        } catch (e) {
          print('🔍 [ERROR] Failed to parse ticket: $e');
        }
      });

      print('🔍 [DEBUG] Final list length: ${_supportTicketList.length}');
      print('🔍 [DEBUG] Final list: $_supportTicketList');
    } else {
      print('🔍 [DEBUG] API Error: ${apiResponse.error}');
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getSupportTicketReplyList(
      BuildContext context, int ticketID) async {
    _supportReplyList = null;
    ApiResponse apiResponse =
    await supportTicketRepo.getSupportReplyList(ticketID.toString());
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _supportReplyList = [];
      apiResponse.response.data.forEach((supportReply) =>
          _supportReplyList.add(SupportReplyModel.fromJson(supportReply)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> sendReply(
      BuildContext context, int ticketID, String message) async {
    ApiResponse apiResponse =
    await supportTicketRepo.sendReply(ticketID.toString(), message);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _supportReplyList.add(SupportReplyModel(
          customerMessage: message,
          createdAt: DateConverter.localDateToIsoString(DateTime.now())));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
}
