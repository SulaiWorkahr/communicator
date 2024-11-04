import '../constants/constants.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  var title;
  var color;
  var fontSize;
  var fontWeight;
  var vMargin;
  TextAlign? textAlign;
  int? maxLines;
  TextOverflow? overflow;

  HeadingWidget(
      {this.title,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.vMargin,
      this.textAlign,
      this.maxLines,
      this.overflow,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: vMargin ?? 8.0),
      child: Text(
        title.toString(),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
            fontSize: fontSize ?? 16.0,
            fontWeight: fontWeight ?? FontWeight.bold,
            color: color ?? AppColors.dark),
      ),
    );
  }
}
