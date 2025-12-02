import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class MultiColorProgressBar extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const MultiColorProgressBar({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    double percent = (completedTasks / totalTasks).clamp(0, 1);
    Color barColor = _getColor(percent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Percentage at top-right
        Align(
          alignment: Alignment.centerRight,
          child: objCommonWidgets.customText(context,
              "${(percent * 100).toStringAsFixed(0)}%",
              12.5,
              objConstantColor.white,
              objConstantFonts.montserratSemiBold)
        ),


        const SizedBox(height: 4),

        // Progress Bar
        Row(
          children: [
            Expanded(
              child: Container(
                height: 5.dp,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10.dp),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          width: constraints.maxWidth * percent,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(10.dp),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  /// Decide color based on percentage
  Color _getColor(double percent) {
    if (percent <= 0.20) return Colors.red;
    if (percent <= 0.49) return Colors.yellow;
    if (percent <= 0.79) return Colors.orange;
    return Colors.green;
  }
}
