import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class AuthController {
  static const String _accessTokenkey = "token";
  static const String _userModelkey = "user-data";

 static String? accessToken;
  static UserModel? userModel;
  static Future<void> saveUserData(UserModel model,String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenkey, token);
    await sharedPreferences.setString(_userModelkey, jsonEncode(model.toJson()));
    accessToken =token;
    userModel =model;

  }
  static Future<void> updateUserData(UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  
    await sharedPreferences.setString(_userModelkey, jsonEncode(model.toJson()));

    userModel =model;

  }
  static Future<void> getUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token =sharedPreferences.getString(_accessTokenkey);
    if(token !=null){
     String? userData = sharedPreferences.getString(_userModelkey);
     userModel = UserModel.fromJson(jsonDecode(userData!));
     accessToken = token;
    }
  }

  static Future<bool> isUserAlreadyLoggedIn() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token =sharedPreferences.getString(_accessTokenkey);
    return token !=  null;
    }
    static Future<void>  clearUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    }

  }


