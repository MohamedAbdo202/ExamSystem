import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Shared/components/components.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'VisualizationQuestion.dart';

class VisualizationPage extends StatefulWidget {
  final String courseId;
  final List<int> userDegrees;
  final String docId;

  VisualizationPage({required this.courseId, required this.userDegrees,required this.docId});

  @override
  _VisualizationPageState createState() => _VisualizationPageState();
}

class _VisualizationPageState extends State<VisualizationPage> {
  late List<ChartData> chartData;
  late List<BoxPlotData> boxPlotData;
  late List<BarChartData> barChartData;

  @override
  void initState() {
    super.initState();

    // Initialize chart data
    chartData = List.generate(widget.userDegrees.length, (index) {
      return ChartData('User ${index + 1}', widget.userDegrees[index]);
    });

    boxPlotData = [
      BoxPlotData('Boxplot', widget.userDegrees),
    ];

    barChartData = List.generate(widget.userDegrees.length, (index) {
      return BarChartData('user ${index + 1}', widget.userDegrees[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualization Page'),
        actions: [Padding(padding: EdgeInsets.only(right: 10),
            child: defaultButton(function: (){

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExamScreen99(docId:widget.docId,courseId:widget.courseId)));


            }, text: 'MORE',width: 100.w,background: Colors.white))],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 300.h,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.label,
                    yValueMapper: (ChartData data, _) => data.value,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 250.h
            ,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                BoxAndWhiskerSeries<BoxPlotData, String>(
                  dataSource: boxPlotData,
                  xValueMapper: (BoxPlotData data, _) => data.x,
                  yValueMapper: (BoxPlotData data, _) => data.y,
                ),
              ],
            ),
          ),
          Container(
            height: 200.h,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                BarSeries<BarChartData, String>(
                  dataSource: barChartData,
                  xValueMapper: (BarChartData data, _) => data.x,
                  yValueMapper: (BarChartData data, _) => data.y,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.label, this.value);

  final String label;
  final int value;
}

class BoxPlotData {
  BoxPlotData(this.x, this.y);

  final String x;
  final List<int> y;

}

class BarChartData {
  BarChartData(this.x, this.y);

  final String x;
  final int y;
}
