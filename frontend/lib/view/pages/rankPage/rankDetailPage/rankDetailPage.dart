import 'package:flutter/material.dart';
import 'package:frontend/model/rankPageModel/rankPage_model.dart';

class RankDetailPage extends StatefulWidget {
  final category;
  final rankList;

  const RankDetailPage({
    super.key,
    required this.category,
    required this.rankList,
  });

  @override
  State<RankDetailPage> createState() => _RankDetailPageState();
}

class _RankDetailPageState extends State<RankDetailPage> {
  String makePodiumContent(final ranks) {
    if (ranks.unit == -1) {
      return "";
    }
    if (widget.category == "area") {
      return "${ranks.name}\n${ranks.unit.toStringAsFixed(0)}㎡";
    } else if (widget.category == "dist") {
      return "${ranks.name}\n${ranks.unit.toStringAsFixed(0)}m";
    } else if (widget.category == "user") {
      return "${ranks.name}\n${ranks.unit.toStringAsFixed(0)}m";
    } else {
      return "error";
    }
  }

  String makePodiumImage(final ranks) {
    if (ranks.unit == -1) {
      return "";
    }
    if (widget.category == "area" || widget.category == "dist") {
      return "http://i11a802.p.ssafy.io:80/api/image/team/name/${ranks.name}";
    } else if (widget.category == "user") {
      return "http://i11a802.p.ssafy.io:80/api/image/user/${ranks.name}";
    } else {
      return "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final height = constraints.maxHeight;
                        final width = constraints.maxWidth;

                        if (widget.rankList.length > 1) {
                          return podium(
                              width, height, 0.4, 2, widget.rankList[1]);
                        } else {
                          return podium(
                              width,
                              height,
                              0.4,
                              2,
                              RankPageModel(
                                  name: '', comment: '', logo: '', unit: -1));
                        }
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final height = constraints.maxHeight;
                        final width = constraints.maxWidth;

                        if (widget.rankList.length > 0) {
                          return podium(
                              width, height, 0.5, 1, widget.rankList[0]);
                        } else {
                          return podium(
                              width,
                              height,
                              0.5,
                              1,
                              RankPageModel(
                                  name: '', comment: '', logo: '', unit: -1));
                        }
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final height = constraints.maxHeight;
                        final width = constraints.maxWidth;

                        if (widget.rankList.length > 2) {
                          return podium(
                              width, height, 0.4, 3, widget.rankList[2]);
                        } else {
                          return podium(
                              width,
                              height,
                              0.4,
                              3,
                              RankPageModel(
                                  name: '', comment: '', logo: '', unit: -1));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final height = constraints.maxHeight;
                        final width = constraints.maxWidth;

                        return Container(
                          height: height,
                          width: width,
                          child: Row(
                            children: [
                              tableComponent(2, "순위", width, 0.03),
                              tableComponent(6, "팀 이름", width, 0.03),
                              tableComponent(6, "단위", width, 0.03)
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        if (widget.rankList.length > 3) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffdbcdff),
                            ),
                            child: ListView.builder(
                              itemCount: widget.rankList.length - 3,
                              itemBuilder: (context, index) {
                                return rankComponent(widget.rankList[index + 3],
                                    index + 4, width);
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableComponent(
      int flex, String content, double width, double textRatio) {
    return Flexible(
      flex: flex,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            alignment: Alignment.center,
            width: constraints.maxWidth,
            child: Text(
              content,
              style: TextStyle(
                fontSize: width * textRatio,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget rankComponent(final element, int rank, double width) {
    String name = element.name;
    double value = element.unit;

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            tableComponent(2, rank.toString(), width, 0.04),
            tableComponent(6, name, width, 0.04),
            tableComponent(
                6,
                (widget.category == 'area')
                    ? "${value.toStringAsFixed(0)}㎡"
                    : "${value.toStringAsFixed(0)}m",
                width,
                0.04),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget podium(
      double width, double height, double ratio, int grade, final element) {
    //String logo = element.logo;
    String content = makePodiumContent(element);
    String imgUrl = makePodiumImage(element);

    return Column(
      children: [
        SizedBox(
          width: width,
          height: height * (1 - ratio),
          child: Stack(
            children: [
              if (element.unit != -1)
                Positioned(
                  left: width * 0.2,
                  bottom: height * 0.03,
                  child: ClipOval(
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      width: width * 0.6,
                      height: width * 0.6,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/temp/noImg.png");
                      },
                    ),
                  ),
                )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Color(0xffffda64),
              border: Border.all(color: Color(0xfffda644), width: 2.5)),
          height: height * ratio,
          width: width,
          child: Column(
            children: [
              Text(
                '$grade',
                style: TextStyle(
                  fontSize: width * 0.15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ],
    );
  }
}
