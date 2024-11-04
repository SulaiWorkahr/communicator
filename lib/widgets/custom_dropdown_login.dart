import 'package:flutter/material.dart';
import '../constants/constants.dart'; // import your constants file

class CustomeDropdownLogin extends StatelessWidget {
  CustomeDropdownLogin({
    Key? key,
    this.title,
    this.width,
    this.margin,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.type,
    this.control,
    this.errMsg,
    this.onChanged,
    this.validator,
    this.readOnly,
    this.focusNode,
    required this.items, // Accept items for dropdown
    this.value, // Optional value for dropdown
  }) : super(key: key);

  final String? title;
  final double? width;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  var margin;
  var control;
  var value;
  var type;
  var errMsg;
  var obscureText;
  var onChanged;
  var validator;
  final bool? readOnly;
  var focusNode;
  final List<DropdownMenuItem<String>> items; // Dynamic items for dropdown
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
      width: width ?? 201,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged as void Function(String?)?,
        items: items,
        decoration: InputDecoration(
          hintText: title,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          iconColor: AppColors.primary,
          floatingLabelStyle:
              TextStyle(fontSize: 16, color: AppColors.primary),
          hintStyle: TextStyle(fontSize: 16, color: AppColors.grey),
          labelStyle: TextStyle(fontSize: 16, color: AppColors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.primary),
            borderRadius: BorderRadius.circular(25),
          ),
          contentPadding: EdgeInsets.all(8),
          filled: true,
          fillColor: AppColors.lightGrey,
        ),
        
        isExpanded: true,
      ),
    );
  }
}
