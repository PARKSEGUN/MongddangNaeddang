import 'package:flutter/material.dart';
import 'package:frontend/sharedView/customAppBar.dart';
import 'package:frontend/sharedView/navBar.dart';
import 'package:frontend/view/pages/teamPage/teamMainPage/teamMainPage.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(),
      body: TeamMainPage(
        screenSize: screenSize,
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
