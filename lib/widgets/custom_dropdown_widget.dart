import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomDropdownWidget extends StatelessWidget {
  final List<dynamic> valArr;
  final Function(dynamic) onChanged;
  final String? labelText;
  final String Function(dynamic) labelField;
  final dynamic selectedItem;
  final double? height;
  final double? width;
  final double? labelStyleFs;
  final Color? labelColor;
  final String? Function(dynamic)? validator;

  CustomDropdownWidget({
    super.key,
    required this.valArr,
    required this.onChanged,
    this.labelText,
    this.validator,
    required this.labelField,
    this.height,
    this.selectedItem,
    this.width,
    this.labelColor,
    this.labelStyleFs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40.0,
      margin: const EdgeInsets.all(0.0),
      width: width ?? MediaQuery.of(context).size.width - 10.0,
      child: DropdownSearch<dynamic>(
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          constraints: BoxConstraints(
            maxHeight: 300, // Adjust max height of the popup if needed
            minWidth: width ?? MediaQuery.of(context).size.width - 10.0, // Set minimum width
          ),
          itemBuilder: (context, item, isSelected) {
            return Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              child: Text(
                labelField(item),
                style: TextStyle(
                  fontSize: 15.0, // Customize font size
                  color: Colors.black, // Customize text color
                  fontWeight: FontWeight.normal, // Change to FontWeight.bold for bold text
                  // Add other styling options as needed
                ),
              ),
            );
          },
        ),
        items: valArr.toList(),
        itemAsString: (item) => labelField(item),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
            floatingLabelStyle: TextStyle(fontSize: 10.0, color: labelColor ?? AppColors.primary),
            hintStyle: TextStyle(fontSize: labelStyleFs ?? 16, color: labelColor ?? AppColors.dark),
            labelStyle: TextStyle(fontSize: labelStyleFs ?? 16.0, color: labelColor ?? AppColors.dark),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.light),
            ),
            border: null,
            labelText: labelText,
          ),
        ),
        dropdownButtonProps: DropdownButtonProps(
          alignment: Alignment.centerRight,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
            size: 21,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        selectedItem: selectedItem,
      ),
    );
  }
}

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';

// import '../constants/constants.dart';

// class CustomDropdownWidget extends StatelessWidget {
//   final List<dynamic> valArr;
//   final Function(dynamic) onChanged;
//   final String? labelText;
//   final String Function(dynamic) labelField;
//   final dynamic selectedItem;
//   final double? height;
//   final double? width;
//   final double? labelStyleFs;
//   final Color? labelColor;
//   final String? Function(dynamic)? validator;

//   CustomDropdownWidget({
//     super.key,
//     required this.valArr,
//     required this.onChanged,
//     this.labelText,
//     this.validator,
//     required this.labelField,
//     this.height,
//     this.selectedItem,
//     this.width,
//     this.labelColor,
//     this.labelStyleFs,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height ?? 40.0,
//       margin: const EdgeInsets.all(0.0),
//       width: width ?? MediaQuery.of(context).size.width * 0.9, // Adjust width to be 90% of screen width
//       child: DropdownSearch<dynamic>(
//         popupProps: PopupProps.menu(
//           fit: FlexFit.loose,
//           constraints: BoxConstraints(
//             maxHeight: 250, // Adjust max height of the popup if needed
//             minWidth: width ?? MediaQuery.of(context).size.width * 0.9, // Set minimum width to be responsive
//           ),
//           itemBuilder: (context, item, isSelected) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0), // Adjust padding as needed
//               child: Text(
//                 labelField(item),
//                 style: TextStyle(
//                   fontSize: 15.0, // Customize font size
//                   color: Colors.black, // Customize text color
//                   fontWeight: FontWeight.normal, // Change to FontWeight.bold for bold text
//                 ),
//               ),
//             );
//           },
//         ),
//         items: valArr.toList(),
//         itemAsString: (item) => labelField(item),
//         dropdownDecoratorProps: DropDownDecoratorProps(
//           dropdownSearchDecoration: InputDecoration(
//             isDense: true, // Makes the field more compact
//             contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // Adjust padding
//             floatingLabelStyle: TextStyle(fontSize: 10.0, color: labelColor ?? AppColors.primary),
//             hintStyle: TextStyle(fontSize: labelStyleFs ?? 16, color: labelColor ?? AppColors.dark),
//             labelStyle: TextStyle(fontSize: labelStyleFs ?? 16.0, color: labelColor ?? AppColors.dark),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(width: 1.5, color: AppColors.light),
//             ),
//             border: OutlineInputBorder(), // Ensure the border is visible
//             labelText: labelText,
//           ),
//         ),
//         dropdownButtonProps: DropdownButtonProps(
//           alignment: Alignment.centerRight,
//           icon: const Icon(
//             Icons.keyboard_arrow_down,
//             color: Colors.black,
//             size: 21,
//           ),
//         ),
//         validator: validator,
//         onChanged: onChanged,
//         selectedItem: selectedItem,
//       ),
//     );
//   }
// }

