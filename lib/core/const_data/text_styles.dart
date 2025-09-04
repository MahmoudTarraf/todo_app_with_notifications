import 'package:flutter/material.dart';

class TextStyles {
  // AppBar
  static TextStyle appBarTextStyle(BuildContext context) =>
      Theme.of(context).appBarTheme.titleTextStyle ??
      Theme.of(context).textTheme.headlineSmall!;

  // Heading
  static TextStyle headingTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!;

  // Body text
  static TextStyle bodyTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;

  // Small text
  static TextStyle smallTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
}
