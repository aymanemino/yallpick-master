import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              // errorDescription = "Request to API server was cancelled";
              errorDescription = sharedPreferences
                          .getString(AppConstants.LANGUAGE_CODE) ==
                      'en'
                  ? "Request to API server was cancelled"
                  : sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ==
                          'ar'
                      ? 'تم إلغاء الطلب إلى الخادم'
                      : 'La demande au serveur a été annulée';
              break;
            case DioErrorType.connectTimeout:
              errorDescription = sharedPreferences
                          .getString(AppConstants.LANGUAGE_CODE) ==
                      'en'
                  ? "Connection timeout with API server"
                  : sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ==
                          'ar'
                      ? 'مهلة الاتصال بالخادم'
                      : 'Délai de connexion avec le serveur';
              break;
            case DioErrorType.other:
              // errorDescription =
              //     "Connection to API server failed due to internet connection";

              errorDescription = sharedPreferences
                          .getString(AppConstants.LANGUAGE_CODE) ==
                      'en'
                  ? "Connection to API server failed due to internet connection"
                  : sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ==
                          'ar'
                      ? 'فشل الاتصال بالخادم بسبب الاتصال بالإنترنت'
                      : 'La connexion au serveur a échoué en raison d\'une connexion Internet';
              break;
            case DioErrorType.receiveTimeout:
              // errorDescription =
              //     "Receive timeout in connection with API server";

              errorDescription = sharedPreferences
                          .getString(AppConstants.LANGUAGE_CODE) ==
                      'en'
                  ? "Receive timeout in connection with API server"
                  : sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ==
                          'ar'
                      ? 'تلقي المهلة فيما يتعلق بالخادم'
                      : 'Délai de réception en connexion avec le serveur';
              break;
            case DioErrorType.response:
              switch (error.response.statusCode) {
                case 404:
                case 500:
                case 503:
                  errorDescription = error.response.statusMessage;
                  break;
                default:
                  print('errorrororor ${error.response.data}');
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response.data);
                  if (errorResponse.errors != null &&
                      errorResponse.errors.length > 0)
                    errorDescription = errorResponse;
                  else
                    errorDescription =
                        "Failed to load data - status code: ${error.response.statusCode}";
              }
              break;
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
          }
        } else {
          // errorDescription = "Unexpected error occured";
          errorDescription = sharedPreferences
                          .getString(AppConstants.LANGUAGE_CODE) ==
                      'en'
                  ? "Unexpected error occurred"
                  : sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ==
                          'ar'
                      ? 'حدث خطأ غير متوقع'
                      : 'Une erreur inattendue s\'est produite';
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
