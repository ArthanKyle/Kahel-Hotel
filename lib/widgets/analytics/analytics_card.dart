import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular chart for steps using Syncfusion
          SfCircularChart(
            series: <CircularSeries>[
              RadialBarSeries<ChartData, String>(
                dataSource: [ChartData('Steps', 0)],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                maximumValue: 200, // Example maximum step count
                radius: '100%',
                innerRadius: '70%',
                cornerStyle: CornerStyle.bothCurve,
                pointColorMapper: (ChartData data, _) => Colors.orange,
                dataLabelMapper: (ChartData data, _) => '${data.y} steps',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map, color: Colors.orange),
            label: const Text(
              'Route',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

// ChartData class for the Syncfusion chart
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}