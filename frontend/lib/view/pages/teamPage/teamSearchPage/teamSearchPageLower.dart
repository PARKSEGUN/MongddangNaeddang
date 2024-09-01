import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/view/pages/teamPage/teamSearchPage/teamSearchPageComponent/searchedTeamComponent.dart';
import '../../../../provider/teamPageProvider/teamSearchPageProvider/teamSearchPage_provider.dart';

class CategoryItem {
  final int key;
  final String value;

  CategoryItem({
    required this.key,
    required this.value,
  });
}

class TeamSearchLower extends ConsumerStatefulWidget {
  final screenSize;

  const TeamSearchLower({
    super.key,
    required this.screenSize,
  });

  @override
  ConsumerState<TeamSearchLower> createState() => _TeamSearchUpperState();
}

class _TeamSearchUpperState extends ConsumerState<TeamSearchLower> {
  @override
  Widget build(BuildContext context) {
    final width = widget.screenSize.width;
    final isClicked = ref.watch(togglePossibleTeamNotifierProvider);
    int sortType = ref.watch(sortTypeNotifierProvider);

    final List<CategoryItem> categories = [
      CategoryItem(key: 0, value: '팀 등록순'),
      CategoryItem(key: 1, value: '팀 면적순'),
      CategoryItem(key: 2, value: '팀 거리순'),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        color: Color(0xffdbcdff),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: Row(
                  children: [
                    if (!isClicked)
                      toggleButton(Icons.circle_outlined)
                    else
                      toggleButton(Icons.circle),
                    Container(
                      width: 130,
                      height: width * 0.09,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1), color: Colors.white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: categories[sortType],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.04,
                            color: Colors.black,
                          ),
                          items: categories.map((CategoryItem item) {
                            return DropdownMenuItem<CategoryItem>(
                              value: item,
                              child: Text(item.value),
                            );
                          }).toList(),
                          onChanged: (CategoryItem? item) {
                            ref
                                .read(sortTypeNotifierProvider.notifier)
                                .changeCategory(item!.key);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: categoryWidget(isClicked, sortType),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryWidget(bool isClicked, int sortType) {
    final searchedTeamLists = ref.watch(searchTeamListBySortTypeNotifierProvider);

    return searchedTeamLists.when(
      data: (searchedTeamLists) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: searchedTeamLists[sortType].isEmpty
              ? Center(
            child: Text(
              "팀 목록이 비었습니다.",
            ),
          )
              : ListView.builder(
            itemCount: searchedTeamLists[sortType].length,
            itemBuilder: (context, index) {
              if (searchedTeamLists[sortType][index].memberCount < 6) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: SearchedTeamComponent(
                    searchedTeam: searchedTeamLists[sortType][index],
                  ),
                );
              }
              return Container();
            },
          ),
        );
      },
      error: (error, stackTrace) {
        throw("에러에러: $error");
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

  }

  Widget toggleButton(IconData icon) {
    return Flexible(
      flex: 8,
      child: Container(
        alignment: Alignment.centerRight,
        child: IconButton(
          iconSize: 30,
          onPressed: () {
            ref
                .read(togglePossibleTeamNotifierProvider.notifier)
                .toggleButton();
          },
          icon: Icon(icon),
        ),
      ),
    );
  }
}
