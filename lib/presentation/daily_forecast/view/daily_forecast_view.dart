import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/core/animation/view/animated_weather_icon.dart';
import '/core/constants/constants.dart';
import '/core/utils/weather_utils.dart';
import '/presentation/daily_forecast/controller/daily_forecast_controller.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';

class DailyForecastView extends StatelessWidget {
  final String cityName;
  const DailyForecastView({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final dailyController = Get.find<DailyForecastController>();

    final args = Get.arguments as Map<String, dynamic>;
    final DateTime date = args['date'];
    final Map<String, dynamic>? dayData = args['dayData'];

    return Scaffold(
      body: Container(
        decoration: bgGradient,
        child: SafeArea(
          child: Column(
            children: [
              TitleBar(subtitle: cityName),
              Column(
                children: [
                  AnimatedWeatherIcon(
                    imagePath: WeatherUtils.getWeatherIconPath(
                      WeatherUtils.getWeatherIcon(
                        dayData?['condition']?['code'],
                      ),
                    ),
                    condition: dayData?['condition']?['text'] ?? '--',
                    width: primaryIcon(context),
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                    dayData?['condition']?['text'] ?? '--',
                    style: titleMediumStyle(context),
                  ),
                  const Gap(kGap),
                  Text(
                    '${dayData!['avgtemp_c'].round()}°C',
                    style: headlineSmallStyle(context),
                  ),
                ],
              ),
              const Gap(kGap),
              Divider(color: kWhite.withValues(alpha: 0.25)),
              _InfoTile(title: "Wind", value: "${dayData['maxwind_kph']} km/h"),
              _InfoTile(title: "Humidity", value: "${dayData['avghumidity']}%"),
              _InfoTile(
                title: "Pressure",
                value: "${dayData['pressure_mb']} mb",
              ),
              _InfoTile(
                title: "Precipitation",
                value: "${dayData['daily_chance_of_rain']}%",
              ),
              _InfoTile(title: "Sunrise", value: dayData['sunrise'] ?? '--'),
              _InfoTile(title: "Sunset", value: dayData['sunset'] ?? '--'),
              Divider(color: kWhite.withValues(alpha: 0.25)),
              const Gap(kGap),
              HourlyForecastList(
                customScrollController: dailyController.scrollController,
                selectedDate: date,
                showBg: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const _InfoTile({required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: kWhite)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: kWhite),
          ),
        ],
      ),
    );
  }
}
