import 'package:frontend/dataSource/teamPageDataSource/teamPage_api.dart';
import 'package:frontend/model/teamPageModel/teamPageMember_model.dart';
import 'package:frontend/model/teamPageModel/teamPageTeamInfo_model.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'teamPage_provider.g.dart';

@riverpod
TeamApiService getTeamApi(ref){
  return TeamApiService();
}

@riverpod
class TeamPageTeamInfoNotifier extends _$TeamPageTeamInfoNotifier{

  @override
  Future<TeamPageTeamInfoModel> build() async{
    TeamApiService teamApi = ref.read(getTeamApiProvider);
    int teamId = await teamApi.getMyTeamId();
    TeamPageTeamInfoModel teamInfo = await teamApi.getMyTeamInfo(teamId);
    return teamInfo;
  }

  void updateTeamInfo() async{
    state = const AsyncLoading();
    try {
      TeamApiService teamApi = ref.read(getTeamApiProvider);
      int teamId = await teamApi.getMyTeamId();
      TeamPageTeamInfoModel teamInfo = await teamApi.getMyTeamInfo(teamId);
      state = AsyncData(teamInfo);
    } catch (e, stackTrace){
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
class TeamPageTeamMemberNotifier extends _$TeamPageTeamMemberNotifier{
  @override
  Future<List<TeamPageMemberModel>> build() async{
    TeamApiService teamApi = ref.read(getTeamApiProvider);
    int teamId = await teamApi.getMyTeamId();
    List<TeamPageMemberModel> memberList = await teamApi.getMemberList(teamId);
    return memberList;
  }

  void updateMemberList() async{
    state = const AsyncLoading();

    try{
      TeamApiService teamApi = ref.read(getTeamApiProvider);
      int teamId = await teamApi.getMyTeamId();
      List<TeamPageMemberModel> memberList = await teamApi.getMemberList(teamId);
      state = AsyncData(memberList);
    } catch (e, stackTrace){
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
Future<void> teamLeave(ref) async {
  TeamApiService teamApi = ref.read(getTeamApiProvider);
  int teamId = await teamApi.getMyTeamId();
  UserSecureStorage storage = UserSecureStorage();
  String? authUuid = await storage.readAuthUuid();

  teamApi.teamLeave(authUuid!, teamId);
}