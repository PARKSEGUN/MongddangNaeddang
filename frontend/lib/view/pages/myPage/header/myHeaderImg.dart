import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/myPageDataSource/getUserImage_api.dart';
import '../../../../provider/myPageProvider/myImage_provider.dart';

class MyHeaderImg extends ConsumerWidget {
  const MyHeaderImg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    // 이미지 상태 가져오기
    final imageBytes = ref.watch(imageProvider);

    // 이미지를 비동기로 가져오는 메서드
    Future<void> loadImage() async {
      await getUserImage(ref); // 이미지 가져오기
    }

    // 처음 빌드 시 이미지를 로드
    if (imageBytes == null) {
      loadImage();
    }

    return Container(
      width: screenWidth * 0.4,
      height: double.infinity,
      child: Center(
        child: CircleAvatar(
          radius: screenWidth * 0.175, // 직경의 절반
          backgroundColor: Colors.grey[300], // 배경색 설정 (선택사항)
          child: imageBytes != null
              ? ClipOval(
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              width: screenWidth * 0.35,
              height: screenWidth * 0.35,
            ),
          )
              : CircularProgressIndicator(), // 로딩 중 표시
        ),
      ),
    );
  }
}