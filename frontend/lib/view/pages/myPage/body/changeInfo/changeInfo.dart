import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/logout_api.dart';
import 'package:frontend/model/myPageModel/user_model.dart';
import 'package:frontend/provider/userProvider/user_provider.dart';
import 'package:frontend/view/pages/myPage/body/changeInfo/changeImg.dart';

class ChangeInfo extends ConsumerStatefulWidget {
  final UserModel user; // UserModel 타입의 변수
  const ChangeInfo({super.key, required this.user});

  @override
  ConsumerState<ChangeInfo> createState() => _ChangeInfoState();
}

class _ChangeInfoState extends ConsumerState<ChangeInfo> {
  late TextEditingController _nicknameController;
  late TextEditingController _commentController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.user.nickname);
    _commentController = TextEditingController(text: widget.user.comment ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _commentController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // 변경된 내용을 user 모델에 저장
    final updatedUser = UserModel(
      nickname: _nicknameController.text,
      comment: _commentController.text,
      address: _addressController.text,
      profileImage: widget.user.profileImage, // 기존 이미지 유지
    );

    // Riverpod의 UserNotifier를 통해 상태 업데이트
    ref.read(userNotifierProvider.notifier).setUser(updatedUser);

    print('닉네임: ${updatedUser.nickname}');
    print('코멘트: ${updatedUser.comment}');
    print('주소: ${updatedUser.address}');
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChangeImg(), // 이미지 변경 위젯
        // 닉네임 입력 필드
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '닉네임',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLength: 10,
              ),
            ],
          ),
        ),
        // 코멘트 입력 필드
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '상태 메시지',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLength: 20,
              ),
            ],
          ),
        ),
        // 주소 입력 필드
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '주소',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLength: 20,
              ),
            ],
          ),
        ),
        // 변경하기 버튼
        OutlinedButton(
          onPressed: _saveChanges,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.deepPurple[300],
            side: const BorderSide(color: Colors.purple),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            '변경하기',
            style: TextStyle(fontSize: 25),
          ),
        ),
        OutlinedButton(
          onPressed: logout,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.deepPurple[300],
            side: const BorderSide(color: Colors.purple),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            '로그아웃',
            style: TextStyle(fontSize: 25),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
