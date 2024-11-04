import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class SvgIconButtonWidget extends StatelessWidget {
  SvgIconButtonWidget(
      {Key? key,
      this.color,
      required this.title,
      required this.width,
      this.height,
      this.onTap,
      this.titleColor,
      required this.leadingIcon})
      : super(key: key);

  final Color? color;
  final String title;
  final Color? titleColor;
  final double width;
  var height;
  final Function()? onTap;
  Widget leadingIcon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // backgroundColor: color ?? Colors.blue,
        backgroundColor: color ?? AppColors.primary,
        // primary:  color ??  AppColors.primary,
        minimumSize: Size(width, height ?? 50),
        maximumSize: Size(width, height ?? 50),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: onTap,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leadingIcon,
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: titleColor ?? AppColors.light,
              // fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}
