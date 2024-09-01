import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'myPage_provider.g.dart';

@riverpod
class MyIndexNotifier extends _$MyIndexNotifier {
  // 초기 인덱스를 0으로 주기
  @override
  int build() {
    return 0;
  }
  // 버튼 눌러서 인덱스를 주면 인덱스를 업데이트 시키는 메소드
  void updateIndex(int newIndex) {
    state = newIndex;
  }
}