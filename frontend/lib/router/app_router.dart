import 'package:flutter/cupertino.dart';
import 'package:frontend/view/pages/alarmPage/alarmPage.dart';
import 'package:frontend/view/pages/explorePage/explorePage.dart';
import 'package:frontend/view/pages/friendPage/friendPage.dart';
import 'package:frontend/view/pages/myPage/myPage.dart';
import 'package:frontend/view/pages/rankPage/rankPage.dart';
import 'package:frontend/view/pages/teamPage/teamGenPage/teamGenPage.dart';
import 'package:frontend/view/pages/teamPage/teamPage.dart';
import 'package:frontend/view/pages/teamPage/teamSearchPage/teamSearchPage.dart';
import 'package:frontend/view/pages/teamPage/teamWhichPage/teamWhichPage.dart';
import 'package:go_router/go_router.dart';

import '../view/pages/friendPage/addFriendPage/addFriendPage.dart';
import '../view/pages/loginPage/loginPage.dart';

Page<void> customPageBuilder(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // 애니메이션 없이 페이지를 반환
    },
  );
}

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, LoginPage());
      }),
  GoRoute(
      path: '/explore',
      name: ExplorePage.routeName,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, ExplorePage());
      }),
  GoRoute(
      path: '/friend',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, FriendPage());
      },
      routes: <GoRoute>[
        GoRoute(
            path: 'addFriend',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customPageBuilder(context, state, AddFriendPage());
            })
      ]),
  GoRoute(
      path: '/my',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, MyPage());
      }),
  GoRoute(
      path: '/rank',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, RankPage());
      }),
  GoRoute(
      path: '/team',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, TeamPage());
      }),
  GoRoute(
      path: '/select',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, TeamWhichPage());
      },
      routes: <GoRoute>[
        GoRoute(
            path: 'teamGen',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customPageBuilder(context, state, TeamGenPage());
            }),
        GoRoute(
            path: 'teamSearch',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return customPageBuilder(context, state, TeamSearchPage());
            }),
      ]),
  GoRoute(
      path: '/alarm',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return customPageBuilder(context, state, AlarmPage());
      })
]);
