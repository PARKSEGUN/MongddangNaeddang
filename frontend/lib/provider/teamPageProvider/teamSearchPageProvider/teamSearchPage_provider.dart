import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/dataSource/teamPageDataSource/teamPage_api.dart';
import 'package:frontend/dataSource/teamPageDataSource/teamSearchPage_api.dart';
import 'package:frontend/model/teamPageModel/teamSearchPageTeamInfo_model.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'teamSearchPage_provider.g.dart';

@Riverpod(keepAlive: true)
TeamSearchApiService getSearchApi(ref) {
  return TeamSearchApiService();
}

@riverpod
class SearchedTeamNameNotifier extends _$SearchedTeamNameNotifier{
  @override
  String build(){
    return "";
  }

  void changeKeyword(String keyword){
    state = keyword;
  }
}

@riverpod
class SortTypeNotifier extends _$SortTypeNotifier{
  @override
  int build(){
    return 0;
  }

  void changeCategory(int sortType){
    state = sortType;
  }
}

@riverpod
class TogglePossibleTeamNotifier extends _$TogglePossibleTeamNotifier {
  @override
  bool build() {
    return false;
  }

  void toggleButton() {
    if (state == false) {
      state = true;
    } else {
      state = false;
    }
  }
}

@riverpod
class SearchTeamListBySortTypeNotifier extends _$SearchTeamListBySortTypeNotifier{
  @override
  Future<List<List<SearchPageTeamModel>>> build() async {
    final searchApi = ref.watch(getSearchApiProvider);
    final teamName = ref.watch(searchedTeamNameNotifierProvider);
    List<List<SearchPageTeamModel>> searchedLists = [[], [], []];

    try {
      searchedLists[0] = await searchApi.getSearchedTeamList(teamName, 0);
      searchedLists[1] = await searchApi.getSearchedTeamList(teamName, 1);
      searchedLists[2] = await searchApi.getSearchedTeamList(teamName, 2);
      return searchedLists;
    } catch (e){
      throw("엘라스틱에러일수밖에없는에러: $e");
    }
  }
}

@riverpod
Future<void> signUpTeam(ref) async {
  UserSecureStorage storage = UserSecureStorage();
  String? userId = await storage.readAuthUuid();
  final teamApi = TeamApiService();
  int teamId = await teamApi.getMyTeamId();
  final searchApi = ref.watch(getSearchApiProvider);

  try{
    searchApi.teamSignUp(userId, teamId);
  } catch(e){
    throw("집 가고 싶다: $e");
  }
}