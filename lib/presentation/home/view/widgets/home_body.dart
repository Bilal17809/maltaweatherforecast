import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/core/animation/view/animated_weather_icon.dart';
import '/presentation/home/view/widgets/daily_forecast_list.dart';
import '../../controller/home_controller.dart';
import '/core/services/services.dart';
import '/core/utils/weather_utils.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/cities/view/cities_view.dart';

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
        return Center(child: CircularProgressIndicator(color: kWhite));
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                  weather.condition,
                  style: titleMediumStyle(context),
                ),
                const Gap(kGap),
                Text('$temp°C', style: headlineSmallStyle(context)),
                const Gap(kGap),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kElementGap),
            child: HourlyForecastList(showBg: true),
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
