
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../constants/constants.dart';

class MergedMultiTextWidget extends StatelessWidget {
  var title;
  var subtitle;
  var onTap;
  var subtitleColor;
  var titleColor;
  var titleFontWeight;
  var onSubtitleTap;

  MergedMultiTextWidget({
    this.title,
    this.subtitle,
    this.onTap,
    this.onSubtitleTap,
    this.subtitleColor,
    this.titleColor,
    this.titleFontWeight,
      super.key}) {}
 
 @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By continuing you agree to our ',
            style: TextStyle(
              color: titleColor ?? AppColors.dark,
            ),
          ),
          TextSpan(
            text: 'Terms',
            style: TextStyle(
              color: titleColor ?? AppColors.primary,
              fontWeight: titleFontWeight ?? FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = onTap,
          ),
          TextSpan(
            text: ' & Privacy Policy.',
            style: TextStyle(
              color: subtitleColor ?? AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = onSubtitleTap,
          ),
        ],
      ),
    );
  }
}
