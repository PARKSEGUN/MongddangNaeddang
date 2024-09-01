import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navBar_provider.g.dart';

@riverpod
class CurrentIndexNotifier extends _$CurrentIndexNotifier{

  @override
  int build(){
    return 0;
  }

  void changeIndex(int index){
    state = index;
  }
}