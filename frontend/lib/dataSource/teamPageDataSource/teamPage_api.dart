import 'package:dio/dio.dart';
import 'package:frontend/model/teamPageModel/teamPageMember_model.dart';
import 'package:frontend/model/teamPageModel/teamPageTeamInfo_model.dart';

import '../../secureStroage/token_storage.dart';
import '../api_url.dart';

class TeamApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: url));

  Future<int> getMyTeamId() async {
    UserSecureStorage tokenStorage = UserSecureStorage();
    final authUuid = await tokenStorage.readAuthUuid();
    try {
      final response = await _dio.post('/api/user/myteam',
          data: {'authUuid': authUuid},
          options: Options(headers: {
            'Content-Type': 'application/json', // 요청 헤더 설정
          }));
      return response.data['teamId'];
    } catch (e) {
      throw Exception("에러에러: $e");
    }
  }

  Future<TeamPageTeamInfoModel> getMyTeamInfo(int teamId) async {
    // getMyTeamId() 호출 시 await 사용
    try {
      final response = await _dio.post('/api/team',
          data: {'teamId': teamId}, // teamId 사용
          options: Options(headers: {
            'Content-Type': 'application/json', // 요청 헤더 설정
          }));
      TeamPageTeamInfoModel teamInfo =
          TeamPageTeamInfoModel.fromJson(response.data);
      return teamInfo;
    } catch (e) {
      throw Exception("에러에러: $e");
    }
  }

  Future<List<TeamPageMemberModel>> getMemberList(int teamId) async {
    try {
      final response = await _dio.post('/api/team/members',
          data: {'teamId': teamId},
          options: Options(headers: {
            'Content-Type': 'application/json',
          }));
      if (response.statusCode == 200) {
        List<TeamPageMemberModel> memberList = (response.data as List)
            .map((json) => TeamPageMemberModel.fromJson(json))
            .toList();
        return memberList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("에러에렁: $e");
    }
  }

  Future<void> teamLeave(String authUuid, int teamId) async {
    try {
      final response = await _dio.post(
        '/api/team/leave',
        data: {
          "authUuid": authUuid,
          "teamId": teamId,
        },
        options: Options(contentType: "application/json"),
      );
    } catch (e) {
      throw ("에럿: $e");
    }
  }

  Future<String> getTeamLeader(int teamId) async {
    try {
      final response = await _dio.post(
        '/api/team/leader',
        data: {"teamId": teamId},
        options: Options(contentType: "application/json"),
      );
      return response.data;
    } catch (e) {
      throw ("에럿에럿: $e");
    }
  }
}
