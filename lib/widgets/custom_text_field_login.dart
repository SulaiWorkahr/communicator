import '../constants/constants.dart';
import 'package:flutter/material.dart';

class CustomeTextFieldLogin extends StatelessWidget {
  CustomeTextFieldLogin({
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
    this.borderColor
  }) : super(key: key);

  final String? title;
  final double? width;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  Color? borderColor;
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
      //height: 40.0,
      width: width ?? 201,
      child: TextFormField(
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
            hintText: title,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            iconColor: AppColors.primary,
            floatingLabelStyle:
                TextStyle(fontSize: 16, color: AppColors.primary),
            hintStyle: TextStyle(fontSize: 16, color: AppColors.grey),
            labelStyle: TextStyle(fontSize: 16, color: AppColors.grey),
            // labelStyle: TextStyle(
            //     fontSize: 16, color: const Color(0xff6A707C).withOpacity(0.48)),
            // contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            // contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: borderColor ?? AppColors.grey),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: borderColor ?? AppColors.grey),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.primary),
                borderRadius: BorderRadius.circular(20)),
            contentPadding: EdgeInsets.all(8),
            filled: true,
            fillColor: AppColors.light),
        // )
      ),
    );
  }
}
