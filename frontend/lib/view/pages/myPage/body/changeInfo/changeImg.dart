import 'dart:io'; // File 클래스를 사용하기 위해 임포트

import 'package:dio/dio.dart'; // Dio 패키지 임포트
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위해 추가

import '../../../../../dataSource/api_url.dart';
import '../../../../../dataSource/myPageDataSource/getBadge_api.dart';
import '../../../../../provider/myPageProvider/myImage_provider.dart';
import '../../../../../secureStroage/token_storage.dart';

class ChangeImg extends ConsumerStatefulWidget {
  const ChangeImg({super.key});

  @override
  ConsumerState<ChangeImg> createState() => _ChangeImgState();
}

class _ChangeImgState extends ConsumerState<ChangeImg> {
  File? _image; // 선택된 이미지를 저장할 변수

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      ref.read(imageProvider.notifier).updateImage(imageBytes); // 상태 업데이트
      // 선택된 이미지를 File 객체로 변환
      _image = File(pickedFile.path);
      // 이미지 업로드 메서드 호출
      await uploadImg(_image!); // 이미지 업로드
    }
  }

  Future<void> uploadImg(File image) async {
    UserSecureStorage _secureStorage = UserSecureStorage();
    final authUuid = await _secureStorage.readAuthUuid(); // 이게 맞는지 확인이 필요함
    var formData = FormData.fromMap({
      'authUuid': authUuid,
      'image': await MultipartFile.fromFile(
        image.path,
        filename: 'a.jpg',
      ),
    });
    try {
      final response = await dio.patch(
        '$url/api/user/image',
        data: formData,
      );
      if (response.statusCode == 200) {
        print(response.data);
        print('성공된건가...?');
      } else {
        print('실패...');
      }
    } catch (e) {
      print('이미지 업로드 에러 : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return Consumer(
      builder: (context, ref, child) {
        final imageBytes = ref.watch(imageProvider); // 이미지 상태 가져오기
        return Container(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  child: imageBytes != null
                      ? Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                        )
                      : Center(child: Text('이미지가 없습니다.')),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectImage, // 버튼 클릭 시 이미지 선택
                child: Text('이미지 변경'),
              ),
            ],
          ),
        );
      },
    );
  }
}
