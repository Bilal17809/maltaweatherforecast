import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/bg_animation_service.dart';
import '/core/utils/weather_utils.dart';
import '/presentation/home/controller/home_controller.dart';
import '/core/constants/constants.dart';
import 'animated_bg_image.dart';

class AnimatedBgImageBuilder extends StatelessWidget {
  const AnimatedBgImageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final bgAnimationService = Get.find<BgAnimationService>();

    return AnimatedBuilder(
      animation: bgAnimationService.animation,
      builder: (context, child) {
        final offsetX =
            -bgAnimationService.animation.value * mobileWidth(context);

        final selectedCity = homeController.selectedCity.value;
        final weather = selectedCity != null
            ? homeController.conditionService.allCitiesWeather[selectedCity
                  .cityAscii]
            : null;

        final weatherType = WeatherUtils.getWeatherIcon(weather?.code ?? 1000);

        return Positioned(
          left: offsetX,
          top: 0,
          child: AnimatedBgImage(weatherType: weatherType),
        );
      },
    );
  }
}
