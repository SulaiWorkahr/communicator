import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../heading_widget.dart';

import '../heading_widget.dart';

class ChartContainer extends StatelessWidget {
  // final Color color;
  final String title;
  Color? titleColor;
  final Widget chart;

  ChartContainer({
    Key? key,
    required this.title,
    // required this.color,
    required this.chart,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.fromLTRB(10, 0, 20, 10),
      // decoration: BoxDecoration(
      //   color: color,
      //   borderRadius: BorderRadius.circular(20),
      // ),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 5.0)],
          color: AppColors.light,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: HeadingWidget(
              title: title,
              color: titleColor,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: chart,
          )
        ],
      ),
    );
  }
}
