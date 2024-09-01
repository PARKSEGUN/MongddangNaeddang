import 'package:flutter/material.dart';

class TeamRankComponent extends StatelessWidget {
  final int flexSize;
  final String category;
  final String value;

  const TeamRankComponent({
    super.key,
    required this.flexSize,
    required this.category,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Flexible(
      flex: flexSize,
      child: Container(
        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xffb88be7)
          ),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.fromLTRB(7, 0, 7, 0),
                color: Colors.white,
              ),
              Flexible(
                flex: 2,
                child: Container(
                  height: screenSize.height*0.05,
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenSize.width * 0.035,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}