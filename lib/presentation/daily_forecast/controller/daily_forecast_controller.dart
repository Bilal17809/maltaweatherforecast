import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/mixins/connectivity_mixin.dart';
import '/core/services/services.dart';
import '/presentation/home/controller/home_controller.dart';

class DailyForecastController extends GetxController with ConnectivityMixin {
  var forecastData = <Map<String, dynamic>>[].obs;
  final homeController = Get.find<HomeController>();
  final conditionService = Get.find<ConditionService>();
  final autoScrollService = Get.find<AutoScrollService>();
  final scrollController = ScrollController();
  final isWeatherDataLoaded = false.obs;
  var selectedDayIndex = 0.obs;
  var selectedCityName = ''.obs;
  var currentWeatherCardHeight = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        loadForecastData();
        isWeatherDataLoaded.value = true;
        autoScrollService.setupAutoScroll(
          isWeatherDataLoaded: isWeatherDataLoaded,
          scrollController: scrollController,
        );
        ever(homeController.selectedCity, (_) {
          loadForecastData();
          autoScrollService.setupAutoScroll(
            isWeatherDataLoaded: isWeatherDataLoaded,
            scrollController: scrollController,
          );
        });
      },
    );
  }

  @override
  void onClose() {
    isWeatherDataLoaded.value = false;
    super.onClose();
  }

  void loadForecastData() {
    selectedCityName.value = homeController.selectedCityName;
    forecastData.value = conditionService.weeklyForecast;
  }

  Map<String, dynamic>? get selectedDayData =>
      forecastData.isNotEmpty && selectedDayIndex.value < forecastData.length
      ? forecastData[selectedDayIndex.value]
      : null;

  String get cityName => selectedCityName.value;

  int get totalDays => forecastData.length;

  bool get hasForecastData => forecastData.isNotEmpty;
}
