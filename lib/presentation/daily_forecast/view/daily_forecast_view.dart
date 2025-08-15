import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/view/widgets/hourly_forecast.dart';
import '/core/services/services.dart';
import '/presentation/home/controller/home_controller.dart';
import '/core/global_keys/global_key.dart';
import '/presentation/daily_forecast/controller/daily_forecast_controller.dart';
import '/core/animation/view/animated_bg_builder.dart';
import '/core/theme/theme.dart';
import '/presentation/cities/view/cities_view.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/constants/constants.dart';
import 'widgets/forecast_container.dart';
import 'widgets/weather_card.dart';

class DailyForecastView extends StatelessWidget {
  final String weatherIconPath;
  final String condition;
  final int temperature;
  final int feelsLike;
  final String precipitation;
  final String humidity;
  final String windSpeed;

  const DailyForecastView({
    super.key,
    required this.weatherIconPath,
    required this.condition,
    required this.temperature,
    required this.feelsLike,
    required this.precipitation,
    required this.humidity,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBgImageBuilder(),
          Positioned(
            top: mobileHeight(context) * 0.5,
            left: 0,
            right: 0,
            bottom: 0,
            child: const ForecastContainer(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  TitleBar(
                    title: Get.find<HomeController>().selectedCityName,
                    subtitle: DateTimeService.getFormattedCurrentDate(),
                    actions: [
                      IconActionButton(
                        onTap: () => Get.to(
                          () => const CitiesView(),
                          transition: Transition.fade,
                        ),
                        icon: Icons.add,
                        color: getIconColor(context),
                        size: secondaryIcon(context),
                      ),
                    ],
                  ),
                  HourlyForecastList(
                    customScrollController:
                        Get.find<DailyForecastController>().scrollController,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kBodyHp * 2,
                      vertical: kElementGap,
                    ),
                    child: CurrentWeatherCard(
                      key: globalKey,
                      weatherIconPath: weatherIconPath,
                      condition: condition,
                      temperature: temperature,
                      feelsLike: feelsLike,
                      precipitation: precipitation,
                      humidity: humidity,
                      windSpeed: windSpeed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
