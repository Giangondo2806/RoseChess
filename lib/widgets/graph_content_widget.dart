import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphContent extends StatelessWidget {
  const GraphContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MoveData> chartData = [
      // ... your data
      MoveData(1, 'e2e4', 150),
      MoveData(2, 'd7d5', -50),
      MoveData(3, 'e4d5', 120),
      MoveData(4, 'c7c6', -30),
      MoveData(5, 'g1f3', 80),
      MoveData(6, 'b8c6', -20),
      MoveData(7, 'f1c4', 110),
      MoveData(8, 'g8f6', -40),
      MoveData(9, 'e1g1', 90),
      MoveData(10, 'e7e6', -10),
      MoveData(11, 'd2d4', 130),
      MoveData(12, 'f8b4', 50),
      MoveData(13, 'c1e3', 70),
      MoveData(14, 'd8d7', -60),
      MoveData(15, 'b1c3', 60),
      MoveData(16, 'a7a6', -15),
      MoveData(17, 'c4f7', 180),
      MoveData(18, 'e8f7', 20),
      MoveData(19, 'c3d5', 140),
      MoveData(20, 'd7d5', -80),
      MoveData(21, 'e3d2', 40),
      MoveData(22, 'b4c3', 75),
      MoveData(23, 'd2c3', 100),
      MoveData(24, 'f6d5', -90),
      MoveData(25, 'a2a3', 30),
      MoveData(26, 'f7f6', 10),
      MoveData(27, 'a1d1', 55),
      MoveData(28, 'd5f4', -110),
      MoveData(29, 'h2h4', 25),
      MoveData(30, 'c8e6', -25),
      MoveData(31, 'f1e1', 65),
      MoveData(32, 'g7g5', -70),
      MoveData(33, 'h1d1', 45),
      MoveData(34, 'f4d3', -130),
      MoveData(35, 'g2g3', 35),
      MoveData(36, 'h7h6', -12),
      MoveData(37, 'd1d3', 95),
      MoveData(38, 'e6c4', -55),
      MoveData(39, 'd4d5', 125),
      MoveData(40, 'd5f4', -85),
    ];

    final scores = chartData.map((data) => data.score).toList();
    final minScore =
        scores.reduce((min, current) => min < current ? min : current);
    final maxScore =
        scores.reduce((max, current) => max > current ? max : current);

    // Tính toán điểm chuyển màu
    final range = maxScore - minScore;
    final zeroPosition = range == 0
        ? 0.5
        : (maxScore.abs() / (maxScore.abs() + minScore.abs()));

    List<double> stops;

    if (maxScore <= 0) {
      stops = [0, 0, 0, zeroPosition, 1];
    } else if (minScore >= 0) {
      stops = [0, zeroPosition, 1, 1, 1];
    } else {
      stops = [0, zeroPosition - 0.01, zeroPosition, zeroPosition + 0.0, 1];
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: chartData.length * 60.0, // Tăng độ rộng
        child: SfCartesianChart(
          primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0), // Ẩn major tick lines
            axisLabelFormatter: (AxisLabelRenderDetails details) {
              int index = details.value.toInt();
              String label = chartData[index].move;
              return ChartAxisLabel(label, details.textStyle);
            },
            interval: 1,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelIntersectAction:
                AxisLabelIntersectAction.none, // Không xử lý chồng chéo label
          ),
          primaryYAxis: NumericAxis(
            minimum: minScore.toDouble(),
            maximum: maxScore.toDouble(),
            axisLine: const AxisLine(width: 2, color: Colors.black),
            majorGridLines: const MajorGridLines(width: 0),
          ),
          legend: Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            format: 'Move: point.x\nScore: point.y',
          ),
          series: <CartesianSeries<MoveData, num>>[
            AreaSeries<MoveData, num>(
              dataSource: chartData,
              xValueMapper: (MoveData data, index) => index,
              yValueMapper: (MoveData data, _) => data.score,
              name: 'Score',
              borderColor: Colors.transparent,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withAlpha(170),
                  Colors.blue.withAlpha(170),
                  Colors.black,
                  Colors.red.withAlpha(170),
                  Colors.red.withAlpha(170),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: stops,
              ),
            ),
          ],
          onMarkerRender: (MarkerRenderArgs args) {
            if (args.pointIndex != null) {
              final MoveData currentPoint = chartData[args.pointIndex!];
              args.color = currentPoint.score < 0 ? Colors.red : Colors.green;
            }
          },
        ),
      ),
    );
  }
}

class MoveData {
  MoveData(this.moveNumber, this.move, this.score);

  final int moveNumber;
  final String move;
  final int score;
}