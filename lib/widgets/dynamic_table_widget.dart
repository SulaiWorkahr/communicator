
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import 'heading_widget.dart';

class DynamicTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<String> columnsToShow;
  final Color? headingColor;
  final List<String>? customColumnHeadings;
  final Color? rowColor;
  final double headingRowHeight;
  final double tableWidth;

  DynamicTable({
    required this.data,
    required this.columnsToShow,
    this.headingColor,
    this.customColumnHeadings,
    this.rowColor,
    this.headingRowHeight = 35.0,
    this.tableWidth = 500.0, 
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox( // Wrap DataTable with SizedBox
        width: tableWidth, // Set the width of the table
        child: DataTable(
          headingRowHeight: headingRowHeight,
          headingRowColor: MaterialStateColor.resolveWith(
              (states) => headingColor ?? AppColors.light),
          columns: _buildColumns(),
          rows: _buildRows(),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return columnsToShow.map((String columnName) {
      var index = columnsToShow.indexOf(columnName);
      String heading =
          customColumnHeadings != null && customColumnHeadings!.length > index
              ? customColumnHeadings![index] // Use custom heading if available
              : columnName; // Otherwise, use the original column name
      return DataColumn(
        label: HeadingWidget(title:heading, color: AppColors.light, fontSize: 12.0),
        // tooltip: columnName,
      );
    }).toList();
  }

  List<DataRow> _buildRows() {
    return data.map((Map<String, dynamic> row) {
      return DataRow(
        color: MaterialStateColor.resolveWith(
            (states) => rowColor ?? AppColors.light),
        cells: _buildCells(row),
      );
    }).toList();
  }

  List<DataCell> _buildCells(Map<String, dynamic> row) {
    return columnsToShow.map((String columnName) {
      return DataCell(
        // Format the value based on column name
        Text(_formatValue(row[columnName])),
      );
    }).toList();
  }

  String _formatValue(dynamic value) {
    if (value is int) {
      // If it's an integer, simply convert it to a string
      return value.toString();
    } else if (value is double) {
      if (value >= 1000000) {
        // Display in millions with one decimal place
        double result = value / 1000000.0;
        return '${result.toStringAsFixed(2)}M';
      } else if (value >= 1000) {
        // Display in thousands
        double result = value / 1000.0;
        return '${result.toStringAsFixed(2)}K';
      } else {
        // Display as is
        return value.toString();
      }
    } else {
      // If it's neither int nor double, return as is
      return value.toString();
    }
  }
}
