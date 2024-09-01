import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/myPageModel/history_model.dart';

import '../../secureStroage/token_storage.dart';
import '../api_url.dart';

final dio = Dio();

Future<List<HistoryModel>?> getHistory(ProviderContainer container) async {
  UserSecureStorage _TokenStorage = UserSecureStorage();
  final authUuid = await _TokenStorage.readAuthUuid();
  // const authUuid = 'kakao_3642097138';
  final body = {
    'authUuid': authUuid,
  };

  try {
    final response = await dio.post(
      '$url/api/user/history', //10.2.2.2는 윈도우 로컬
      // 'http://10.0.2.2:80/api/user/history', // 로컬 주소로 변경
      data: body,
    );
    print(response.data);
    if (response.statusCode == 200) {
      // 응답 데이터에서 기록 리스트를 가져옴
      /*
      *   들어오는 데이터 확인해서 데이터 들어오지 않았을때 처리
      * */
      List<dynamic> historyDataList = response.data; // 'history'는 응답 데이터의 키로 가정
      List<HistoryModel> historyModels = [];
      // if (historyDataList.isEmpty) {
      //   print('비어따!!!!!!!!!!!!!!!!!!!!!');
      // }
      for (var item in historyDataList) {
        // 각 기록에 대해 HistoryModel 객체 생성
        print(item);
        HistoryModel historyModel = HistoryModel(
          distance: item['distance'],
          startTime: item['startTime'],
          endTime: item['endTime'],
        );

        // 리스트에 추가
        historyModels.add(historyModel);
        print(historyModels);
      }

      // 생성한 HistoryModel 객체를 리턴
      return historyModels;
    } else {
      print('코드가 이상한게 들어옴 $response.statusCode');
      return null; // 상태 코드가 200이 아닐 경우 null 반환
    }
  } catch (e) {
    print('에러: $e');
    return null; // 에러 발생 시 null 반환
  }
}
