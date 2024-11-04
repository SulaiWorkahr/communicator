import '../constants/constants.dart';
import 'package:flutter/material.dart';

class SubHeadingWidget extends StatelessWidget {
  var title;
  var fontSize;
  var color;
  var vMargin;
  TextAlign? textAlign;

  SubHeadingWidget(
      {this.title,
      this.color,
      this.fontSize,
      this.vMargin,
      this.textAlign,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: vMargin ?? 0.0,
      ),
      child: Text(
        title.toString(),
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          fontSize: fontSize ?? 14.0,
          color: color ?? AppColors.grey,
        ),
      ),
    );
  }
}
