import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle titleStyle;
  final double? width;

  const CustomElevatedButton({
    super.key,
    required this.width,
    required this.child,
    required this.onPressed,
    required this.height,
    this.padding = const EdgeInsets.all(16.0),
    required this.backgroundColor,
    required this.foregroundColor,
    this.titleStyle = const TextStyle(fontSize: 18.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.r),
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              color: backgroundColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
