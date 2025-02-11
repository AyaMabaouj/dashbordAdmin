import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 120)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 150)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 200)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 180)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 250)]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 300)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
