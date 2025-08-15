import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:maltaweatherforecast/core/animation/view/animated_weather_icon.dart';
import 'package:maltaweatherforecast/presentation/home/view/widgets/daily_forecast_list.dart';
import '../../controller/home_controller.dart';
import '/core/services/services.dart';
import '/core/utils/weather_utils.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/cities/view/cities_view.dart';
import 'hourly_forecast.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(() {
      final selectedCity = homeController.selectedCity.value;
      final weather = selectedCity != null
          ? homeController.conditionService.allCitiesWeather[selectedCity
                .cityAscii]
          : null;
      final temp = weather?.temperature.round().toString() ?? '--';

      if (selectedCity == null || weather == null) {
        return Column(
          children: [
            TitleBar(
              title: homeController.selectedCityName,
              subtitle: DateTimeService.getFormattedCurrentDate(),
              useBackButton: false,
              actions: [
                IconActionButton(
                  onTap: () {
                    Get.to(
                      () => const CitiesView(),
                      transition: Transition.fadeIn,
                    );
                  },
                  icon: Icons.add_circle_rounded,
                  color: getIconColor(context),
                  size: secondaryIcon(context),
                ),
              ],
            ),
            Expanded(
              child: Center(child: CircularProgressIndicator(color: kWhite)),
            ),
          ],
        );
      }

      return Column(
        children: [
          TitleBar(
            title: homeController.selectedCityName,
            subtitle: DateTimeService.getFormattedCurrentDate(),
            useBackButton: false,
            actions: [
              IconActionButton(
                onTap: () {
                  Get.to(
                    () => const CitiesView(),
                    transition: Transition.fadeIn,
                  );
                },
                icon: Icons.add_circle_rounded,
                color: getIconColor(context),
                size: secondaryIcon(context),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedWeatherIcon(
                  imagePath: WeatherUtils.getWeatherIconPath(
                    WeatherUtils.getWeatherIcon(weather.code),
                  ),
                  condition: weather.condition,
                  width: primaryIcon(context),
                ),
                Text(
                  weather.condition,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 19,
                    color: kWhite,
                  ),
                ),
                Text(
                  '$temp°C',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const SizedBox(height: 8)],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kElementGap),
            child: HourlyForecastList(),
          ),
          Padding(
            padding: const EdgeInsets.all(kElementGap),
            child: DailyForecastList(),
          ),
        ],
      );
    });
  }
}
