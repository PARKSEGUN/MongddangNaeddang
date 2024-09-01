import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/navBar_provider.dart';
import 'package:go_router/go_router.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexNotifierProvider);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.purpleAccent,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      iconSize: 24.0,
      onTap: (index) {
        ref.read(currentIndexNotifierProvider.notifier).changeIndex(index);
        switch (index) {
          case 0:
            GoRouter.of(context).go('/explore');
            // context.pushReplacement('/explore');
            break;
          case 1:
            GoRouter.of(context).go('/friend');
            // context.pushReplacement('/friend');
            break;
          case 2:
            GoRouter.of(context).go('/team');
            // context.pushReplacement('/team');
            break;
          case 3:
            GoRouter.of(context).go('/rank');
            // context.pushReplacement('/rank');
            break;
          case 4:
            GoRouter.of(context).go('/my');
            // context.pushReplacement('/my');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: currentIndex == 0
              ? ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.purpleAccent, BlendMode.srcIn),
                  child: Image.asset('assets/navbar/run.png',
                      width: 24, height: 24),
                )
              : Image.asset('assets/navbar/run.png', width: 24, height: 24),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Friend',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: 'Team',
        ),
        BottomNavigationBarItem(
          icon: currentIndex == 3
              ? ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.purpleAccent, BlendMode.srcIn),
                  child: Image.asset('assets/navbar/rank.png',
                      width: 24, height: 24),
                )
              : Image.asset('assets/navbar/rank.png', width: 24, height: 24),
          label: 'Rank',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'My',
        ),
      ],
    );
  }
}
