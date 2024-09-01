import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../secureStroage/token_storage.dart';
import 'login_api.dart';

Future<bool> signWithNaver() async {
  UserSecureStorage _TokenStorage = UserSecureStorage();

  //1. 토큰이 있는 경우
  if (await _TokenStorage.readToken() != null) {
    try {
      // 저장되어있는 토큰 가져오기.
      final token = await _TokenStorage.readToken();
      final vendor = await _TokenStorage.readVendor();
      print('토큰 유효성 체크 성공');
      print('---------------');
      print(token);
      // 토큰 값 flutterSecureStorage에서 가져오기
      //백엔드에 요청보내기
      return login(token!, vendor!);
    } catch (error) {
      if (error is NullException) {
        print('토큰 정보 조회 실패 $error');
      } else {
        print('토큰 만료 $error');
      }


      try {
        // 네이버 계정으로 로그인
        NaverLoginResult res = await FlutterNaverLogin.logIn();
        print('signWithNaver 로그인 성공 ${res.accessToken}');
        //flutter_secure_storage에 토큰 저장하는 로직
        // res. access token 확인해 봐야함.
        _TokenStorage.saveToken(res.accessToken as String);
        _TokenStorage.saveVendor('naver');
        final token = await _TokenStorage.readToken();// 네이버 토큰 읽어오기
        final vendor = await _TokenStorage.readVendor();
        //백엔드 서버로 엑세스토큰과 벤더로 post요청 보내기
        print(await _TokenStorage.readAccessToken());
        return login(token!, vendor!);
      } catch (error) {
        print('signWithNaver 로그인 실패 $error');
        return false;
      }
    }
  } else {
    //2. 토큰 없는 경우
    print('발급된 토큰 없음');
    try {
      NaverLoginResult res1 = await FlutterNaverLogin.logIn();
      // 네이버 계정으로 로그인
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;

      // setState(() {
      //   accesToken = res.accessToken;
      //   tokenType = res.tokenType;
      // });

      print('signWithNaver 로그인 성공 ${res.accessToken}');
      //flutter_secure_storage에 토큰 저장하는 로직
      // res. access token 확인해 봐야함.
      
      _TokenStorage.saveToken(res.accessToken);
      _TokenStorage.saveVendor('naver');
      final token = await _TokenStorage.readToken();// 네이버 토큰 읽어오기
      final vendor = await _TokenStorage.readVendor();
      //백엔드 서버로 엑세스토큰과 벤더로 post요청 보내기
      print('${token}    벤더  ${vendor}');
      return login(token!, vendor!);
    } catch (error) {
      print('signWithNaver 로그인 실패 $error');
      return false;
    }
  }
}

// null exception
class NullException implements Exception {
  final String message;

  NullException(this.message);

  @override
  String toString() => 'NullException: $message';
}