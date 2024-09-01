import 'package:frontend/dataSource/teamPageDataSource/teamGenPage_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/teamPageModel/teamGenPageInfo_model.dart';
import '../../../secureStroage/token_storage.dart';

part 'teamGenPage_provider.g.dart';

@riverpod
TeamGenApiService getTeamGenApi(ref) {
  return TeamGenApiService();
}

@riverpod
class TeamGenNotifier extends _$TeamGenNotifier {
  @override
  XFile? build() {
    return null;
  }

  void setImgFile(XFile img) {
    state = img;
  }

  Future<int?> generateTeam(XFile imgFile, TeamGenPageInfoModel teamInfo) async {
    final teamGenApi = ref.watch(getTeamGenApiProvider);
    UserSecureStorage userSecureStorage = UserSecureStorage();
    String? authUuid = await userSecureStorage.readAuthUuid();
    teamInfo.authUuid = authUuid!;
    print(teamInfo.authUuid);
    int? statusCode = await teamGenApi.generateTeam(imgFile, teamInfo);
    return statusCode;
  }
}
