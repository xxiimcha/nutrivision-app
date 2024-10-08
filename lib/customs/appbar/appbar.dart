import 'package:flutter/material.dart';
import 'package:sjq/navigator.dart';
import 'package:sjq/themes/themes.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: colorLightBlue,
          onPressed: () => AppNavigator().toNotificationScreen(context),
        ),
      ],
    );
  }
}
