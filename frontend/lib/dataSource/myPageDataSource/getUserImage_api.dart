import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:http/http.dart' as http;

import '../../provider/myPageProvider/myImage_provider.dart';
import '../../provider/userProvider/user_provider.dart';

final dio = Dio();

Future<void> getUserImage(WidgetRef ref) async {
  // userNotifierProvider에서 유저 정보 가져오기
  final userNickname = ref.watch(userNotifierProvider).nickname;

  // 필요한 경우 user 정보를 API 호출에 포함
  // 예: user의 ID를 사용하여 API 호출
  final response =
      await http.get(Uri.parse('$url/api/image/user/$userNickname')); // API URL

  if (response.statusCode == 200) {
    Uint8List imageBytes = response.bodyBytes; // 바이트 데이터 가져오기
    ref.read(imageProvider.notifier).updateImage(imageBytes); // 상태 업데이트
  } else {
    throw Exception('이미지 로드 실패: ${response.statusCode}');
  }
}
