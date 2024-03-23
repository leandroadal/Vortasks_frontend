import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test_application/services/level/level.dart';

class MyXpChart extends StatelessWidget {
  const MyXpChart({super.key, required this.xpPercentage, required this.level});

  final double xpPercentage;
  final Level level;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 30,
              sections: showingSections(),
            ),
          ),
          const Center(
            child: Text(
              'XP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double remainingPercentage = 100 - xpPercentage;

    return [
      PieChartSectionData(
        color: const Color(0xFF963bf0),
        value: xpPercentage,
        title: '${xpPercentage.toStringAsFixed(1)}%',
        radius: 15,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFFcbe8ff),
        value: remainingPercentage,
        title: '',
        radius: 15,
      ),
    ];
  }
}
