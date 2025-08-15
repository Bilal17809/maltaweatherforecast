import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:maltaweatherforecast/core/services/date_time_service.dart';
import 'package:maltaweatherforecast/presentation/daily_forecast/view/daily_forecast_view.dart';
import '/core/common_widgets/common_widgets.dart';
import '/presentation/home/controller/home_controller.dart';
import '/presentation/splash/controller/splash_controller.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';

class DailyForecastList extends StatelessWidget {
  const DailyForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final splashController = Get.find<SplashController>();

    return Obx(() {
      final selectedCity = homeController.selectedCity.value;
      Map<String, dynamic> cityForecastData;
      if (selectedCity != null) {
        cityForecastData = splashController.getCityForecastData(selectedCity);
      } else {
        cityForecastData = splashController.rawForecastData;
      }

      final forecastDays =
          cityForecastData['forecast']?['forecastday'] as List?;
      final isLoading = forecastDays == null || homeController.isLoading.value;

      if (isLoading) {
        const shimmerItemCount = 4;
        return Container(
          height: mobileHeight(context) * 0.23,
          decoration: roundedDecorationWithShadow,
          child: ShimmerListView(
            itemCount: shimmerItemCount,
            itemHeight: mobileHeight(context) * 0.20,
          ),
        );
      }

      return SizedBox(
        height: mobileHeight(context) * 0.23,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: forecastDays.length,
          itemBuilder: (context, index) {
            final dayData = forecastDays[index]['day'];
            final date = DateTime.parse(forecastDays[index]['date']);
            final dayLabel = DateTimeService.getWeekday(date);
            final isToday = DateTime.now().day == date.day;

            return GestureDetector(
              onTap: () => Get.to(
                () => DailyForecastView(
                  weatherIconPath: 'weatherIconPath',
                  condition: 'condition',
                  temperature: 20,
                  feelsLike: 45,
                  precipitation: 'precipitation',
                  humidity: 'humidity',
                  windSpeed: 'windSpeed',
                ),
              ),
              child: _DailyForecast(
                day: dayLabel,
                isSelected: isToday,
                dayData: dayData,
              ),
            );
          },
        ),
      );
    });
  }
}

class _DailyForecast extends StatelessWidget {
  final String day;
  final bool isSelected;
  final Map<String, dynamic>? dayData;

  const _DailyForecast({
    required this.day,
    required this.isSelected,
    this.dayData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobileWidth(context) * 0.23,
      margin: EdgeInsets.symmetric(horizontal: 1),
      decoration: todayCardDecoration(isSelected),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dayData?['condition']?['icon'] != null
                ? Image.network(
                    'https:${dayData!['condition']['icon']}',
                    width: mediumIcon(context),
                    height: mediumIcon(context),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.wb_sunny,
                      size: primaryIcon(context),
                      color: kWhite,
                    ),
                  )
                : Icon(
                    Icons.wb_sunny,
                    size: mediumIcon(context),
                    color: kWhite,
                  ),
            // const Gap(kGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                day,
                style: titleMediumStyle(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const Gap(6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                dayData != null ? '${dayData!['avgtemp_c'].round()}°C' : '0°',
                style: bodyMediumStyle(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
