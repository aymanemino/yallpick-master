import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class ContactUsRepo {
  final DioClient dioClient;
  ContactUsRepo({this.dioClient});

  Future<ApiResponse> sendData(
      {String? name,
      String? email,
      String? phone,
      String? subject,
      String? message}) async {
    try {
      log(json.encode({
        'name': name,
        'email': email,
        'phone': phone,
        'subject': subject,
        'message': message
      }));
      final response = await dioClient.post(AppConstants.CONTACT_US_URI,
          data: json.encode({
            'name': name,
            'email': email,
            'phone': phone,
            'subject': subject,
            'message': message
          }));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
