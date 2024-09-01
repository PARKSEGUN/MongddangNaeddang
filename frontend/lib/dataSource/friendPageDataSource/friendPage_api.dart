import 'package:dio/dio.dart';
import 'package:frontend/model/friendPageModel/friendPage_model.dart';

import '../../secureStroage/token_storage.dart';
import '../api_url.dart';

class FriendApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: url));

  Future<List<FriendPageModel>> getFriendList() async {
    UserSecureStorage _TokenStorage = UserSecureStorage();
    final authUuid = await _TokenStorage.readAuthUuid();
    try {
      final response = await _dio.post(
        "/api/friend/list",
        data: {
          "authUuid": authUuid,
        },
        options: Options(contentType: "application/json"),
      );
      List<FriendPageModel> friendList = (response.data as List)
          .map((json) => FriendPageModel.fromJson(json))
          .toList();
      return friendList;
    } catch (e) {
      throw Exception("에러에러!!: $e");
    }
  }

  Future<FriendPageModel> getFriend(String friendName) async {
    UserSecureStorage _TokenStorage = UserSecureStorage();
    final authUuid = await _TokenStorage.readAuthUuid();
    try {
      final response = await _dio.post(
        "/api/friend/search",
        data: {
          "authUuid": authUuid,
          "nickname": friendName,
        },
        options: Options(contentType: "application/json"),
      );
      if (response.statusCode == 200) {
        FriendPageModel searchedFriend =
            FriendPageModel.fromJson(response.data);
        return searchedFriend;
      } else {
        throw Exception("친구 없음");
      }
    } catch (e) {
      throw Exception("에러에러!!!: $e");
    }
  }

  void friendRequest(String friendName) async {
    UserSecureStorage _TokenStorage = UserSecureStorage();
    final authUuid = await _TokenStorage.readAuthUuid();
    try {
      final response = await _dio.post(
        "/api/notification/friend",
        data: {
          "sender": authUuid,
          "receiver": friendName,
        },
        options: Options(contentType: "application/json"),
      );
      if (response.statusCode == 200) {
        print("성공");
      } else {
        throw Exception("친구 없음");
      }
    } catch (e) {
      throw Exception("에러에러!!!: $e");
    }
  }

  void friendAcceptance(String friendId) async {
    UserSecureStorage _TokenStorage = UserSecureStorage();
    final authUuid = await _TokenStorage.readAuthUuid();
    try {
      final response = await _dio.post(
        "/api/friend/request",
        data: {
          "authUuid": authUuid,
          "friendId": friendId,
        },
        options: Options(contentType: "application/json"),
      );
      if (response.statusCode == 200) {
        print("성공");
      } else {
        throw Exception("수락 안됨");
      }
    } catch (e) {
      throw Exception("수락안됨에러: $e");
    }
  }

  Future<void> friendRemove(String friendName) async {
    UserSecureStorage storage = UserSecureStorage();
    final authUuid = await storage.readAuthUuid();
    try {
      final response = await _dio.delete(
        '/api/friend/delete',
        data: {
          "authUuid": authUuid,
          "friendId": friendName,
        },
        options: Options(contentType: "application/json"),
      );
    } catch (e) {
      throw ("에런데요?: $e");
    }
  }
}
