import 'package:flutter/material.dart';
import 'package:frontend/view/pages/loginPage/loginPage.dart';

class Record extends StatelessWidget {
  const Record({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '활동량',
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
