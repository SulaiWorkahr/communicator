import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/comFuncService.dart';

class CustomMultiDropDown extends StatelessWidget {
  var valArr;
  var onChanged;
  // Function(List<dynamic>?) onChanged; // Keep the type as dynamic
  // Function(List<dynamic>?) onChanged; // Keep the type as dynamic
  String labelText;
  var labelField;
  String? Function(List<dynamic>?)? validator;


  CustomMultiDropDown(
      {super.key,
      required this.valArr,
      required this.onChanged,
      required this.labelText,
      this.validator,
      this.labelField});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      // margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.light, borderRadius: BorderRadius.circular(5.0)),
      child: DropdownSearch<dynamic>.multiSelection(
        popupProps: PopupPropsMultiSelection.menu(
          showSearchBox: true,
        ),
        items: valArr,
        itemAsString: (item) => labelField(item),
        // itemAsString: (item) => '${item[labelField]}',
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            // enabledBorder: defaultBorder(),
            floatingLabelStyle:
                TextStyle(fontSize: 14.0, color: AppColors.primary),

            focusedBorder: defaultBorder(),
            border: defaultBorder(),
            labelText: labelText,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        // selectedItem: null,
      ),
    );
  }
}
