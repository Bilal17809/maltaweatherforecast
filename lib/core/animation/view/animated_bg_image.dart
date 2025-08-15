import 'package:flutter/material.dart';
import '/core/constants/constants.dart';
import '/core/utils/weather_utils.dart';

class AnimatedBgImage extends StatelessWidget {
  final String weatherType;

  const AnimatedBgImage({super.key, required this.weatherType});

  @override
  Widget build(BuildContext context) {
    final bgPath = WeatherUtils.getWeatherBgPath(weatherType);
    return SizedBox(
      width: mobileWidth(context) * 2,
      height: mobileHeight(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgPath),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
      ),
    );
  }
}
