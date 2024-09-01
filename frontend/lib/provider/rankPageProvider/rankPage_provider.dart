import 'package:frontend/dataSource/rankPageDataSource/rankPage_api.dart';
import 'package:frontend/model/rankPageModel/rankPage_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rankPage_provider.g.dart';

@riverpod
RankApiService rankApi(ref){
  return RankApiService();
}

@riverpod
class TeamAreaRankPageNotifier extends _$TeamAreaRankPageNotifier{
  @override
  Future<List<RankPageModel>> build() async {
    final rankApi = ref.read(rankApiProvider);
    List<RankPageModel> areaRank = await rankApi.getTeamAreaRank();
    return areaRank;
  }

  void updateAreaRank() async {
    state = const AsyncLoading();

    try {
      final rankApi = ref.read(rankApiProvider);
      List<RankPageModel> tmp = await rankApi.getTeamAreaRank();
      state = AsyncData(tmp); // AsyncData() <-- 비동기 작업(Future)이 완료되었을 때
    } catch(e, stackTrace){
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
class TeamDistRankPageNotifier extends _$TeamDistRankPageNotifier{
  @override
  Future<List<RankPageModel>> build() async{
    final rankApi = ref.read(rankApiProvider);
    List<RankPageModel> distRank = await rankApi.getTeamDistRank();
    return distRank;
  }

  void updateDistAreaRank() async{
    state = const AsyncLoading();

    try {
      final rankApi = ref.read(rankApiProvider);
      List<RankPageModel> tmp = await rankApi.getTeamDistRank();
      state = AsyncData(tmp);
    } catch(e, stackTrace){
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
class UserDistRankPageNotifier extends _$UserDistRankPageNotifier{
  @override
  Future<List<RankPageModel>> build() async{
    final rankApi = ref.read(rankApiProvider);
    List<RankPageModel> userRank = await rankApi.getUserDistRank();
    return userRank;
  }

  void updateDistAreaRank() async{
    state = const AsyncLoading();

    try {
      final rankApi = ref.read(rankApiProvider);
      List<RankPageModel> tmp = await rankApi.getTeamDistRank();
      state = AsyncData(tmp);
    } catch (e, stackTrace){
      state = AsyncError(e, stackTrace);
    }
  }
}