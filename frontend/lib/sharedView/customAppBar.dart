import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AppBar(
      title: Image.asset(
        'assets/startPage.png',
        width: 100,
      ),
      actions: [
        IconButton(
          onPressed: () {
            GoRouter.of(context).push("/alarm");
          },
          icon: Icon(Icons.notifications),
          iconSize: 40,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
