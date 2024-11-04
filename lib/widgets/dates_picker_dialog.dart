
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import 'button_widget.dart';

class DatesPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  DatesPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  DatesPickerDialogState createState() => DatesPickerDialogState();
}

class DatesPickerDialogState extends State<DatesPickerDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: AppColors.lightBlue,
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select date',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DropdownButton<int>(
                  value: selectedDate.year,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedDate = DateTime(newValue!, selectedDate.month, selectedDate.day);
                    });
                  },
                  items: List.generate(
                    widget.lastDate.year - widget.firstDate.year + 1,
                    (index) => DropdownMenuItem<int>(
                      value: widget.firstDate.year + index,
                      child: Text((widget.firstDate.year + index).toString()),
                    ),
                  ),
                ),
                DropdownButton<int>(
                  value: selectedDate.month,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, newValue!, selectedDate.day);
                    });
                  },
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
                    ),
                  ),
                ),
                DropdownButton<int>(
                  value: selectedDate.day,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month, newValue!);
                    });
                  },
                  items: List.generate(
                    DateTime(selectedDate.year, selectedDate.month + 1, 0).day,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text((index + 1).toString()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
             
              ButtonWidget(
                      title: "Cancel",
                      width: 80.0,
                      height: 25.0,
                      titleFS: 16.0,
                      borderRadius: 10.0,
                      color: AppColors.lightGrey,
                      titleColor: AppColors.dark,
                      onTap: () {
                      Navigator.of(context).pop();
                      },
                    ),

                    SizedBox(width: 9.0,),
            
                ButtonWidget(
                      title: "OK",
                      width: 80.0,
                      height: 25.0,
                      titleFS: 16.0,
                      borderRadius: 10.0,
                    color: AppColors.lightBlue,
                      titleColor: AppColors.light,
                      onTap: () {
                     Navigator.of(context).pop(selectedDate);
                      },
                    ),
            ],
          ),
          SizedBox(height: 15.0,)
        ],
      ),
    );
  }
}