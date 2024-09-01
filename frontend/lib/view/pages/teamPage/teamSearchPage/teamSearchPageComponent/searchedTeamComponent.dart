import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/teamPageDataSource/teamSearchPage_api.dart';
import 'package:frontend/model/teamPageModel/teamSearchPageTeamInfo_model.dart';
import 'package:frontend/provider/teamPageProvider/teamSearchPageProvider/teamSearchPage_provider.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../../dataSource/api_url.dart';

class SearchedTeamComponent extends ConsumerStatefulWidget {
  final SearchPageTeamModel searchedTeam;

  const SearchedTeamComponent({
    super.key,
    required this.searchedTeam,
  });

  @override
  ConsumerState<SearchedTeamComponent> createState() =>
      _SearchedTeamComponentState();
}

class _SearchedTeamComponentState extends ConsumerState<SearchedTeamComponent> {
  void _showDialog(BuildContext context, SearchPageTeamModel team) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('팀 가입 신청'),
          content: Text('${widget.searchedTeam.name}에 가입하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () async {
                final searchApi = TeamSearchApiService();
                int? statusCode = await searchApi.teamSignUp(team.teamId);
                if (statusCode == 200) {
                  GoRouter.of(context).go('/explore');
                }
              }, // 신청 notifier하고 서버쪽에 요청해야 함.
              child: Text('신청'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SearchPageTeamModel searchedTeam = widget.searchedTeam;
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SizedBox(
        height: screenSize.height * 0.15,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "$url/api/image/team/${searchedTeam.teamId}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/temp/noImg.png");
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Text(
                            searchedTeam.name.length < 20
                                ? searchedTeam.name
                                : searchedTeam.name.substring(0, 21),
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                            ),
                          ),
                          Text(
                            searchedTeam.comment.length < 20
                                ? searchedTeam.comment
                                : searchedTeam.comment.substring(0, 21),
                            style: TextStyle(
                              fontSize: screenSize.width * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenSize.height * 0.005,
                                          ),
                                          Text(
                                            '면적 랭킹',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.01,
                                          ),
                                          Text(
                                            '${searchedTeam.areaRank}위',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenSize.height * 0.005,
                                          ),
                                          Text(
                                            '거리 랭킹',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenSize.height * 0.01,
                                          ),
                                          Text(
                                            '${searchedTeam.distRank}위',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenSize.width * 0.03,
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
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () => _showDialog(context, searchedTeam),
                                child: Text('가입 신청'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
