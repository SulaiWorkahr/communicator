import '../constants/constants.dart';
import 'package:flutter/material.dart';

class FooterText extends StatelessWidget {
  var title;
  var subtitle;
  var onTap;
  FooterText({this.title, this.subtitle, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Text.rich(
          textAlign: TextAlign.end,
          TextSpan(
            children: [
              TextSpan(
                text: title,
              ),
              TextSpan(
                text: subtitle,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ));
  }
}
