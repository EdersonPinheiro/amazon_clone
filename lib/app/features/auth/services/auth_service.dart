// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:amazon_clone/app/constants/error_handling.dart';
import 'package:amazon_clone/app/constants/global_variables.dart';
import 'package:amazon_clone/app/constants/utils.dart';
import 'package:amazon_clone/app/models/user.dart';
import 'package:amazon_clone/app/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/bottom_bar.dart';
import '../../home/screens/home_screen.dart';

class AuthService {
  Future<void> createAccount(
      {required BuildContext context,
      required String name,
      required String email,
      required String password}) async {
    try {
      final response = await Dio().post('$uri/api/signup',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
            },
          ),
          data: {"name": name, "email": email, "password": password});

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Conta criada com sucesso! Entre agora com as suas credênciais abaixo!',
          );
        },
      );
      User.fromJson(response.data['result']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final response = await Dio().post('$uri/api/signin',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
            },
          ),
          data: {"email": email, "password": password});
      print(response.data);

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', response.data['token']);
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonEncode(response.data));
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (Route<dynamic> route) => false,
          );
        },
      );
      User.fromJson(response.data['result']);
    } catch (e) {}
  }

  Future<void> getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      final tokenResponse = await Dio().post(
        '$uri/api/tokenIsValid',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': '*/*',
            'x-auth-token': token
          },
        ),
      );
      
      var res = jsonEncode(tokenResponse.data);

      if (res != null) {
        final userResponse = await Dio().get(
          '$uri/api/home',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'x-auth-token': token
            },
          ),
      );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(jsonEncode(userResponse.data));
      }
    } catch (e) {
      print(e);
    }
  }
}
