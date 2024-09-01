import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/dataSource/teamPageDataSource/teamPage_api.dart';
import 'package:frontend/model/teamPageModel/teamPageMember_model.dart';
import 'package:frontend/provider/teamPageProvider/teamPage_provider.dart';
import 'package:frontend/provider/userProvider/user_provider.dart';
import 'package:frontend/view/pages/teamPage/teamMainPage/teamPageComponents/teamPageTeamRank_component.dart';
import 'package:go_router/go_router.dart';

class TeamInfo extends ConsumerStatefulWidget {
  final teamInfo;
  final memberList;

  const TeamInfo({
    super.key,
    required this.teamInfo,
    required this.memberList,
  });

  @override
  ConsumerState<TeamInfo> createState() => _TeamInfoState();
}

class _TeamInfoState extends ConsumerState<TeamInfo> {
  int hexStringToInt(String hexString) {
    return int.parse(hexString.replaceFirst('#', ''), radix: 16);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final teamInfo = widget.teamInfo;
    List<TeamPageMemberModel> memberList = widget.memberList;

    return Container(
      // height: 300,
      width: screenSize.width,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Color(0xffdbcdff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        // 팀정보
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                //color: Colors.deepPurple, // 팀 색으로 바꿔주기
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                // 팀 이름
                children: <Widget>[
                  // SizedBox(
                  //   height: double.infinity,
                  //   width: double.infinity,
                  // ),
                  Positioned(
                    left: screenSize.width * 0.01,
                    child: Text(
                      widget.teamInfo.teamName,
                      style: TextStyle(
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  Positioned(
                    top: screenSize.height * 0,
                    right: screenSize.width * 0,
                    child: SizedBox(
                      height: screenSize.height * 0.03,
                      width: screenSize.width * 0.15,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(0),
                        ).copyWith(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          )
                        ),
                        onPressed: () {
                          ref.read(teamLeaveProvider);
                          GoRouter.of(context).go('/select');
                        },
                        child: Text(
                          "탈퇴",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Flexible(
            // 팀정보 상단
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  Container(
                    // 팀 이미지
                    width: screenSize.width * 0.2,
                    height: screenSize.width * 0.2,
                    decoration: BoxDecoration(
                      // 색을 hex로 받아야 하는데;;
                      color: Color(hexStringToInt(widget.teamInfo.teamColor)),
                      // color: Color(0xff340c9b),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: ClipOval(
                        // 팀 이미지도 이거 아님;;asset아님
                        child: Image.network(
                          // widget.teamInfo.teamLogo,
                          '$url/api/image/team/${teamInfo.teamID}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/temp/noImg.png');
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: Colors.black, width: 2),
                          color: Color(0xffffffff)),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
                            child: Text(
                              '[한 마디]',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenSize.width * 0.04,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
                            child: Text(
                              widget.teamInfo.teamMemo,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenSize.width * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3, // 팀 정보 중간
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  TeamRankComponent(
                      flexSize: 1,
                      category: '팀 면적',
                      value:
                          '${widget.teamInfo.areaSum.toStringAsFixed(0)}\n㎡'),
                  TeamRankComponent(
                      flexSize: 1,
                      category: '팀 거리',
                      value:
                          '${widget.teamInfo.distanceSum.toStringAsFixed(0)}\nm'),
                  TeamRankComponent(
                      flexSize: 1,
                      category: '면적 랭킹',
                      value: '${widget.teamInfo.teamAreaRank}\n위'),
                  TeamRankComponent(
                      flexSize: 1,
                      category: '거리 랭킹',
                      value: '${widget.teamInfo.teamDistRank}\n위'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
