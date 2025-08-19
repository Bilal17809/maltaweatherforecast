import 'package:flutter/material.dart';
import '/core/animation/services/animation_service.dart';
import '../extension/weather_condition_extension.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final String imagePath;
  final String condition;
  final int? weatherCode;
  final double? width;
  final double? height;

  const AnimatedWeatherIcon({
    super.key,
    required this.imagePath,
    required this.condition,
    this.weatherCode,
    this.width,
    this.height,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with TickerProviderStateMixin {
  late IconAnimationService _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = IconAnimationService();
    _iconAnimationController.initialize(
      vsync: this,
      condition: _getWeatherCondition(),
    );
  }

  WeatherCondition _getWeatherCondition() {
    if (widget.weatherCode != null) {
      final code = widget.weatherCode!;
      return code.toWeatherCondition;
    }
    final cond = widget.condition;
    return cond.toWeatherCondition;
  }

  @override
  void didUpdateWidget(AnimatedWeatherIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.condition != widget.condition ||
        oldWidget.weatherCode != widget.weatherCode) {
      _iconAnimationController.updateCondition(_getWeatherCondition());
    }
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _iconAnimationController.applyAnimation(
      Image.asset(widget.imagePath, width: widget.width, height: widget.height),
    );
  }
}
