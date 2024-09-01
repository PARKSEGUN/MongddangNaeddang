import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../secureStroage/token_storage.dart';
import 'login_api.dart';

Future<bool> signWithKakao() async {
  UserSecureStorage _TokenStorage = UserSecureStorage();
  print('---------------');
  //카카오 토큰 값 flutterSecureStorage에서 가져오기
  final kakaoToken = await _TokenStorage.readToken();

  //1. 토큰이 있는 경우
  if (kakaoToken != null && kakaoToken.isNotEmpty) {
    try {
      // AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
      // print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

      print(kakaoToken);
      print('---------------');
      //백엔드에 요청보내기
      return login(kakaoToken, 'kakao');
    } catch (error) {
      if (error is KakaoException && error.isInvalidTokenError()) {
        print('토큰 만료 $error');
      } else {
        print('토큰 정보 조회 실패 $error');
      }

      try {
        // 카카오계정으로 로그인
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('signWithKakao 로그인 성공 ${token.accessToken}');
        //flutter_secure_storage에 토큰 저장하는 로직
        _TokenStorage.saveToken(token.accessToken);
        _TokenStorage.saveVendor('kakao');
        final kakaoToken = await _TokenStorage.readToken(); //카카오토큰 읽어오기
        final vendor = await _TokenStorage.readVendor();
        //백엔드 서버로 엑세스토큰과 벤더로 post요청 보내기
        return login(token.accessToken, vendor!);
      } catch (error) {
        print('signWithKakao 로그인 실패 $error');
        return false;
      }
    }
  } else {
    //2. 토큰 없는 경우
    print('발급된 토큰 없음');
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('signWithKakao 로그인 성공 ${token.accessToken}');
      //flutter_secure_storage에 토큰 저장하는 로직
      _TokenStorage.saveToken(token.accessToken);
      _TokenStorage.saveVendor('kakao');
      print(await _TokenStorage.readToken());
      final vendor = await _TokenStorage.readVendor();
      print(vendor);
      //백엔드 서버로 엑세스토큰과 벤더로 post요청 보내기
      return login(token.accessToken, vendor!);
    } catch (error) {
      print('signWithKakao 로그인 실패 $error');
      return false;
    }
  }
}
