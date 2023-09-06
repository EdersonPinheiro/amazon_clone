import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/app/constants/error_handling.dart';
import 'package:amazon_clone/app/constants/global_variables.dart';
import 'package:amazon_clone/app/constants/utils.dart';
import 'package:amazon_clone/app/models/product.dart';
import 'package:amazon_clone/app/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final cloudinary = CloudinaryPublic('dmhkrgcjd', 'vxphqwou');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        images: imageUrls,
        quantity: quantity,
        price: price,
        category: category,
      );

      final res = await Dio().post(
        '$uri/admin/add-product',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': userProvider.user.token,
          },
        ),
        data: product.toJson(),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              'Product added sucessfully!',
            );
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      final res = await Dio().get(
        '$uri/admin/get-products',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': userProvider.user.token,
          },
        ),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List<dynamic> dataList =
              res.data; // No need for jsonDecode here
          productList = dataList.map((data) => Product.fromMap(data)).toList();
        },
      );
    } catch (error) {
      print(error.toString());
      // Handle error
    }

    return productList;
  }
}
