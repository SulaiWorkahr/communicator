import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomRoundedTextField extends StatelessWidget {
  CustomRoundedTextField({
    Key? key,
    this.title,
    this.width,
    this.margin,
    this.labelText,
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
  }) : super(key: key);

  final String? title;
  final double? width;
  final String? labelText;
  final Widget? suffixIcon;
  final Color? borderSideColor;
  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final Color? labelColor;
  final double? labelStyleFs;

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
  final double? height;
  final double? verticalMargin;
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
          contentPadding: EdgeInsets.all(8.0),
          hintText: title,
          labelText: labelText,
          suffixIcon: suffixIcon,
          iconColor: AppColors.primary,
          floatingLabelStyle: TextStyle(fontSize: 16, color: AppColors.primary),
          hintStyle: TextStyle(fontSize: labelStyleFs ?? 16, color: labelColor ?? AppColors.lightGrey),
          labelStyle: TextStyle(fontSize: labelStyleFs ?? 16.0, color: labelColor ?? AppColors.lightGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(width: 1.5, color: borderSideColor ?? AppColors.lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(width: 1.5, color: enableBorderColor ?? AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(width: 1.5, color: focusBorderColor ?? AppColors.primary),
          ),
        ),
      ),
    );
  }
}
