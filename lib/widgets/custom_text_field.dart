import '../constants/constants.dart';
import 'package:flutter/material.dart';

class CustomeTextField extends StatelessWidget {
  CustomeTextField({
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
    this.inputFormaters,
    this.initialValue,
    this.lines,
    this.onTap,
    this.borderSideColor,
    this.enableBorderColor,
    this.focusBorderColor,
    this.labelColor,
    this.labelStyleFs,
    this.height,
    this.verticalMargin,
    this.borderRadius, // New parameter for border radius
  }) : super(key: key);

  final String? title;
  final double? width;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? borderSideColor;
  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final Color? labelColor;
  final double? labelStyleFs;
  final double? height;
  final double? verticalMargin;
  final double? borderRadius; // New parameter for border radius

  var margin;
  var control;
  var initialValue;
  var type;
  var errMsg;
  var obscureText;
  var onChanged;
  var validator;
  final bool? readOnly;
  var focusNode;
  var inputFormaters;
  var lines;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 4, vertical: verticalMargin ?? 10),
      width: width ?? 201,
      child: TextFormField(
        onTap: onTap,
        initialValue: initialValue,
        textAlign: type == null ? TextAlign.start : TextAlign.end,
        controller: control,
        obscureText: obscureText == true
            ? obscureText
                ? true
                : false
            : false,
        keyboardType: type,
        inputFormatters: inputFormaters,
        maxLines: lines ?? 1,
        validator: validator,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(7.0),
          hintText: title,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          iconColor: AppColors.primary,
          floatingLabelStyle: TextStyle(fontSize: 16, color: AppColors.primary),
          hintStyle: TextStyle(fontSize: labelStyleFs ?? 16, color: labelColor ?? AppColors.grey),
          labelStyle: TextStyle(fontSize: labelStyleFs ?? 16.0, color: labelColor ?? AppColors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4.0), // Dynamic Border Radius
            borderSide: BorderSide(width: 1.5, color: borderSideColor ?? AppColors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4.0), // Dynamic Border Radius
            borderSide: BorderSide(width: 1.5, color: enableBorderColor ?? AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4.0), // Dynamic Border Radius
            borderSide: BorderSide(width: 1.5, color: focusBorderColor ?? AppColors.primary),
          ),
        ),
      ),
    );
  }
}
