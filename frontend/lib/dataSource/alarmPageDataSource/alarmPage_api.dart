import 'package:dio/dio.dart';
import 'package:frontend/model/alarmPageModel/alarmPage_model.dart';

import '../api_url.dart';

class AlarmApiService {
  final _dio = Dio(BaseOptions(baseUrl: url));

  Future<List<AlarmModel>> getAlarms(String userId, int teamId) async {
    try {
      final response = await _dio.post("/api/notification/acquire",
          data: {
            "profileUuid": userId,
            "teamId": teamId,
          },
          options: Options(contentType: "application/json"));

      List<AlarmModel> alarmList = (response.data as List)
          .map((json) => AlarmModel.fromJson(json))
          .toList();
      return alarmList;
    } catch (e) {
      throw ("에렁에렁: $e");
    }
  }
}
