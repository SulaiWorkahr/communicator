import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/constants.dart';
import 'sub_heading_widget.dart';

class GroupChipWidget extends StatelessWidget {
  String items;
  int? selectedChip;
  void Function(bool)? onTap;
  int? index;
  Color? selectedColor;
  Color? backgroundColor;
  Color? borderColor;
  Color? nonSeletedColor;
  Color? selectedFontColor;
  bool? showCheckmark;
  double? fontSize;
  EdgeInsetsGeometry? labelPadding;

  String? iconPath;
  GroupChipWidget({
    super.key,
    required this.items,
    this.selectedChip,
    this.onTap,
    this.index,
    this.selectedColor,
    this.backgroundColor,
    this.borderColor,
    this.nonSeletedColor,
    this.selectedFontColor,
    this.showCheckmark,
    this.fontSize,
    this.labelPadding,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: ChoiceChip(
        // avatar: iconPath != null
        //     ? Container(
        //         // padding: EdgeInsets.all(5.0),
        //         decoration: BoxDecoration(
        //           color: AppColors.lightGrey11,
        //           shape: BoxShape.circle,
        //           border: Border.all(
        //             color: AppColors.lightGrey11,
        //             width: 1.0, // Border width
        //           ),
        //         ),
        //         child: 
        //         SvgPicture.asset(iconPath!, height: 40.0,),
        //       )
        //     : null,
        padding: iconPath != null ? EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0) :null,
        labelPadding: labelPadding,
        showCheckmark: showCheckmark ?? false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selectedColor: selectedColor ?? AppColors.warning,
        backgroundColor: backgroundColor ?? AppColors.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: borderColor ?? AppColors.grey,
            width: 1.0,
          ),
        ),
        // padding: const EdgeInsets.all(10.0),
        // labelStyle: ,

        // label: selectedChip == index
        //     ? SubHeadingWidget(
        //         title: items,
        //         vMargin: 0.0,
        //         color: selectedFontColor ?? AppColors.light,
        //         fontSize: fontSize,
        //       )
        //     : SubHeadingWidget(
        //         title: items,
        //         vMargin: 0.0,
        //         color: nonSeletedColor ?? AppColors.warning,
        //         fontSize: fontSize,
        //       ),
        label: IntrinsicWidth(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (iconPath != null)
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey11,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:  AppColors.lightGrey11,
                      width: 1.0, // Border width
                    ),
                  ),
                  child: SvgPicture.asset(iconPath!, height: 15.0,),
                ),
              SizedBox(
                width: 2.0,
              ),
              selectedChip == index
                  ? SubHeadingWidget(
                      title: items,
                      vMargin: 0.0,
                color: selectedFontColor ?? AppColors.light,
                      fontSize: fontSize,
                    )
                  : SubHeadingWidget(
                      title: items,
                      vMargin: 0.0,
                      color: nonSeletedColor ?? AppColors.warning,
                      fontSize: fontSize,
                    ),
            ],
          ),
        ),

        selected: selectedChip == index,
        onSelected: onTap,
      ),
    );
    //   }).toList(),
    // );
  }
}
