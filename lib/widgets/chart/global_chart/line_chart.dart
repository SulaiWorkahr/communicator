import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartContent extends StatefulWidget {
  List<dynamic> chartData = [];
  var chartTitle;
  var chartValue;
  var height;

  LineChartContent(
      {required this.chartData,
      this.chartTitle,
      this.chartValue,
      this.height,
      Key? key})
      : super(key: key);

  @override
  State<LineChartContent> createState() => _LineChartContentState();
}

class _LineChartContentState extends State<LineChartContent> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color.fromARGB(255, 20, 147, 231),
  ];
  List<FlSpot> lineChartDatanewvalue = [];
  List<LineChartBarData> lineChartBarDatanew = [];
  List<String> newval = ["0"];
  SideTitles _bottomTitlesnew = SideTitles();

  @override
  initState() {
    super.initState();
    setupLineChart();
  }

  setupLineChart() async {
    newval.remove("0");

    double ii = 0;

    widget.chartData.forEach((e) {
      double value =
          e[widget.chartValue] != "" ? double.parse(e[widget.chartValue]) : 0;
      lineChartDatanewvalue.add(FlSpot(ii, value));
      String name = e[widget.chartTitle];
      if (name.length > 12) {
        // name = "${name.substring(0, 7)}...";
        name = "${name.substring(0, 12)}...";
      }
      newval.add(name);
      ii++;
    });
    //print(newval);

    lineChartBarDatanew.add(LineChartBarData(
        color: const Color(0xff43dde6),
        isCurved: true,
        spots: lineChartDatanewvalue,
        //isCurved: true,
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return (lineChartDatanewvalue.length < 12)
        ? Container(
            padding: const EdgeInsets.only(top: 20),
            // width: MediaQuery.of(context).size.width * 3,
            height: widget.height ?? MediaQuery.of(context).size.width * 0.90,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(
                    border: Border.all(color: Colors.white, width: 0.5)),
                gridData: FlGridData(
                  drawHorizontalLine: true,
                ),
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false))),
                // minX: 0,
                // minY: 0,
                baselineX: 0,
                baselineY: 0,
                minX: 0,
                // minY: -5000000,
                // maxX: 7,
                // maxY: 5000000,
                //maxX: 7,
                //maxY: 16,
                lineBarsData: lineChartBarDatanew,
              ),
            ),
          )
        : Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: (lineChartDatanewvalue.length < 30)
                      ? MediaQuery.of(context).size.width * 3
                      : (lineChartDatanewvalue.length < 50)
                          ? MediaQuery.of(context).size.width * 5
                          : MediaQuery.of(context).size.width * 10,
                  height: MediaQuery.of(context).size.width * 0.99,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(
                          border: Border.all(color: Colors.white, width: 0.5)),
                      gridData: FlGridData(
                        drawHorizontalLine: false,
                      ),
                      titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false))),
                      baselineX: 0,
                      baselineY: 0,
                      minX: 0,
                      minY: -50000000,
                      // maxX: 7,
                      maxY: 50000000,
                      lineBarsData: lineChartBarDatanew,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 100,
        getTitlesWidget: (value, meta) {
          const style = TextStyle(color: Color(0xff939393), fontSize: 10);
          String text = newval[value.toInt()];
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 55,
            angle: 30,
            child: Text(text, style: style),
          );
        },
      );
}
