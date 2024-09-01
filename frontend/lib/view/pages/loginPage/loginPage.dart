import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/dataSource/kakaoLogin_api.dart';

import '../../../dataSource/naverLogin_api.dart';
import '../../../dataSource/teamPageDataSource/teamPage_api.dart';
import '../../../router/app_router.dart';

var dio = Dio(); //일단 쓰려고

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Color(0x65558F).withOpacity(0.7),

          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/map_img.png'), // 배경 이미지 경로
              fit: BoxFit.cover, // 이미지가 컨테이너를 채우도록 설정
              colorFilter: ColorFilter.mode(
                Color(0xFF65558F).withOpacity(0.6), // 이미지 위에 불투명도 설정
                BlendMode.darken, // 이미지 위에 어둡게 처리
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 수직 방향 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가로 방향 중앙 정렬
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0), // 마진 설정
                child: Image.asset(
                  'assets/startPage.png',
                  width: 350,
                ),
              ),
              // 이미지 경로
              // 경로에 따라 수정 필요
              // Text(
              //   '몽땅내땅',
              //   style: TextStyle(
              //     fontWeight: FontWeight.w700,
              //     fontSize: 40.0,
              //     color: Colors.white,
              //   ),
              // ),
              SizedBox(
                height: 50,
              ),
              kakaoLoginButton(context),
              SizedBox(
                height: 5,
              ),
              naverLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

//카카오 로그인 버튼
  Widget kakaoLoginButton(BuildContext context) {
    return InkWell(
        onTap: () async {
          bool success = await signWithKakao(); // 로그인 성공 여부를 반환하도록 수정
          if (success) {
            _handleTeamNavigation();
            // context.go('/explore'); // 로그인 성공 시 /explore로 이동
          } else {
            // 로그인 실패 시 처리 (예: 에러 메시지 표시)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 실패, 다시 시도해 주세요.')),
            );
          }
        },
        child: Image.asset(
          'assets/kakao_login_3.png',
          width: 200,
        ));
  }

//naver 로그인 버튼
  Widget naverLoginButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool success = await signWithNaver(); // 로그인 성공 여부를 반환하도록 수정
        if (success) {
          if (!context.mounted) return;
          _handleTeamNavigation();
        } else {
          // 로그인 실패 시 처리 (예: 에러 메시지 표시)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패, 다시 시도해 주세요.')),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/naver_login_3.png',
            width: 200,
          ),
        ],
      ),
    );
  }
}
