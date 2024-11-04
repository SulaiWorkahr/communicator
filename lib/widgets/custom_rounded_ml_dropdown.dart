import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomRoundedMultiDropDown extends StatelessWidget {
  var valArr;
  var onChanged;
  String labelText;
  var labelField;
  String? Function(List<dynamic>?)? validator;

  // New properties for customization
  double? height;
  double? width;
  double? labelStyleFs;
  Color? labelColor;
  Color? borderColor;
  Color? selectedTextColor;
  Color? dropdownItemTextColor;

  CustomRoundedMultiDropDown({
    super.key,
    required this.valArr,
    required this.onChanged,
    required this.labelText,
    this.validator,
    this.labelField,
    this.height,
    this.width,
    this.labelColor,
    this.labelStyleFs,
    this.borderColor,
    this.selectedTextColor,
    this.dropdownItemTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40.0, // Set the height
      width: width ?? MediaQuery.of(context).size.width - 10.0, // Set the width
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.light, // Background color
        borderRadius: BorderRadius.circular(5.0), // Border radius
        // border: Border.all(
        //   color: borderColor ?? AppColors.grey, // Border color
        //   width: 1.5, // Border width
        // ),
      ),
      child: DropdownSearch<dynamic>.multiSelection(
        popupProps: PopupPropsMultiSelection.menu(
          showSearchBox: true,
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                labelField(item),
                style: TextStyle(
                  color: isSelected
                      ? selectedTextColor ?? AppColors.dark // Selected item text color
                      : dropdownItemTextColor ?? AppColors.dark, // Dropdown item text color
                ),
              ),
            );
          },
        ),
        items: valArr,
        itemAsString: (item) => labelField(item),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.all(9.0),
            floatingLabelStyle: TextStyle(
              fontSize: labelStyleFs ?? 14.0, // Label font size
              color: labelColor ?? AppColors.primary, // Label color
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: borderColor ?? AppColors.grey, // Border color
              ),
              borderRadius: BorderRadius.circular(30), // Rounded border
            ),
            border: InputBorder.none,
            labelText: labelText,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
