import 'package:flutter/material.dart';
import '../../core/const_data/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true, // 👈 default true
  });
  final String title;
  final bool showBack;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      automaticallyImplyLeading: showBack, // disables back if false

      title: Text(
        title,
        style: TextStyles.bodyTextStyle(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
