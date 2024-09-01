import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/myPageProvider/myPage_provider.dart';
import 'package:frontend/provider/userProvider/user_provider.dart';
import 'package:frontend/sharedView/customAppBar.dart';
import 'package:frontend/sharedView/navBar.dart';
import 'package:frontend/view/pages/myPage/body/changeInfo/changeInfo.dart';
import 'package:frontend/view/pages/myPage/body/collect/collect.dart';
import 'package:frontend/view/pages/myPage/body/record/lineChartSample2.dart';
import 'package:frontend/view/pages/myPage/body/record/record.dart';
import 'package:frontend/view/pages/myPage/header/myHeader.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    ref.read(userNotifierProvider.notifier).initializeUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final myIndex = ref.watch(myIndexNotifierProvider);
    final user = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          MyHeader(), // 고정된 헤더
          Expanded(
            child: Column(
              children: [
                // myIndex에 따라 다른 위젯을 표시
                if (myIndex == 0) ...[
                  Record(),
                  LineChartSample2(),
                ] else if (myIndex == 1)
                  Expanded(child: Collect())
                else
                  Expanded(
                    child: SingleChildScrollView(child: ChangeInfo(user: user)),
                  )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
