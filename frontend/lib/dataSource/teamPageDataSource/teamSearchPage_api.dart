import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/model/teamPageModel/teamSearchPageTeamInfo_model.dart';
import 'package:frontend/secureStroage/token_storage.dart';

import '../api_url.dart';

class TeamSearchApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: url));

  Future<List<SearchPageTeamModel>> getSearchedTeamList(
      String teamName, int sortType) async {
    try {
      final response = await _dio.post("/api/team/search",
          data: {
            'keyword': teamName,
            'sortType': sortType,
          },
          options: Options(contentType: "application/json"));
      List<SearchPageTeamModel> searchedTeamList = (response.data as List)
          .map((json) => SearchPageTeamModel.fromJson(json))
          .toList();
      return searchedTeamList;
    } catch (e) {
      throw ("에러에러!!: $e");
    }
  }

  Future<ImageProvider<Object>> getTeamImage(int teamId) async {
    try {
      final response = await _dio.get(
        "/api/image/team/$teamId",
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        return MemoryImage(response.data as Uint8List);
      } else {
        print("200아님");
        return AssetImage('assets/temp/noImg.png');
      }
    } catch (e) {
      return AssetImage('assets/temp/noImg.png');
    }
  }

  Future<int?> teamSignUp(int teamId) async {
    UserSecureStorage storage = UserSecureStorage();
    final authUuid = await storage.readAuthUuid();
    try {
      final response = await _dio.post(
        "/api/team/join",
        data: {
          "authUuid": authUuid,
          "teamId": teamId,
        },
        options: Options(contentType: "application/json"),
      );
      return response.statusCode;
    } catch (e) {
      throw ("에러 에러: $e");
    }
  }
}
