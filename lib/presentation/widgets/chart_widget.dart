import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
    required this.data,
  });

  final List<OrdinalData> data;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartBarO(
        animationDuration: const Duration(seconds: 2),
        barLabelDecorator:
            BarLabelDecorator(barLabelPosition: BarLabelPosition.outside),
        barLabelValue: (group, ordinalData, index) =>
            ordinalData.measure.toString(),
        domainAxis: const DomainAxis(numericViewport: NumericViewport(0, 12)),
        animate: true,
        groupList: [OrdinalGroup(id: "id", data: data)],
      ),
    );
  }
}
