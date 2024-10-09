import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../constants/colors.dart';
import '../../utils/index_provider.dart'; // Adjust the path if necessary

class StepsCard extends StatelessWidget {
  final String iconPath;
  final double progress; // Add progress field
  final VoidCallback onTap;

  const StepsCard({
    Key? key,
    required this.iconPath,
    required this.onTap,
    required this.progress, // Initialize progress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: onTap, // This will be the navigation action
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
        elevation: 2,
        child: Container(
          height: 220, // Adjust height to fit the new content
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: ColorPalette.primary,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 218,
                    decoration: BoxDecoration(
                      color: ColorPalette.accentOrange,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          iconPath,
                          width: 70,
                          height: 70,
                          color: ColorPalette.accentBlack,
                        ),
                        const SizedBox(height: 10), // Add spacing between image and text
                        Text(
                          "Walk", // Display the title here
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.accentBlack,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/icons/clock.png", // Use iconPath for the icon
                              width: 15,
                              height: 15,
                              color: ColorPalette.accentBlack,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "5 mins ago",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: ColorPalette.accentBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        changePage(index: 1, context: context);
                      },
                    child: Container(
                      height: 170, // Adjust the height of the chart container
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          RadialBarSeries<RadialBarData, String>(
                            dataSource: <RadialBarData>[
                              RadialBarData('Progress', progress, ColorPalette.accentOrange),
                            ],
                            xValueMapper: (RadialBarData data, _) => data.label,
                            yValueMapper: (RadialBarData data, _) => data.value,
                            pointColorMapper: (RadialBarData data, _) => data.color,
                            cornerStyle: CornerStyle.bothFlat,
                            trackColor: ColorPalette.gray,
                            radius: '90%',
                            innerRadius: '95%',
                            maximumValue: 1000,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: false, // Hide data labels
                            ),
                          ),
                        ],
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  progress.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Steps',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadialBarData {
  RadialBarData(this.label, this.value, this.color);
  final String label;
  final double value;
  final Color color; // Added color property
}
