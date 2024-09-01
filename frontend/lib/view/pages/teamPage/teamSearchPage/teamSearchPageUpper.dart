import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/teamPageProvider/teamSearchPageProvider/teamSearchPage_provider.dart';

class TeamSearchUpper extends ConsumerStatefulWidget {
  final screenSize;

  const TeamSearchUpper({
    super.key,
    required this.screenSize,
  });

  @override
  ConsumerState<TeamSearchUpper> createState() => _TeamSearchUpperState();
}

class _TeamSearchUpperState extends ConsumerState<TeamSearchUpper> {
  final _key = GlobalKey<FormState>();
  var _teamNameKeyword = "";

  @override
  Widget build(BuildContext context) {
    final width = widget.screenSize.width;

    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '팀 검색',
                style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Form(
                    key: _key,
                    child: TextFormField(
                      // controller: _controller,
                      // focusNode: _focusNode,
                      onChanged: (value) {
                        setState(() {
                          _teamNameKeyword = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '팀 이름을 검색하세요.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      ),
                      onPressed: () {
                        ref.read(searchedTeamNameNotifierProvider.notifier).changeKeyword(_teamNameKeyword);
                      },
                      child: Text(
                        '검색',
                        style: TextStyle(fontSize: width * 0.05),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
