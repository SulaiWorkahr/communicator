import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    Key? key,
    this.color,
    required this.title,
    required this.width,
    this.height,
    this.onTap,
    this.titleColor,
    this.titleFS, // font size
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  final Color? color;
  final String title;
  final Color? titleColor;
  final double width;
  final double? titleFS;
  final EdgeInsetsGeometry? padding;
  var height;
  final Function()? onTap;
  double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 5.0),
        shape: borderRadius != null
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              )
            : null,
        // backgroundColor: color ?? Colors.blue,
        backgroundColor: color ?? AppColors.primaryLight,
        // primary:  color ??  AppColors.primary,
        minimumSize: Size(width, height ?? 40),
        maximumSize: Size(width, height ?? 40),
      ),
      onPressed: onTap,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: titleFS ?? 16,
            color: titleColor ?? AppColors.light,
            // fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
