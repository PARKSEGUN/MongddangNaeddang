import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/secureStroage/token_storage.dart';

import '../firebase_options.dart';

Future<bool> autoLogin() async {
  UserSecureStorage _TokenStorage = UserSecureStorage();
  final dio = Dio();
  final _accessToken = await _TokenStorage.readAccessToken();
  final _authUuid = await _TokenStorage.readAuthUuid();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var _fcmToken = await FirebaseMessaging.instance.getToken();
  _TokenStorage.saveFcmToken(_fcmToken!);
  final headers = {
    'accessToken' : _accessToken // jwt 토큰
  };
  final body = {
    // 필요할 경우 작성
    'authUuid' : _authUuid,
    'fcmToken' : _fcmToken,
  };
  print("@@@@@@@@@@@@@@");
  print(_accessToken);
  print(_authUuid);
  print(_fcmToken);
  print("@@@@@@@@@@@@@@");
  try {
    final response = await dio.post(
      '$url/api/auth/autologin', // url은 정해지면 변경필요
      options: Options(headers: headers),
      data: body, //필요한 경우 사용
    );
    if (response.statusCode == 200) {
      print('자동 로그인 성공');
      return true;
    } else {
      print('자동 로그인 정보 유효하지 않음');
      return false;
    }
  } catch(e) {
    print(e);
    print('자동 로그인 에러 발생');
    return false;
  }
}