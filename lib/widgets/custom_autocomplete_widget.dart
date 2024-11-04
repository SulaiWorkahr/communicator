import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../services/comFuncService.dart';

class CustomAutoCompleteWidget extends StatelessWidget {
  var valArr;
  var onChanged;
  String labelText;
  var labelField;
  var selectedItem;

  String? Function(dynamic)? validator;

  CustomAutoCompleteWidget(
      {super.key,
      required this.valArr,
      required this.onChanged,
      required this.labelText,
      this.validator,
      this.labelField,
      this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      width: MediaQuery.of(context).size.width - 10.0,
      child: DropdownSearch<dynamic>(
        popupProps: const PopupProps.menu(
          showSearchBox: true,
        ),
        items: valArr.toList(),
        itemAsString: (item) => labelField(item),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            floatingLabelStyle:
                const TextStyle(fontSize: 14.0, color: AppColors.primary),
            enabledBorder: idleBorder(),
            focusedBorder: defaultBorder(),
            border: idleBorder(),
            labelText: labelText,
          ),
        ),
        validator: validator,
        onChanged: onChanged,
        selectedItem: selectedItem,
      ),
    );
  }
}
