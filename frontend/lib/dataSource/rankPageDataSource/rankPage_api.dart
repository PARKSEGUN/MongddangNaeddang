import 'package:dio/dio.dart';
import 'package:frontend/model/rankPageModel/rankPage_model.dart';

import '../api_url.dart';

class RankApiService{
  final Dio _dio = Dio(BaseOptions(baseUrl: url));
  
  Future<List<RankPageModel>> getTeamAreaRank() async{
    try{
      final response = await _dio.get('/api/rank/team/area');
      List<RankPageModel> areaRank = (response.data as List).map((json) => RankPageModel.fromJson(json)).toList();
      return areaRank;
    } catch(e){
      throw Exception('에러에러에러: $e');
    }
  }

  Future<List<RankPageModel>> getTeamDistRank() async{
    try{
      final response = await _dio.get('/api/rank/team/distance');
      List<RankPageModel> distRank = (response.data as List).map((json)=>RankPageModel.fromJson(json)).toList();
      return distRank;
    } catch(e){
      throw Exception('에러에러에러2: $e');
    }
  }
  
  Future<List<RankPageModel>> getUserDistRank() async{
    try{
      final response = await _dio.get('/api/rank/user/distance');
      List<RankPageModel> userRank = (response.data as List).map((json)=>RankPageModel.fromJson(json)).toList();
      return userRank;
    } catch(e){
      throw Exception('에러에러에러3: $e');
    }
  }
}