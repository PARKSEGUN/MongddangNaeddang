import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/view/pages/teamPage/teamMainPage/teamPageComponents/teamPageTeamMember_component.dart';

class TeamMemberList extends ConsumerStatefulWidget {
  final memberList;

  const TeamMemberList({
    super.key,
    required this.memberList,
  });

  @override
  ConsumerState<TeamMemberList> createState() => _TeamMemberListState();
}

class _TeamMemberListState extends ConsumerState<TeamMemberList> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // final memberList = ref.watch(getTeamPageMemberInfoProvider);
    final memberList = widget.memberList;

    return Container(
      width: screenSize.width,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Color(0xffdbcdff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      'Team Member',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenSize.height * 0.003,
                    right: screenSize.width * 0.01,
                    child: SizedBox(
                      width: screenSize.width * 0.2,
                      child: Text(
                        '팀원 수: ${memberList.length}', // 여기에 받아온 팀원 수를 뿌린다.
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: screenSize.width * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (memberList.length == 0)
            Flexible(
              flex: 9,
              child: Center(child: Text("팀원이 존재하지 않습니다.")),
            )
          else
            Flexible(
              flex: 9,
              child: ListView.builder(
                itemCount: memberList.length,
                itemBuilder: (context, index) {
                  return TeamMemberComponent(
                    member: memberList[index],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
