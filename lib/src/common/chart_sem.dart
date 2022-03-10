import 'package:flutter/material.dart';
import 'package:lenospizza/src/models/sales_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSemana extends StatelessWidget {
  final List<TimeSeriesSales> seriesList;
  final bool animate;
  final Function(int) onTap;

  const ChartSemana(this.seriesList,
      {Key? key, required this.animate, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            interval: 1,
            labelStyle: const TextStyle(color: Colors.black45, fontSize: 11),
            intervalType: DateTimeIntervalType.days,
            minimum: DateTime(seriesList[0].time.year, seriesList[0].time.month,
                seriesList[0].time.day - 1),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        legend: Legend(isVisible: true, position: LegendPosition.top),
        // Enable tooltip
        primaryYAxis: NumericAxis(
            labelFormat: '\${value}',
            labelStyle: const TextStyle(color: Colors.black45, fontSize: 11),
            majorTickLines: const MajorTickLines(size: 0)),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        onDataLabelTapped: (DataLabelTapDetails onTapArgs) {
          print("TAps ${onTapArgs.pointIndex}");
          onTap(onTapArgs.pointIndex);
        },
        series: <ChartSeries<TimeSeriesSales, DateTime>>[
          SplineSeries<TimeSeriesSales, DateTime>(
              dataSource: seriesList,
              xValueMapper: (TimeSeriesSales sales, _) => sales.time,
              yValueMapper: (TimeSeriesSales sales, _) => sales.sales,
              markerSettings: const MarkerSettings(
                  isVisible: true, shape: DataMarkerType.circle),
              color: Colors.amber,
              name: 'Ventas',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                useSeriesColor: true,
                alignment: ChartAlignment.far,
                labelAlignment: ChartDataLabelAlignment.middle,
                offset: Offset(0, 0),
              )),
        ]);
  }
}
