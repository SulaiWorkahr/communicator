import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../services/comFuncService.dart';

class CustomDropdownWidget1 extends StatelessWidget {
  var valArr;
  var onChanged;
  String? labelText;
  var labelField;
  var selectedItem;
  double? height;
  double? width;
  double? labelStyleFs;
  Color? labelColor;
  Color? borderColor;
  Color? selectedTextColor;
  Color? dropdownItemTextColor;

  String Function(dynamic)? itemAsString;
  String? Function(dynamic)? validator;

  CustomDropdownWidget1({
    super.key,
    required this.valArr,
    required this.onChanged,
    this.labelText,
    this.validator,
    this.labelField,
    this.height,
    this.selectedItem,
    this.width,
    this.labelColor,
    this.labelStyleFs,
    this.itemAsString,
    this.borderColor,
    this.selectedTextColor,
    this.dropdownItemTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40.0,
      margin: const EdgeInsets.all(0.0),
      width: width ?? MediaQuery.of(context).size.width - 10.0,
      child: DropdownSearch<dynamic>(
        popupProps: PopupProps.menu(
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                itemAsString != null ? itemAsString!(item) : item.toString(),
                style: TextStyle(
                  color: isSelected
                      ? selectedTextColor ?? AppColors.dark
                      : dropdownItemTextColor ?? AppColors.dark,
                ),
              ),
            );
          },
        ),
        items: valArr.toList(),
        itemAsString: itemAsString,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.all(9.0),
            floatingLabelStyle: const TextStyle(fontSize: 10.0, color: AppColors.primary),
            hintStyle: TextStyle(fontSize: labelStyleFs ?? 16, color: labelColor ?? AppColors.dark),
            labelStyle: TextStyle(fontSize: labelStyleFs ?? 16.0, color: labelColor ?? AppColors.dark),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: borderColor ?? AppColors.grey),
              borderRadius: BorderRadius.circular(30),
            ),
            border: null,
            labelText: labelText,
          ),
        ),
        dropdownButtonProps: DropdownButtonProps(
          icon: Icon(
            Icons.keyboard_arrow_down, // Your custom icon here
            color: Colors.black, // Custom color for the icon
            size: 21, // Custom size for the icon
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        selectedItem: selectedItem,
        dropdownBuilder: (context, selectedItem) {
          return Text(
            itemAsString != null ? itemAsString!(selectedItem) : selectedItem.toString(),
            style: TextStyle(color: selectedTextColor ?? AppColors.dark),
          );
        },
      ),
    );
  }
}
