import 'package:dio/dio.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/secureStroage/token_storage.dart';

import '../router/app_router.dart';

void logout() async {
  UserSecureStorage userSecureStorage = UserSecureStorage();
  final accessToken = await userSecureStorage.readAccessToken();
  final vendor = await userSecureStorage.readVendor();
  final authUuid = await userSecureStorage.readAuthUuid();

  print(accessToken);
  print(vendor);
  print(authUuid);

  final dio = Dio();
  final headers = {
    'accessToken': accessToken,
    "Content-Type": "application/json", // application/json 타입 선언
  };
  final body = {
    'vendor': vendor,
    'authUuid' : authUuid,
  };
  try {
    final response = await dio.post(
      '$url/api/auth/logout',
      options: Options(headers: headers),
      data: body,
    );

    if (response.statusCode == 200) {
      print('로그아웃 성공');
      userSecureStorage.deleteVendor();
      userSecureStorage.deleteAuthUuid();
      userSecureStorage.deleteAccessToken();
      userSecureStorage.deleteFcmToken();
      userSecureStorage.deleteToken();
      router.go('/');
    } else {
      print('로그아웃 실패');
    }
  } catch (e) {
    print(e);
    print('logout api에서 오류발생');
  }
}