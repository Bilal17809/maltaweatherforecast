import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/constants/constants.dart';

class AutoScrollService {
  void setupAutoScroll({
    required RxBool isWeatherDataLoaded,
    required ScrollController scrollController,
    DateTime? selectedDate,
  }) {
    isWeatherDataLoaded.listen((loaded) {
      if (loaded) {
        _performAutoScroll(scrollController, selectedDate);
      }
    });

    if (isWeatherDataLoaded.value) {
      _performAutoScroll(scrollController, selectedDate);
    }
  }

  void _performAutoScroll(
    ScrollController scrollController,
    DateTime? selectedDate,
  ) {
    final now = DateTime.now();
    final isToday =
        selectedDate == null ||
        (selectedDate.year == now.year &&
            selectedDate.month == now.month &&
            selectedDate.day == now.day);

    if (!isToday) {
      return;
    }

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!scrollController.hasClients) return;

      timer.cancel();
      final context = scrollController.position.context.storageContext;
      final double itemWidth = mobileWidth(context) * 0.19;
      final int currentHour = DateTime.now().hour;
      final double targetScrollOffset = currentHour * itemWidth;

      scrollController.animateTo(
        targetScrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}
