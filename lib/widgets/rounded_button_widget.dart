import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class RoundedButtonWidget extends StatelessWidget {
  RoundedButtonWidget(
      {Key? key,
      this.color,
      required this.title,
      required this.width,
      this.height,
      this.onTap,
      this.borderRadius,
      this.leadingIcon,
      this.fontSize,
      this.borderColor,
      this.titleColor})
      : super(key: key);

  final Color? color;
  final String title;
  final Color? titleColor;
  final double width;
  final double? borderRadius;
  final double? fontSize;
  Widget? leadingIcon;

  var height;
  final Function()? onTap;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          // border: Border.all(
          //   width: 1.5,
          //   color: borderColor ?? AppColors.dark, // Set the border color
          // ),
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              surfaceTintColor: AppColors.light,
              side: BorderSide(
                width: 1.0,
                color: borderColor ?? AppColors.grey,
              ),
              // backgroundColor: color ?? Colors.blue,
              //backgroundColor: color ?? AppColors.light,
              // primary:  color ??  AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              minimumSize: Size(width, height ?? 35.0),
              maximumSize: Size(width, height ?? 35.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 10.0)),
            ),
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) leadingIcon!,

                // Icon(
                //   Icons.call,
                //   size: 18.0,
                //   color: AppColors.light,
                // ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize ?? 12.0,
                    color: titleColor ?? AppColors.dark,
                    // fontWeight: FontWeight.w600
                  ),
                ),
              ],
            )));
  }
}
