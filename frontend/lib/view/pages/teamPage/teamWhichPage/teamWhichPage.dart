import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeamWhichPage extends StatelessWidget {
  const TeamWhichPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "몽땅내땅",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "처음이신가요?",
              style: TextStyle(
                fontSize: screenSize.width * 0.1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.07,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenSize.width * 0.27,
                  height: screenSize.width * 0.27,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/select/teamGen');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '팀 생성',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenSize.width * 0.05,
                ),
                SizedBox(
                  width: screenSize.width * 0.27,
                  height: screenSize.width * 0.27,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/select/teamSearch');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '팀 가입',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
