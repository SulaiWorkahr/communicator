// import 'package:flutter/material.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';

// import '../constants/app_colors.dart';

// class MultiDropdownAlert extends StatelessWidget {
//   final List<MultiSelectItem<String>> items;

//   final String title;
//   final Color selectedColor;
//   // final BoxDecoration decoration;
//   final IconData buttonIcon;
//   final String buttonText;
//   final Function(List<String>) onConfirm;
//   final int maxSelection;

//    MultiDropdownAlert({
//     Key? key,
//     required this.items,
//     required this.title,
//     this.selectedColor = Colors.blue,
//     // required this.decoration,
//     this.buttonIcon = Icons.arrow_drop_down,
//     this.buttonText = "Select Items",
//     required this.onConfirm,
//     this.maxSelection = 3,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiSelectDialogField(
//       dialogHeight: (items.length * 56.0).clamp(200.0, 400.0),
//       items: items,
//       title: Text(title),
//       selectedColor: selectedColor,
//       decoration: BoxDecoration(
//               //color: Colors.blue.withOpacity(0.1),
//               borderRadius: BorderRadius.all(Radius.circular(8)),
//               border: Border.all(color: Colors.black, width: 2),
//             ),
//       buttonIcon: Icon(
//         buttonIcon,
//         color: selectedColor,
//       ),
//       buttonText: Text(
//         buttonText,
//         style: TextStyle(
//           color: AppColors.dark,
//           fontSize: 16,
//         ),
//       ),
//       onConfirm: (values) {
//         onConfirm(values.cast<String>());
//       },
//       validator: (values) {
//         if (values == null || values.isEmpty) {
//           return "Please select at least one item";
//         } else if (values.length > maxSelection) {
//           return "You can only select up to $maxSelection items";
//         }
//         return null;
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../constants/app_colors.dart';

class MultiDropdownAlert extends StatefulWidget {
  var items;
  final String title;
  final Color selectedColor;
  final IconData buttonIcon;
  final String buttonText;
  final Function(List<String>) onConfirm;
  final int maxSelection;
  final List<String> initialSelectedValues;

  MultiDropdownAlert({
    Key? key,
    required this.items,
    required this.title,
    this.selectedColor = Colors.blue,
    this.buttonIcon = Icons.arrow_drop_down,
    this.buttonText = "Select Items",
    required this.onConfirm,
    this.maxSelection = 3,
    this.initialSelectedValues = const [], // New parameter for initial values
  }) : super(key: key);

  @override
  _MultiDropdownAlertState createState() => _MultiDropdownAlertState();
}

class _MultiDropdownAlertState extends State<MultiDropdownAlert> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.initialSelectedValues; // Initialize with passed values
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDialogField(
          dialogHeight: 300.0,
          items: widget.items,
          title: Text(widget.title),
          selectedColor: widget.selectedColor,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            border: Border.all(color: AppColors.grey),
          ),
          buttonIcon: Icon(
            widget.buttonIcon,
            color: widget.selectedColor,
          ),
          buttonText: Text(
            widget.buttonText,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          initialValue: _selectedItems, // Set initial selected values here
          chipDisplay: MultiSelectChipDisplay.none(),
          onConfirm: (values) {
            setState(() {
              _selectedItems = values.cast<String>();
            });
            widget.onConfirm(_selectedItems);
          },
          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Please select at least one item";
            } else if (values.length > widget.maxSelection) {
              return "You can only select up to ${widget.maxSelection} items";
            }
            return null;
          },
        ),
        SizedBox(height: 10.0),
        if (_selectedItems.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _selectedItems
                .map((item) => Chip(
                      label: Text(item),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _selectedItems.remove(item);
                        });
                        widget.onConfirm(_selectedItems);
                      },
                    ))
                .toList(),
          ),
      ],
    );
  }
}