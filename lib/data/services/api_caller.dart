import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/app.dart';

import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

import '../utils/urls.dart';

class ApiCaller {
  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String url}) async {
    Uri uri = Uri.parse(url);
    _logRequest(url);
    Response response = await get(
      uri,
      headers: {"token": AuthController.accessToken ?? ""},
    );
    _logRespose(url, response);
    print(uri);
    print(response.body);
    print(response.statusCode);

    final int statusCode = response.statusCode;

    if (response.statusCode == 200) {
      //success
      final decodedData = jsonDecode(response.body);
      return ApiResponse(
        isSuccess: true,
        responseCode: statusCode,
        responseData: decodedData,
      );
    } else if (statusCode == 401) {
      await _moveToLogin();
      return ApiResponse(
        isSuccess: false,
        responseCode: statusCode,
        errorMessage: "un-authorized",
        responseData: null,
      );
    } else {
      //faild
      final decodedData = jsonDecode(response.body);
      return ApiResponse(
        isSuccess: false,
        responseCode: statusCode,
        responseData: decodedData,
        errorMessage: decodedData["data"],
      );
    }
  }

  static Future<ApiResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    Uri uri = Uri.parse(url);
    _logRequest(url, body: body);
    Response response = await post(
      uri,
      headers: {
        "content-type": "application/json",
        "token": AuthController.accessToken ?? "",
      },
      body: jsonEncode(body),
    );
    _logRespose(url, response);
    print(uri);
    print(response.body);
    print(response.statusCode);

    final int statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      //success
      final decodedData = jsonDecode(response.body);
      return ApiResponse(
        isSuccess: true,
        responseCode: statusCode,
        responseData: decodedData,
      );
    } else if (statusCode == 401) {
      await _moveToLogin();
      return ApiResponse(
        isSuccess: false,
        responseCode: statusCode,
        errorMessage: "un_authorized",
        responseData: null,
      );
    } else {
      //faild
      final decodedData = jsonDecode(response.body);
      return ApiResponse(
        isSuccess: false,
        responseCode: statusCode,
        responseData: decodedData,
        errorMessage: decodedData["data"],
      );
    }
  }


  static Future<ApiResponse> recoverVerifyEmail({required String email}) async {
    try {
      final String url = Urls.recoverVerifyEmailUrl(email);
      return await getRequest(url: url);
    } catch (e) {
      _logger.e("Recover verify email error: $e");
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: "Connection failed. Please try again.",
      );
    }
  }

  static Future<ApiResponse> recoverVerifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final String url = Urls.recoverVerifyOTPUrl(email, otp);
      return await getRequest(url: url);
    } catch (e) {
      _logger.e("Recover verify OTP error: $e");
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: "Connection failed. Please try again.",
      );
    }
  }

  static Future<ApiResponse> recoverResetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "email": email,
        "OTP": otp,
        "password": password,
      };

      return await postRequest(
        url: Urls.recoverResetPasswordUrl,
        body: body,
      );
    } catch (e) {
      _logger.e("Recover reset password error: $e");
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: "Connection failed. Please try again.",
      );
    }
  }


  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i(
      "URL => $url\n"
          "Request Body : $body",
    );
  }

  static void _logRespose(String url, Response response) {
    _logger.i(
      "URL => $url\n"
          "Status Code : ${response.statusCode}\n"
          "Body : ${response.body}",
    );
  }

  static Future<void> _moveToLogin() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
        TaskManagerApp.navigator.currentContext!, LoginScreen.name, (
        predicate) => false);
  }
}

class ApiResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.responseCode,
    required this.responseData,
    this.errorMessage,
  });
}