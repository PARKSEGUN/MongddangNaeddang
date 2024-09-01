import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/friendPageDataSource/friendPage_api.dart';
import 'package:frontend/model/friendPageModel/friendPage_model.dart';
import 'package:frontend/provider/friendPageProvider/friendPage_provider.dart';
import 'package:frontend/sharedView/navBar.dart';
import 'package:go_router/go_router.dart';

import '../../../dataSource/api_url.dart';
import '../../../sharedView/customAppBar.dart';

class FriendPage extends ConsumerStatefulWidget {
  const FriendPage({super.key});

  @override
  ConsumerState<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends ConsumerState<FriendPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final friendList = ref.watch(friendListNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: friendList.when(data: (friendList) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "친구",
                    style: TextStyle(
                      fontSize: width * 0.1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).push("/friend/addFriend");
                    },
                    iconSize: width * 0.1,
                    icon: Icon(
                      Icons.person_add,
                    ),
                  ),
                ],
              ),
            ),
            if (friendList.length == 0)
              Expanded(
                child: Center(
                  child: Text("친구가 없습니다."),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: friendList.length,
                    itemBuilder: (context, index) {
                      return oneFriend(friendList[index], width, height);
                    },
                  ),
                ),
              ),
          ],
        );
      }, error: (e, stackTrace) {
        throw Exception("에러$e");
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
      bottomNavigationBar: NavBar(),
    );
  }

  Widget oneFriend(FriendPageModel friend, double width, double height) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: width,
      height: height * 0.15,
      child: Container(
        color: Color(0xffdbcdff),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  return Container(
                    width: width,
                    padding: EdgeInsets.fromLTRB(width * 0.1, 0, 0, 0),
                    child:
                        Image.network('$url/api/image/user/${friend.nickname}'),
                  );
                },
              ),
            ),
            Flexible(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;

                  return SizedBox(
                    width: width,
                    height: height,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.15,
                        ),
                        Text(
                          friend.nickname,
                          style: TextStyle(
                            fontSize: height * 0.1,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        Container(
                          width: width * 0.9,
                          height: height * 0.4,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            friend.comment,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;

                  return SizedBox(
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.1,
                        ),
                        Text(
                          "총 뛴 거리",
                          style: TextStyle(
                            fontSize: height * 0.1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        SizedBox(
                          height: height * 0.2,
                          child: Text(
                            "${friend.totalDistance.toStringAsFixed(2)}m",
                            style: TextStyle(fontSize: height * 0.1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: height * 0.35,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Color(0xffc8baec)),
                            ),
                            onPressed: () async {
                              final friendApi = FriendApiService();
                              await friendApi.friendRemove(friend.nickname);
                              ref
                                  .read(friendListNotifierProvider.notifier)
                                  .updateFriendList();
                            },
                            child: Text("삭제"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
