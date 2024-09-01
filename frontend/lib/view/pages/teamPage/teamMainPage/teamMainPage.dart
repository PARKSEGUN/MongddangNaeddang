import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/teamPageProvider/teamPage_provider.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:frontend/view/pages/teamPage/teamMainPage/teamPageMemberList.dart';
import 'package:frontend/view/pages/teamPage/teamMainPage/teamPageTeamInfo.dart';

class TeamMainPage extends ConsumerStatefulWidget {
  final Size screenSize;

  const TeamMainPage({
    super.key,
    required this.screenSize,
  });

  @override
  ConsumerState<TeamMainPage> createState() => _TeamMainPageState();
}

class _TeamMainPageState extends ConsumerState<TeamMainPage> {
  @override


  @override
  Widget build(BuildContext context) {
    final teamInfo = ref.watch(teamPageTeamInfoNotifierProvider);
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print(teamInfo);
    final memberList = ref.watch(teamPageTeamMemberNotifierProvider);

    // teamInfo 외에 팀 멤버도 추가해서 로딩중인지 아닌지 체크
    return teamInfo.when(data: (teamInfo) {
      return memberList.when(data: (memberList) {

        return SizedBox(
          width: widget.screenSize.width,
          height: widget.screenSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  flex: 3,
                  child: TeamInfo(
                    teamInfo: teamInfo,
                    memberList: memberList,
                  )),
              Flexible(
                  flex: 4,
                  child: TeamMemberList(
                    memberList: memberList,
                  )),
            ],
          ),
        );
      }, error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text("에러: $error"),
        );
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      });
    }, error: (Object error, StackTrace stackTrace) {
      return Center(
        child: Text("에러에러: $error"),
      );
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(),
      );
    });

    // if (teamInfo is AsyncLoading || memberList is AsyncLoading) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    // return Center(child: Text("에러가 발생했습니다."),);
  }
}
