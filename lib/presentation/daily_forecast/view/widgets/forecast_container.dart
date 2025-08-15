import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/daily_forecast_controller.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import 'forecast_row.dart';

class ForecastContainer extends StatelessWidget {
  const ForecastContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyForecastController>();

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(kBodyHp),
        decoration: roundedForecastDecor(context),
        child: Padding(
          padding: EdgeInsets.only(
            top: controller.currentWeatherCardHeight.value / 4,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...controller.forecastData.map(
                  (dayData) => ForecastRow(
                    day: dayData['day'] ?? '',
                    iconUrl: dayData['iconUrl'] ?? '',
                    maxTemp: dayData['temp']?.round() ?? 0,
                    minTemp: dayData['minTemp']?.round() ?? 0,
                    condition: dayData['condition'] ?? '',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
