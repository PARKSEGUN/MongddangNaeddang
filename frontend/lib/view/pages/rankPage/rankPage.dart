import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/rankPageModel/rankPage_model.dart';
import 'package:frontend/provider/rankPageProvider/rankPage_provider.dart';
import 'package:frontend/sharedView/customAppBar.dart';
import 'package:frontend/sharedView/navBar.dart';
import 'package:frontend/view/pages/rankPage/rankDetailPage/rankDetailPage.dart';

class RankPage extends ConsumerStatefulWidget {
  const RankPage({super.key});

  @override
  ConsumerState<RankPage> createState() => _RankPageState();
}

class _RankPageState extends ConsumerState<RankPage> {
  int category = 0;

  @override
  Widget build(BuildContext context) {
    final areaRankList = ref.watch(teamAreaRankPageNotifierProvider);
    final teamDistRankList = ref.watch(teamDistRankPageNotifierProvider);
    final userDistRankList = ref.watch(userDistRankPageNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        category = 0;
                      });
                    },
                    child: Text('팀 면적 랭킹'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        category = 1;
                      });
                    },
                    child: Text('팀 거리 랭킹'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        category = 2;
                      });
                    },
                    child: Text('개인 랭킹'),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 10,
            child: category == 0
                ? rankDetailPageBuilder(areaRankList, 'area')
                : category == 1
                    ? rankDetailPageBuilder(teamDistRankList, 'dist')
                    : category == 2
                        ? rankDetailPageBuilder(userDistRankList, 'user')
                        : Container(),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }

  Widget rankDetailPageBuilder(final rankList, String category) {
    if (rankList is AsyncLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (rankList is AsyncError) {
      return Center(child: Text('에러에러: ${rankList.error}'));
    } else if (rankList is AsyncData<List<RankPageModel>>) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: RankDetailPage(
          category: category,
          rankList: rankList.value,
        ),
      );
    } else {
      return Container();
    }
  }
}
