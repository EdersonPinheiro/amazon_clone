import 'dart:convert';

import 'package:amazon_clone/app/constants/utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

void httpErrorHandle({
  required dio.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      print("sucess");
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.data)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.data)['error']);
      break;
    default:
      showSnackBar(context, response.data);
  }
}
