
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:frontend/model/myPageModel/badge_model.dart';

final dio = Dio();

Future<void> getBadge() async {
  UserSecureStorage _TokenStorage = UserSecureStorage();
  final authUuid = await _TokenStorage.readAuthUuid();

  final body = {
    'authUuid': authUuid,
  };
  try {
    final response = await dio.post(
      '$url/api/user/badge',//10.2.2.2는 윈도우 로컬
      data: body,
    );
    if (response.statusCode == 200) {
      final data = response.data;
      print(data);
      var myBadge= [];
      data.forEach((datum) {
        myBadge.add(datum['badgeId']);
      });
      print(myBadge);

    } else {
      print('200말고 다른 코들 들어옴 ${response.statusCode}');
    }
    
  } catch(e) {
    print('뱃지 api 요청 오류 : $e');
  }
}