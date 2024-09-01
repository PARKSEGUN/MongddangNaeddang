import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/model/myPageModel/user_model.dart';

part 'user_provider.g.dart';

final dio = Dio();
UserSecureStorage storage = UserSecureStorage();

@Riverpod(keepAlive: true) // 계속 유지할 수 있도록 keppAlive를 true로 함
class UserNotifier extends _$UserNotifier {
  @override
  UserModel build() {
    // 초기값 설정
    return UserModel(
      nickname: '',
      comment: null,
      address: null,
      profileImage: 'assets/profile.png', // imgUrl은 초기값을 설정해야 하므로 빈 문자열로 설정
      // teamId: -1, // teamId 초기값을 -1 -> 그룹없음
    );
  }

  // 유저 정보 변경 하는 부분
  Future<void> setUser(UserModel user) async {
    // 1. 백엔드에 정보 보내기
    final authUuid = await storage.readAuthUuid();
    final body = {
      'authUuid': authUuid,
      'nickname': user.nickname,
      'comment': user.comment,
      'address': user.address,
    };
    print('body: $body');
    try {
      final response = await dio.patch('$url/api/user/update', data: body);
      if (response.statusCode == 200) {
        print('유저 정보 업데이트 성공 ${response.data}');
        state = user;
      } else {
        print('유저 정보 업데이트 실패 ${response.statusCode}');
      }
    } catch (e) {
      print('유저 정보 업데이트 할때 에러 발생 : $e');
    }
  }

  // API 응답을 통해 사용자 정보를 업데이트하는 메서드
  Future<void> initializeUserInfo() async {
    UserSecureStorage _TokenStorage = UserSecureStorage();
    final authUuid = await _TokenStorage.readAuthUuid();
    print('------------------------------$authUuid');
    final body = {
      'authUuid': authUuid,
    };
    try {
      final response = await dio.post('$url/api/user/profile', data: body);
      if (response.statusCode == 200) {
        if (response.data != null) {
          UserModel user = UserModel(
            nickname: response.data['nickname'],
            comment: response.data['comment'],
            address: response.data['address'],
            profileImage: response.data['profileImage'],
          );
          print('User information fetched successfully');
          state = user;
        } else {
          print('유저 정보 가져오기 성공');
        }
      } else {
        print('내 정보 초기화 실패 : ${response.statusCode}');
      }
    } catch (e) {
      print('내 정보 초기화 실패 : $e');
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // 이미지 선택
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File chosenImage = File(image.path); // 선택된 이미지의 경로를 File 객체로 변환
      print('Selected image path: ${chosenImage.path}');
      await uploadImg(chosenImage); // Null이 아닌 File타입 이미지 업로드
    } else {
      print('No image selected');
    }
  }

  // 이미지를 업로드하는 함수
  Future<void> uploadImg(File image) async {
    UserSecureStorage _secureStorage = UserSecureStorage();
    final authUuid = await _secureStorage.readAuthUuid(); //이게 맞는지 확인이 필요함
    print('--------------------------------------');
    print(authUuid);
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
        print('Image uploaded successfully');
      } else {
        print('Image upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while uploading image: $e');
    }
  }

  Future<void> uploadUserInfo() async {
    // Future implementation for user info upload if needed
  }
}
@riverpod
Future<String?> getUuid(ref) async {
  UserSecureStorage storage = UserSecureStorage();
  final authUuid = await storage.readAuthUuid();
  return authUuid;
}