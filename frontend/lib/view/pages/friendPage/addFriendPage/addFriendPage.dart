import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/dataSource/friendPageDataSource/friendPage_api.dart';
import 'package:frontend/model/friendPageModel/friendPage_model.dart';
import 'package:frontend/provider/friendPageProvider/friendPage_provider.dart';

import '../../../../dataSource/api_url.dart';
import '../../../../sharedView/navBar.dart';

class AddFriendPage extends ConsumerStatefulWidget {
  const AddFriendPage({super.key});

  @override
  ConsumerState<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends ConsumerState<AddFriendPage> {
  late TextEditingController _controller;
  String _friendKeyword = "";
  MediaQueryData? _mediaQueryData; // MediaQueryData를 저장할 변수

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearInput() {
    _controller.clear();
    setState(() {
      _friendKeyword = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // 화면 높이
    final width = MediaQuery.of(context).size.width; // 화면 너비
    final searchedFriend = ref.watch(searchFriendNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(friendListNotifierProvider.notifier).updateFriendList();
            Navigator.of(context).pop(); // context.pop() 대신 Navigator 사용
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: height,
        width: width,
        child: Column(
          children: [
            Text(
              '친구 추가',
              style: TextStyle(
                fontSize: width * 0.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 5,
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        _friendKeyword = value; // 입력된 값 저장
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "친구 검색",
                      suffixIcon: _friendKeyword.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _clearInput,
                            )
                          : null,
                    ),
                    // onEditingComplete: () {
                    //   FocusScope.of(context).unfocus();
                    //   setState(() {
                    //     print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                    //     _friendKeyword = _controller.text;
                    //   });
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '검색할 친구 이름을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(searchFriendNotifierProvider.notifier)
                          .searchFriend(_friendKeyword);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0.8,
                    ),
                    child: Icon(Icons.search),
                  ),
                )
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            if (searchedFriend is AsyncError)
              Center(
                child: Text("정확한 닉네임을 입력해주세요."),
              )
            else if (searchedFriend is AsyncLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (searchedFriend is AsyncData<FriendPageModel>)
              oneFriend(searchedFriend.value, width, height)
            else
              Container()
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }

  Widget oneFriend(final friend, double width, double height) {
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
                  final width = constraints.maxWidth;
                  return Container(
                    width: width,
                    padding: EdgeInsets.fromLTRB(width * 0.1, 0, 0, 0),
                    child: Image.network(
                      "$url/api/image/user/${friend.nickname}",
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/temp/noImg.png");
                      },
                    ),
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
                          height: height * 0.17,
                        ),
                        Text(
                          friend.nickname,
                          style: TextStyle(
                            fontSize: height * 0.13,
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

                  return Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: ElevatedButton(
                      onPressed: () {
                        final friendApi = FriendApiService();
                        friendApi.friendRequest(friend.nickname);
                      },
                      child: Text(
                        "친구 신청",
                        style: TextStyle(
                          fontSize: width * 0.105,
                        ),
                      ),
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
