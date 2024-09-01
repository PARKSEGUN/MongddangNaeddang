import 'package:flutter/material.dart';
import 'package:frontend/view/pages/myPage/header/myHeaderImg.dart';
import 'package:frontend/view/pages/myPage/header/myHeaderInfo.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Container(
      width: double.infinity, //좌우 꽉차게
      height: screenHeight*0.3,

      decoration: BoxDecoration(
        color: Colors.white30,
        border: Border(
          bottom: BorderSide(color: Colors.black)
        )
      ),

      child: Row(
        children: const [
          MyHeaderImg(),
          MyHeaderInfo(),
        ],
      ),
    );
  }
}
