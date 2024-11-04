import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieCharttwoContent extends StatefulWidget {
  List<dynamic> chartData = [];
  var chartTitle = '';
  var chartValue = '';
  PieCharttwoContent(this.chartData, this.chartTitle, this.chartValue,
      {Key? key})
      : super(key: key);
  @override
  State<PieCharttwoContent> createState() => _PieCharttwoContentState();
}

class _PieCharttwoContentState extends State<PieCharttwoContent> {
  int touchedIndex = -1;
  List<PieChartSectionData> list = [];
  List<Row> newlist = [];
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    setupDonutChart();
  }

  setupDonutChart() {
    double radius = MediaQuery.of(context).size.width / 4.44;
    int i = 0;
    widget.chartData.forEach((e) {
      double val = double.parse(e[widget.chartValue]);
      String name = e[widget.chartTitle];
      Color colorname =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
      newlist.add(
        Row(children: [
          Indicator(
            color: colorname,
            text: name,
            isSquare: false,
            size: touchedIndex == i ? 18 : 16,
            textColor: touchedIndex == i ? Colors.black : Colors.grey,
          ),
        ]),
      );
      i++;

      final isTouched = i == touchedIndex;
      const color0 = Color(0xff0293ee);
      list.add(
        PieChartSectionData(
          value: val,
          title: '',
          radius: radius,
          color: colorname,
          titlePositionPercentageOffset: 0.55,
          borderSide: isTouched
              ? BorderSide(color: color0.withBlue(0), width: 6)
              : BorderSide(color: color0.withOpacity(0)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //return PieChart(PieChartData(sectionsSpace: 0, centerSpaceRadius: 0, sections: list,));
    return AspectRatio(
      aspectRatio: 2,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 1,
                  centerSpaceRadius: 50,
                  sections: list,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 150,
          ),
          Column(children: (newlist)),
        ],
      ),
    );
  }
}

// class Name {
//   final String name;
//   final Color color;

//   const Name({required this.name, required this.color});
// }

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
