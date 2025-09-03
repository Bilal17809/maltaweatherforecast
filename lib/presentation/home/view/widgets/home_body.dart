import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/ad_manager/ad_manager.dart';
import '/core/platform_channels/android_widget_channel.dart';
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
    final nativeAds = Get.find<NativeAdController>();
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
          GestureDetector(
            onLongPress: () async {
              final isActive = await WidgetUpdaterService.isWidgetActive();
              if (!isActive) {
                await WidgetUpdaterService.requestPinWidget();
                Future.delayed(const Duration(seconds: 1));
              } else {
                WidgetUpdateManager.updateWeatherWidget();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mobileWidth(context) * 0.2,
                vertical: mobileWidth(context) * 0.11,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: AnimatedWeatherIcon(
                      imagePath: WeatherUtils.getWeatherIconPath(
                        WeatherUtils.getWeatherIcon(weather.code),
                      ),
                      condition: weather.condition,
                      width: primaryIcon(context),
                    ),
                  ),
                  const Gap(kGap),
                  Flexible(
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            maxLines: 1,
                            '$temp°C',
                            style: headlineLargeStyle(context),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            weather.condition,
                            style: titleLargeStyle(context),
                          ),
                        ),
                        const Gap(kGap),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kElementGap),
              child: HourlyForecastList(showBg: true),
            ),
          ),
          const SizedBox(height: kElementGap),
          if (!homeController.isDrawerOpen.value &&
              !Get.find<AppOpenAdManager>().isAdVisible.value) ...[
            MyNativeAdWidget(),
          ],

          // if (!homeController.isDrawerOpen.value) ...[
          //   const Gap(kElementGap),
          //   Obx(() {
          //     final nativeAdManager = Get.find<NativeAdManager>();
          //     return nativeAdManager.isAdLoaded.value
          //         ? nativeAdManager.showNativeAd()
          //         : const NativeAdShimmer();
          //   }),
          // ],
          const SizedBox(height: kElementGap),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(kElementGap),
              child: DailyForecastList(),
            ),
          ),
        ],
      );
    });
  }
}
