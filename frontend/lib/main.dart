import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/router/app_router.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'dataSource/autoLogin_api.dart';
import 'dataSource/teamPageDataSource/teamPage_api.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // env 초기화
  await dotenv.load();
  final a = dotenv.get('a');
  final b = dotenv.get('b');
  final c = dotenv.get('c');

  print('a : $a/ b : $b/ c : $c');

  KakaoSdk.init(
    nativeAppKey: a, //나중에 환경 변수로 빼자...
    javaScriptAppKey: b,
  );

  await NaverMapSdk.instance.initialize(
    clientId: c,
    onAuthFailed: (ex) {
      debugPrint("********* 네이버맵 인증오류 : $ex *********");
    },
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var fcmToken = await FirebaseMessaging.instance.getToken();
  UserSecureStorage _TokenStorage = UserSecureStorage();
  _TokenStorage.saveFcmToken(fcmToken!); // fcmToken 미리 저장.
  runApp(
    ProviderScope(child: MyApp()),
  );
  // 앱이 포그라운드에서 실행 중일 때 메시지 수신을 처리합니다.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Message received: ${message.notification?.title}");
  });

  // 앱이 백그라운드 상태에서 열릴 때 메시지 수신을 처리합니다.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Message clicked!");
    // 알림을 클릭하여 앱이 열렸을 때 처리할 작업을 정의합니다.
  });
  var keyHash = await KakaoSdk.origin;
  print("AAAAAAAAAAAAAAAAAAAAA");
  print(keyHash);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStart(context);
    });
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        fontFamily: 'NotoSansKR',
        textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 16.0),
            bodyMedium: TextStyle(fontSize: 14.0),
            bodySmall: TextStyle(fontSize: 12)
            // 다른 텍스트 스타일도 필요에 따라 추가
            ),
      ),
    );
  }
}

// 팀 존재 여부를 확인하는 메서드 (예시)
Future<bool> checkTeamExists() async {
  TeamApiService teamApi = TeamApiService();
  int teamId = await teamApi.getMyTeamId();
  return (teamId == -1) ? false : true; // 팀이 없다고 가정
}

void _handleTeamNavigation() async {
  bool teamExists = await checkTeamExists();
  if (teamExists) {
    router.go('/explore');
  } else {
    router.go('/select');
  }
}

Future<void> AppStart(BuildContext cococontext) async {
  UserSecureStorage userSecureStorage = UserSecureStorage();
  final id = await userSecureStorage.readAuthUuid();

  final accessToken = await userSecureStorage.readAccessToken();
  final vendor = await userSecureStorage.readVendor();
  final fcmToken = print("id : $id");
  print("accessToken : $accessToken");
  print("vendor : $vendor");

  if (id == null ||
      id.isEmpty ||
      accessToken == null ||
      accessToken.isEmpty ||
      vendor == null ||
      vendor.isEmpty) {
    print('id:$id');
    print('로그인 페이지로 가야함'); // 현 페이지에 가만히\
    // router
    //     .go('/explore'); // ----------------임시로 휴대폰에서 바로 들어가기 위해 --------------
  } else {
    print('id:$id');
    print('백엔드로 요청을 보내줘야 함');
    bool success = await autoLogin();
    // print('success : $success');
    if (success) {
      print('context.mounted : $cococontext.mounted');
      _handleTeamNavigation();
      // router.go('/explore');

      // print('explore페이지로 보내주기');
    } else {
      print('로그인 실패, 로그인 페이지로 이동'); // 현 페이지에 가만히
      // router.go(
      //     '/explore'); // ----------------임시로 휴대폰에서 바로 들어가기 위해 --------------
    }
  }
}
