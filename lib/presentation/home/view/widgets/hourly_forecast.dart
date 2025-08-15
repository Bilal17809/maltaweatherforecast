import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/presentation/home/controller/home_controller.dart';
import '/presentation/splash/controller/splash_controller.dart';
import '/core/constants/constants.dart';
import '/core/theme/theme.dart';
import '../../../../core/common_widgets/shimmers.dart';

class HourlyForecastList extends StatelessWidget {
  final ScrollController? customScrollController;

  const HourlyForecastList({super.key, this.customScrollController});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final splashController = Get.find<SplashController>();
    final scrollController =
        customScrollController ?? homeController.scrollController;

    return Obx(() {
      final selectedCity = homeController.selectedCity.value;
      Map<String, dynamic> cityForecastData;
      if (selectedCity != null) {
        cityForecastData = splashController.getCityForecastData(selectedCity);
      } else {
        cityForecastData = splashController.rawForecastData;
      }

      final forecastDays = cityForecastData['forecast']?['forecastday'];
      final todayData = (forecastDays as List?)?.firstOrNull;
      final hourlyList = todayData?['hour'] as List? ?? [];
      final now = DateTime.now();
      final isLoading = forecastDays == null || homeController.isLoading.value;

      if (isLoading) {
        const shimmerItemCount = 4;
        return Container(
          height: mobileHeight(context) * 0.16,
          decoration: roundedDecorationWithShadow,
          child: ShimmerListView(
            itemCount: shimmerItemCount,
            itemHeight: mobileHeight(context) * 0.12,
          ),
        );
      }

      if (hourlyList.isEmpty) {
        return Container(
          height: mobileHeight(context) * 0.16,
          decoration: roundedDecorationWithShadow,
          child: Center(
            child: Text(
              'No hourly data available',
              style: bodyMediumStyle(
                context,
              ).copyWith(color: kWhite.withValues(alpha: 0.7)),
            ),
          ),
        );
      }

      return Container(
        height: mobileHeight(context) * 0.16,
        decoration: roundedDecorationWithShadow,
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: hourlyList.length,
          itemBuilder: (context, index) {
            final hourData = hourlyList[index];
            final hourTime = DateTime.parse(hourData['time']);
            final hourLabel = TimeOfDay.fromDateTime(hourTime).format(context);
            final isCurrentHour = hourTime.hour == now.hour;

            return _HourlyForecast(
              day: hourLabel,
              isSelected: isCurrentHour,
              hourData: hourData,
            );
          },
        ),
      );
    });
  }
}

class _HourlyForecast extends StatelessWidget {
  final String day;
  final bool isSelected;
  final Map<String, dynamic>? hourData;

  const _HourlyForecast({
    required this.day,
    required this.isSelected,
    this.hourData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: mobileWidth(context) * 0.17,
        margin: EdgeInsets.symmetric(horizontal: kGap / 2),
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: kWhite, width: 2),
                borderRadius: BorderRadius.circular(kBorderRadius),
              )
            : null,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hourData?['condition']?['icon'] != null
                  ? Image.network(
                      'https:${hourData!['condition']['icon']}',
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
              const Gap(kGap),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  day,
                  style: bodyMediumStyle(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Gap(6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  hourData != null ? '${hourData!['temp_c'].round()}°C' : '0°',
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
      ),
    );
  }
}
