import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class Button1Widget extends StatelessWidget {
  Button1Widget({
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
    this.borderColor,
    this.fontWeight,
  }) : super(key: key);

  final Color? color;
  final String title;
  final Color? titleColor;
  final double width;
  final double? titleFS;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final Function()? onTap;
  final double? borderRadius;
  final Color? borderColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryLight,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null,
          border: Border.all(
            color: borderColor ?? AppColors.primary,
            width: 1.0,
          ),
        ),
        constraints: BoxConstraints(
          minWidth: width,
          minHeight: height ?? 40,
          maxHeight: height ?? 40,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: titleFS ?? 16,
              color: titleColor ?? AppColors.light,
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
