import 'package:frontend/dataSource/api_url.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:dio/dio.dart';


part 'myBadge_provider.g.dart';

final dio = Dio();

@Riverpod(keepAlive: true)
class BadgeNotifier extends _$BadgeNotifier {
  @override
  Future<List<int>> build() async {
    return await getBadges();
  }

  Future<List<int>> getBadges() async {
    UserSecureStorage _TokenStorage = UserSecureStorage();
    final authUuid = await _TokenStorage.readAuthUuid();

    final body = {
      'authUuid': authUuid,
    };

    try {
      final response = await dio.post(
        '$url/api/user/badge',
        data: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final List<int> myBadge = data.map((datum) => datum['badgeId'] as int).toList();
        return myBadge;
      } else {
        print('200말고 다른 코드들 들어옴 ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('뱃지 api 요청 오류 : $e');
      return [];
    }
  }
}
