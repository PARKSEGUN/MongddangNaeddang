import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const String _token = 'token'; // 고유한 키로 설정 vendor토큰
  static const String _vendor = 'vendor'; // 고유한 키로 설정
  static const String _authUuid = 'authUuid'; // 고유한 키로 설정
  static const String _fcmToken = 'fcmToken';
  static const String _accessToken = 'accessToken';

  // vendor access 토큰 저장하는 메소드
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _token, value: token);
    } catch (e) {
      print('카카오 토큰 저장 오류: $e');
    }
  }

  // vendor access 토큰 읽기
  Future<String?> readToken() async {
    try {
      return await _secureStorage.read(key: _token);
    } catch (e) {
      print('카카오 토큰 읽기 오류: $e');
      return null;
    }
  }

  // vendor access 토큰 삭제
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _token); // 키 삭제
    } catch (e) {
      print('카카오 토큰 삭제 오류: $e');
    }
  }

  // authUuid 저장
  Future<void> saveAuthUuid(String authUuid) async {
    try {
      await _secureStorage.write(key: _authUuid, value: authUuid);
    } catch (e) {
      print('authUuid 저장 오류: $e');
    }
  }

  // authUuid 읽기
  Future<String?> readAuthUuid() async {
    try {
      return await _secureStorage.read(key: _authUuid);
    } catch (e) {
      print('authUuid 읽기 오류: $e');
      return null;
    }
  }

  // authUuid 삭제
  Future<void> deleteAuthUuid() async {
    try {
      await _secureStorage.delete(key: _authUuid); // 키 삭제
    } catch (e) {
      print('authUuid 삭제 오류: $e');
    }
  }

  // vendor 저장
  Future<void> saveVendor(String vendor) async {
    try {
      await _secureStorage.write(key: _vendor, value: vendor);
    } catch (e) {
      print('vendor 저장 오류: $e');
    }
  }

  // vendor 읽기
  Future<String?> readVendor() async {
    try {
      return await _secureStorage.read(key: _vendor);
    } catch (e) {
      print('vendor 읽기 오류: $e');
      return null;
    }
  }

  // vendor 삭제
  Future<void> deleteVendor() async {
    try {
      await _secureStorage.delete(key: _vendor); // 키 삭제
    } catch (e) {
      print('vendor 삭제 오류: $e');
    }
  }

  // access 토큰 저장하는 메소드
  Future<void> saveFcmToken(String token) async {
    try {
      await _secureStorage.write(key: _fcmToken, value: token);
    } catch (e) {
      print(' 토큰 저장 오류: $e');
    }
  }

  //  access 토큰 읽기
  Future<String?> readFcmToken() async {
    try {
      return await _secureStorage.read(key: _fcmToken);
    } catch (e) {
      print('토큰 읽기 오류: $e');
      return null;
    }
  }

  // access 토큰 삭제
  Future<void> deleteFcmToken() async {
    try {
      await _secureStorage.delete(key: _fcmToken); // 키 삭제
    } catch (e) {
      print(' 토큰 삭제 오류: $e');
    }
  }


  // access 토큰 저장하는 메소드
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(key: _accessToken, value: token);
    } catch (e) {
      print(' 토큰 저장 오류: $e');
    }
  }

  //  access 토큰 읽기
  Future<String?> readAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessToken);
    } catch (e) {
      print(' 토큰 읽기 오류: $e');
      return null;
    }
  }

  // access 토큰 삭제
  Future<void> deleteAccessToken() async {
    try {
      await _secureStorage.delete(key: _accessToken); // 키 삭제
    } catch (e) {
      print(' 토큰 삭제 오류: $e');
    }
  }



}
