import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartContent extends StatefulWidget {
  List<dynamic> chartData = [];
  var chartTitle = '';
  var chartValue = '';

  PieChartContent(this.chartData, this.chartTitle, this.chartValue, {Key? key})
      : super(key: key);

  @override
  State<PieChartContent> createState() => _PieChartContentState();
}

class _PieChartContentState extends State<PieChartContent> {
  int touchedIndex = -1;
  List<PieChartSectionData> list = [];
  List<Row> newlist = [];

  @override
  didChangeDependencies() {
    setupPieChart();
  }

  setupPieChart() {
    chartData = [];
    double radius = MediaQuery.of(context).size.width / 4.44;
    int i = 0;
    widget.chartData.forEach((e) {
      double value =
          e[widget.chartValue] != "" ? double.parse(e[widget.chartValue]) : 0;
      String name = e[widget.chartTitle];
      Color colorname =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
      chartData.add(ChartData(e[widget.chartTitle], value, colorname));
      _tooltip = TooltipBehavior(enable: true);
      newlist.add(
        Row(children: [
          Indicator(
            color: colorname,
            text: name,
            isSquare: false,
            size: touchedIndex == i ? 16 : 14,
            textColor: touchedIndex == i ? Colors.black : Colors.grey,
          ),
        ]),
      );
      i++;

      final isTouched = i == touchedIndex;
      const color0 = Color(0xff0293ee);
      list.add(
        PieChartSectionData(
          value: value,
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

  List<ChartData> chartData = [];
  TooltipBehavior? _tooltip;

  @override
  Widget build(BuildContext context) {
    //return PieChart(PieChartData(sectionsSpace: 0, centerSpaceRadius: 0, sections: list,));
    return Column(
      children: <Widget>[
        SizedBox(
          height: 190,
          child: /*PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 1,
              centerSpaceRadius: 0,
              sections: list,
            ),
          )*/
              SfCircularChart(
                  tooltipBehavior: _tooltip,
                  series: <CircularSeries>[
                // Render pie chart
                PieSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y),
              ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: 
        SizedBox(
            height: 150,
            child: Scrollbar(
                child:
                    SingleChildScrollView(child: Column(children: (newlist)))))),
      ],
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
        SizedBox(
          width: 200,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
