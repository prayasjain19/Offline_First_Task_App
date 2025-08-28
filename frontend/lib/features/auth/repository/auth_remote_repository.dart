import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final spService = SpService();
  final authLocalRepository = AuthLocalRepository();
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (res.statusCode != 201) {
        final error = jsonDecode(res.body)['error'];
        throw Exception(error); // ✅ throw instead of returning string
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw Exception(e.toString()); // ✅ always throw on error
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode != 200) {
        final error = jsonDecode(res.body)['error'];
        throw Exception(error);
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw Exception(e.toString()); // ✅ always throw on error
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }

      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/tokenIsValid'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      //this is because we are sending in backend true/false;
      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }
      final userResponse = await http.get(
        Uri.parse('${Constants.backendUri}/auth/'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (userResponse.statusCode != 200) {
        final error = jsonDecode(userResponse.body)['error'];
        throw Exception(error);
      }
      //from this we will get the updated User
      return UserModel.fromJson(userResponse.body);
    } catch (e) {
      //Handle offline cas eif user offline we comes to catch block because of http
      final user = await authLocalRepository.getUser();
      print(user);
      return user;
    }
  }
}
