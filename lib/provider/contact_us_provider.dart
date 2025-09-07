import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/contact_us_repo.dart';

class ContactUsProvider extends ChangeNotifier {
  final ContactUsRepo contactUsRepo;
  ContactUsProvider({required this.contactUsRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<ResponseModel> sendData(BuildContext context,
      {String? name,
      String? email,
      String? phone,
      String? subject,
      String? message}) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    ApiResponse apiResponse;
    apiResponse = await contactUsRepo.sendData(
        name: name,
        email: email,
        phone: phone,
        subject: subject,
        message: message);

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data['msg'].toString();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$message', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green));

      responseModel = ResponseModel(message, true);

      _isLoading = false;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage, false);

      _isLoading = false;
    }
    notifyListeners();
    return responseModel;
  }
}
