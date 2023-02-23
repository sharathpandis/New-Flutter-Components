import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fl_chart/fl_chart.dart';

class PricePoint {
  double x;
  double y;
  PricePoint({required this.x, required this.y});
}

class LineChartPoc extends StatefulWidget {
  const LineChartPoc({super.key});

  @override
  State<LineChartPoc> createState() => _LineChartPocState();
}

final List<PricePoint> points = [
  PricePoint(x: 1, y: 1),
  PricePoint(x: 2, y: 4),
  PricePoint(x: 6.8, y: 3.1),
  PricePoint(x: 8, y: 4),
  PricePoint(x: 9.5, y: 3),
];
List<Color> gradientColors = [
  Colors.green,
  Colors.white,
];
List<Color> gradientColors2 = [
  Colors.green,
  Colors.green,
];
List<int> _getSpotIndicator = [];

class _LineChartPocState extends State<LineChartPoc> {
  late int showingTooltipSpot;
  bool _selected = false;
  void initState() {
    showingTooltipSpot = -1;
    super.initState();
  }

  @override
  List<LineChartBarData> lineBars = [
    LineChartBarData(
      spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
      isCurved: true,
      dotData: FlDotData(
        show: true,
      ),
      color: Color.fromARGB(255, 10, 147, 112),
      gradient: LinearGradient(
        colors: gradientColors2,
      ),
      barWidth: 1.5,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              gradientColors.map((color) => color.withOpacity(0.1)).toList(),
        ),
      ),
    ),
  ];
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 229, 235, 235),
        ),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.40,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 30,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: LineChart(
                  _data(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _data() {
    Widget _bottomTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10,
      );
      Widget text;
      switch (value.toInt()) {
        case 2:
          text = CustomButton(
              buttonStatus: _selected,
              buttonTitle: "Jan",
              ontap: () {
                setState(() {
                  _selected = true;
                  showingTooltipSpot = 0;
                });
              });
          break;
        case 4:
          text = CustomButton(
              buttonStatus: _selected,
              buttonTitle: "Jan",
              ontap: () {
                setState(() {
                  showingTooltipSpot = 1;
                });
              });
          break;
        case 6:
          text = CustomButton(
              buttonStatus: _selected,
              buttonTitle: "Jan",
              ontap: () {
                setState(() {
                  showingTooltipSpot = 2;
                  _getSpotIndicator.add(2);
                });
              });
          break;
        case 8:
          text = CustomButton(
              buttonStatus: _selected,
              buttonTitle: "Jan",
              ontap: () {
                setState(() {
                  showingTooltipSpot = 3;
                });
              });
          break;
        case 10:
          text = CustomButton(
              buttonStatus: _selected,
              buttonTitle: "Jan",
              ontap: () {
                setState(() {
                  showingTooltipSpot = 4;
                });
              });
          break;

        default:
          text = const Text('', style: style);
          break;
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    }

    Widget _leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );
      String text;
      switch (value.toInt()) {
        case 1:
          text = '10K';
          break;
        case 2:
          text = '25k';
          break;
        case 3:
          text = '50k';
          break;
        case 4:
          text = '100k';
          break;
        case 5:
          text = '200k';
          break;
        default:
          return Container();
      }

      return Text(text, style: style, textAlign: TextAlign.left);
    }

    return LineChartData(
      showingTooltipIndicators: showingTooltipSpot != -1
          ? [
              ShowingTooltipIndicators([
                LineBarSpot(lineBars[0], showingTooltipSpot,
                    lineBars[0].spots[showingTooltipSpot]),
              ])
            ]
          : [],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchCallback: (event, response) {
          if (response?.lineBarSpots != null && event is FlTapUpEvent) {
            setState(() {
              final spotIndex = response?.lineBarSpots?[0].spotIndex ?? -1;

              if (spotIndex == showingTooltipSpot) {
                showingTooltipSpot = -1;
              } else {
                showingTooltipSpot = spotIndex;
              }
            });
          }
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
          maxContentWidth: 60,
          tooltipRoundedRadius: 5,
          showOnTopOfTheChartBoxArea: false,
          fitInsideHorizontally: true,
          tooltipMargin: 0,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (LineBarSpot touchedSpot) {
                const textStyle = TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                );
                return LineTooltipItem(
                  points[touchedSpot.spotIndex].y.toStringAsFixed(2),
                  textStyle,
                );
              },
            ).toList();
          },
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) {
          print("indicator");
          print(barData);
          print(spotIndexes);
          List<TouchedSpotIndicatorData> _indicator = spotIndexes.map((e) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.green,
                dashArray: [5, 10],
              ),
              FlDotData(
                show: true,
              ),
            );
          }).toList();
          return _indicator;
        },
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: 6,

      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: Color.fromARGB(255, 53, 195, 88),
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: 1,
              getTitlesWidget: _leftTitleWidgets),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: _bottomTitleWidgets),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(),
        ),
      ),
      lineBarsData: lineBars,
      // lineBarsData: [
      //   LineChartBarData(
      //     // spots: points
      //     //     .map(
      //     //       (point) => FlSpot(point.x, point.y),
      //     //     )
      //     //     .toList(),

      //     isCurved: true,
      //     gradient: LinearGradient(
      //       colors: gradientColors2,
      //     ),
      //     barWidth: 1.5,
      //     isStrokeCapRound: true,
      //     dotData: FlDotData(
      //       show: true,
      //     ),
      //     belowBarData: BarAreaData(
      //       show: true,
      //       gradient: LinearGradient(
      //         colors: gradientColors
      //             .map((color) => color.withOpacity(0.1))
      //             .toList(),
      //       ),
      //     ),
      //   ),
      // ],
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color.fromARGB(255, 198, 192, 173),
            strokeWidth: 1,
          );
        },
      ),

      //
    );
  }
}
