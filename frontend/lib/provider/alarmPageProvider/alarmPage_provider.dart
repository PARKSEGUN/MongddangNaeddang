import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/dataSource/alarmPageDataSource/alarmPage_api.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/dataSource/teamPageDataSource/teamPage_api.dart';
import 'package:frontend/model/alarmPageModel/alarmPage_model.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'alarmPage_provider.g.dart';

@riverpod
AlarmApiService getAlarmApi(ref){
  return AlarmApiService();
}

@riverpod
class AlarmListNotifier extends _$AlarmListNotifier{


  @override
  Future<List<AlarmModel>> build() async{
    final alarmApi = ref.read(getAlarmApiProvider);
    UserSecureStorage storage = UserSecureStorage();
    final authUuid = await storage.readAuthUuid();
    List<AlarmModel> alarmList = await alarmApi.getAlarms(authUuid!, 2);
    return alarmList;
  }

  // 알람 삭제 버튼 눌렀을 때 발생할 로직
  void deleteAlarmAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림 삭제'),
          content: Text('알림을 전부 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text('네'),
              onPressed: () {
                _deleteAlarmRequest();
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  // 알람 모두 삭제해 달라고 요청 보내기
  Future<void> _deleteAlarmRequest() async {
    final dio = Dio();
    UserSecureStorage storage = UserSecureStorage();
    final authUuid = await storage.readAuthUuid();
    final teamApi = TeamApiService();
    final teamId = await teamApi.getMyTeamId();
    final body = {
      'profileUuid': authUuid,
      'teamId' : teamId,
    };
    try {
      final response = await dio.delete('$url/api/notification/deleteall', data: body);
      if (response.statusCode == 200) {
        print('삭제 성공함 : ${response.data}');
      } else {
        print('삭제 실패함 : ${response.statusCode}');
      }
    } catch (e) {
      print('알람 삭제 요청 오류: $e');
    }
  }
}