import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_chess/providers/graph_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphContent extends StatelessWidget {
  const GraphContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GraphState graphState = Provider.of<GraphState>(context);

    final List<MoveData> chartData = graphState.chartData
        .where((test)=>test.evaluation!=null)
        .toList()
        .asMap()
        .entries
        .map((entry) =>
            MoveData(entry.key, entry.value.san, entry.value.evaluation))
        .toList();

    if (chartData.length < 3) {
      return const Center(
        child: Text("Not enough data to display the graph."),
      );
    }

    final scores = chartData.map((data) => data.score).toList();
   
    final minScore =
        scores.reduce((min, current) => min < current ? min : current);
    final maxScore =
        scores.reduce((max, current) => max > current ? max : current);

    // Tính toán điểm chuyển màu
    final range = maxScore - minScore;
    final zeroPosition =
        range == 0 ? 0.5 : (maxScore.abs() / (maxScore.abs() + minScore.abs()));

    List<double> stops;

    if (maxScore <= 0) {
      stops = [0, 0, 0, zeroPosition, 1];
    } else if (minScore >= 0) {
      stops = [0, zeroPosition, 1, 1, 1];
    } else {
      stops = [0, zeroPosition - 0.01, zeroPosition, zeroPosition + 0.0, 1];
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines:
                    const MajorTickLines(size: 0), // Ẩn major tick lines
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  int index = details.value.toInt();
                  String label = chartData[index].move;
                  
                  return ChartAxisLabel(
                    label,
                    details.textStyle,
                  );
                },
                labelRotation: 45,
                interval: 1,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                labelIntersectAction: AxisLabelIntersectAction
                    .none, // Không xử lý chồng chéo label
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 2, color: Colors.black),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              legend: Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'Move: point.x\nScore: point.y',
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enableDoubleTapZooming: true,
                enablePanning: true,
                zoomMode: ZoomMode.xy,
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
                  args.color =
                      currentPoint.score < 0 ? Colors.red : Colors.green;
                }
              },
            ),
          ),
        ],
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
