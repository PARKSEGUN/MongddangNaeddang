import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/secureStroage/token_storage.dart';

import '../firebase_options.dart';

//dio로 backend에 요청보내기
Future<bool> login(String accessToken, String vendor) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var fcmToken = await FirebaseMessaging.instance.getToken();
  UserSecureStorage _TokenStorage = UserSecureStorage();
  _TokenStorage.saveFcmToken(fcmToken!);
  // var fcmToken = await _TokenStorage.readFcmToken();
  print('엑세스 토큰: $accessToken');
  print('fcm 토큰 : $fcmToken');
  final dio = Dio();
  // 요청 헤더 설정
  final headers = {
    'accessToken': accessToken,
    "Content-Type": "application/json", // application/json 타입 선언
  };
  // 요청 바디 설정
  final body = {
    'vendor': vendor,
    'fcmToken' : fcmToken,
  };
  try {
    // POST 요청 보내기
    final response = await dio.post(
      '$url/api/auth/login',
      options: Options(headers: headers),
      data: body,
    );
    // 응답 처리
    if (response.statusCode == 200) {
      print('로그인 성공: ${response.data}');
      print(response.data["authUuid"]);
      _TokenStorage.saveAuthUuid(response.data['authUuid']); //유저아이디 정보 저장하기
      _TokenStorage.saveAccessToken(response.data['token']); // 서버 accessToken(not Oauth Server)
      print('login api에서 return true');
      return true;
    } else {//만약 토큰이 만료되었다면
      print('로그인 실패: ${response.statusCode}');
      print('login api에서 토큰만료로 return false');
      return false;
    }
  } catch (e) {
    print('오류 발생: $e');
    print('login api에서 오류발생으로 return false');
    return false;
  }
}