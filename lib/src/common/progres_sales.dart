import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressCircleSales extends StatelessWidget {
  const ProgressCircleSales({Key? key, required this.dataList})
      : super(key: key);

  final List<ChartSampleData> dataList;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        key: GlobalKey(),
        title: ChartTitle(
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <RadialBarSeries<ChartSampleData, String>>[
          RadialBarSeries<ChartSampleData, String>(
              maximumValue: 100,
              dataLabelSettings: const DataLabelSettings(
                  isVisible: false, textStyle: TextStyle(fontSize: 10.0)),
              dataSource: dataList,
              cornerStyle: CornerStyle.bothCurve,
              innerRadius: '50%',
              gap: '70%',
              radius: '155%',
              xValueMapper: (ChartSampleData data, _) => data.x as String,
              yValueMapper: (ChartSampleData data, _) => data.y,
              pointColorMapper: (ChartSampleData data, _) => Colors.white,
              dataLabelMapper: (ChartSampleData data, _) => data.x as String)
        ]);
  }
}

class ChartSampleData {
  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  ChartSampleData({this.x, this.y});
}
