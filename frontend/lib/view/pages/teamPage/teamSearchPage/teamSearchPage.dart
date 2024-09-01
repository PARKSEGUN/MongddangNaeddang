import 'package:flutter/material.dart';
import 'package:frontend/view/pages/teamPage/teamSearchPage/teamSearchPageLower.dart';
import 'package:frontend/view/pages/teamPage/teamSearchPage/teamSearchPageUpper.dart';
import 'package:go_router/go_router.dart';

class TeamSearchPage extends StatefulWidget {
  const TeamSearchPage({super.key});

  @override
  State<TeamSearchPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamSearchPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: TeamSearchUpper(
                screenSize: screenSize,
              ),
            ),
            Flexible(
              flex: 4,
              child: TeamSearchLower(
                screenSize: screenSize,
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: NavBar(),
    );
  }
}
