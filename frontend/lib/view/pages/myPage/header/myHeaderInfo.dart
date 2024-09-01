import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/myPageModel/user_model.dart';
import 'package:frontend/provider/myPageProvider/myPage_provider.dart';
import 'package:frontend/provider/userProvider/user_provider.dart';

class MyHeaderInfo extends ConsumerWidget {
  const MyHeaderInfo({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {


    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    final myIndex = ref.watch(myIndexNotifierProvider);
    final user =
        ref.watch(userNotifierProvider); //userNotifierProvider에서 유저 정보 가져오기

    return SizedBox(
      height: double.infinity,
      width: screenWidth * 0.6,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Expanded(
              child: FittedBox(
                child: Text(
                  '${user.nickname} 님',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Center(
                child: Expanded(
                    child: Text('${user?.comment}',
                      style: TextStyle(fontSize: 20),

            ))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: screenWidth*0.17,
                height: screenSize.height*0.05,
                child: OutlinedButton(
                  onPressed: () {
                    //누르면 인덱스 0으로 바꿈
                    ref
                        .read(myIndexNotifierProvider.notifier) //알림 읽기
                        .updateIndex(0); //인덱스를 변경하기
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor:
                    myIndex == 0 ? Colors.deepPurple[300] : Colors.purple[50],
                    //배경색
                    side: BorderSide(color: Colors.purple),
                    //Border색
                    foregroundColor: myIndex == 0 ? Colors.white : Colors.black,
                    //글자색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글기 조절
                    ),
                  ),
                  child: Text(
                      '기록',
                      style: TextStyle(fontSize: screenWidth * 0.03)),
                ),
              ),
              SizedBox(
                width: screenWidth*0.17,
                height: screenSize.height*0.05,
                child: OutlinedButton(
                  onPressed: () {
                    //누르면 인덱스 0으로 바꿈
                    ref.read(myIndexNotifierProvider.notifier).updateIndex(1);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor:
                    myIndex == 1 ? Colors.deepPurple[300] : Colors.purple[50],
                    side: BorderSide(color: Colors.purple),
                    foregroundColor: myIndex == 1 ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글기 조절
                    ),
                  ),
                  child: Text(
                      '콜렉터',
                      style: TextStyle(fontSize: screenWidth * 0.03)),
                ),
              ),
              SizedBox(
                width: screenWidth*0.17,
                height: screenSize.height*0.05,
                child: OutlinedButton(
                  onPressed: () {
                    //누르면 인덱스 0으로 바꿈
                    ref.read(myIndexNotifierProvider.notifier).updateIndex(2);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor:
                    myIndex == 2 ? Colors.deepPurple[300] : Colors.purple[50],
                    side: BorderSide(color: Colors.purple),
                    foregroundColor: myIndex == 2 ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 버튼 모서리 둥글기 조절
                    ),
                  ),
                  child: Text(
                      '정보 수정',
                      style: TextStyle(fontSize: screenWidth * 0.03),

                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
