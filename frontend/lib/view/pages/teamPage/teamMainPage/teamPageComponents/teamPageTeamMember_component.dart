import 'package:flutter/material.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/model/teamPageModel/teamPageMember_model.dart';

class TeamMemberComponent extends StatefulWidget {
  final TeamPageMemberModel member;

  const TeamMemberComponent({
    super.key,
    required this.member,
  });

  @override
  State<TeamMemberComponent> createState() => _TeamMemberComponentState();
}

class _TeamMemberComponentState extends State<TeamMemberComponent> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final member = widget.member;

    return Container(
      height: screenSize.height * 0.15,
      width: screenSize.width,
      padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      // 여기 이미지!!
                      // image: AssetImage(member.memberImage),
                      image: NetworkImage(
                          "$url/api/image/user/${member.memberName}"),
                      // 네트워크 이미지 URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned(
                //   top: screenSize.height * 0.01,
                //   right: screenSize.width * 0.01,
                //   child: Icon(
                //     Icons.circle,
                //     color: Colors.lightGreenAccent,
                //   ),
                // ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          child: Text(
                            member.memberName,
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenSize.height * 0.017,
                          right: 0,
                          child: Text(
                            '기여도: ${member.memberDistance.toStringAsFixed(2)}m',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(member.memberMemo),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
