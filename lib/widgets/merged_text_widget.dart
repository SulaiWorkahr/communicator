import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MergedTextWidget extends StatelessWidget {
  var title;
  var subtitle;
  var onTap;
  var subtitleColor;
  var titleColor;
  var titleFontWeight;
  double? titleFontSize = 16.0;
  double? subtitleFontSize;
  double? vMargin;
  double? hMargin;
  MergedTextWidget(
      {this.title,
      this.subtitle,
      this.onTap,
      this.subtitleColor,
      this.titleColor,
      this.titleFontWeight,
      this.titleFontSize,
      this.subtitleFontSize,
      this.vMargin,
      this.hMargin,
      super.key}) {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: EdgeInsets.symmetric(vertical: vMargin ?? 10.0, horizontal: hMargin ?? 0.0),
        child: Text.rich(
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          TextSpan(
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              TextSpan(
                  text: title,
                  style: TextStyle(
                      fontSize: titleFontSize,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: titleFontWeight ?? FontWeight.bold,
                      color: titleColor ?? AppColors.dark)),
              if (subtitle.toString() != 'null')
                TextSpan(
                  text: subtitle,
                  style: TextStyle(
                    fontSize: subtitleFontSize ?? titleFontSize,
                    overflow: TextOverflow.ellipsis,
                    color: subtitleColor ?? AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
