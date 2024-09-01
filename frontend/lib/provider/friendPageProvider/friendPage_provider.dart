import 'package:frontend/model/friendPageModel/friendPage_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../dataSource/friendPageDataSource/friendPage_api.dart';

part 'friendPage_provider.g.dart';

@riverpod
FriendApiService getFriendApi(ref) {
  return FriendApiService();
}

@riverpod
class FriendListNotifier extends _$FriendListNotifier {
  @override
  Future<List<FriendPageModel>> build() async {
    final friendApi = ref.read(getFriendApiProvider);
    List<FriendPageModel> friendList = await friendApi.getFriendList();
    return friendList;
  }

  void updateFriendList() async {
    state = const AsyncLoading();

    try {
      final friendApi = ref.read(getFriendApiProvider);
      state = AsyncData(await friendApi.getFriendList());
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

@riverpod
class SearchFriendNotifier extends _$SearchFriendNotifier {
  @override
  AsyncValue<FriendPageModel>? build() {
    return null;
  }

  void searchFriend(String friendName) async {
    state = const AsyncLoading();
    print(friendName);
    try {
      final friendApi = ref.read(getFriendApiProvider);
      state = AsyncData(await friendApi.getFriend(friendName));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
