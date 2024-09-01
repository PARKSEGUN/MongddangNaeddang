import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/myPageProvider/myBadge_provider.dart';

class Collect extends ConsumerWidget {
  const Collect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 화면의 너비를 가져옵니다.
    final double screenWidth = MediaQuery.of(context).size.width;
    // 아이템의 너비를 화면 너비의 1/3로 설정합니다.
    final double itemWidth = screenWidth / 3;
    final asyncBadgeList = ref.watch(badgeNotifierProvider);
    List<int> badgeList = asyncBadgeList.when(
      data: (myBadge) => myBadge, // myBadge를 리스트로 변환
      loading: () => [], // 로딩 중일 때 빈 리스트 반환
      error: (error, stack) => [], // 오류 발생 시 빈 리스트 반환
    );

    return SingleChildScrollView(
      child: Container(
        child: Wrap(
          children: badgeImgList.asMap().entries.map((entry) {
            int index = entry.key;
            String imgUrl = entry.value;
            bool isGrayscale = !badgeList.contains(index + 1); // 보유 여부 확인
            return GestureDetector(
              onTap: () {
                // 모달창 띄우기
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('배지 정보'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(imgUrl), // 클릭된 이미지 표시
                          Text('총 ${index * 10}KM를 달리시면 획득 가능합니다!'),
                          Text(
                              isGrayscale ? '[이 배지는 보유하지 않음]' : '[이 배지는 보유중임]'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 모달 닫기
                          },
                          child: Text('닫기'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: BadgeItem(
                index: index,
                imgUrl: imgUrl,
                isGrayscale: isGrayscale,
              ),
            );
          }).toList(), // BadgeItem 리스트로 변환
        ),
      ),
    );
  }
}

class BadgeItem extends StatelessWidget {
  final String imgUrl; // 이미지 URL
  final int index;
  final bool isGrayscale; // 회색조 여부

  const BadgeItem({
    Key? key,
    required this.imgUrl,
    required this.index,
    this.isGrayscale = false, // 기본값은 회색조가 아닙니다.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3, // 화면의 1/3 너비
      child: Column(
        children: [
          Image.asset(
            imgUrl,
            color: isGrayscale ? Colors.grey : null,
          ), // 이미지 표시
        ],
      ),
    );
  }
}

List<String> badgeImgList = [
  'assets/myPage/badge/badge10.png',
  'assets/myPage/badge/badge20.png',
  'assets/myPage/badge/badge30.png',
  'assets/myPage/badge/badge40.png',
  'assets/myPage/badge/badge50.png',
  'assets/myPage/badge/badge60.png',
  'assets/myPage/badge/badge70.png',
  'assets/myPage/badge/badge80.png',
  'assets/myPage/badge/badge90.png',
  'assets/myPage/badge/badge100.png',
];
