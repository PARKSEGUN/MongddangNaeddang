import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/model/teamPageModel/teamGenPageInfo_model.dart';
import 'package:image_picker/image_picker.dart';

import '../api_url.dart';

class TeamGenApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: url));

  Future<int?> generateTeam(XFile imgFile, TeamGenPageInfoModel teamInfo) async {
    try {
      final formData = FormData.fromMap({
        'teamCreatePostReq': json.encode(teamInfo.toJson()),
        'teamLogo':
            await MultipartFile.fromFile(imgFile.path, filename: imgFile.name),
      });
      final response = await _dio.post('/api/team/create',
          data: formData,);

      return response.statusCode;
      // if (response.statusCode == 200){
      //   print("성공");
      // } else if (response.statusCode == 401){
      //   print("인증 오류");
      // } else if (response.statusCode == 404){
      //   print("사용자 없음");
      // } else if (response.statusCode == 500){
      //   print("서버 오류");
      // }
    } catch (e) {
      throw ("에러에러: $e");
    }
  }
}
