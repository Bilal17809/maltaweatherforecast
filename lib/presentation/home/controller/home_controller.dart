import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/mixins/connectivity_mixin.dart';
import '/core/platform_channels/android_widget_channel.dart';
import '/domain/use_cases/use_case.dart';
import '/data/models/city_model.dart';
import '/core/services/services.dart';
import '/presentation/splash/controller/splash_controller.dart';

class HomeController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final CityStorageService cityStorageService;
  final LoadWeatherService loadWeatherService;

  HomeController(this.getCurrentWeather)
    : cityStorageService = Get.find<CityStorageService>(),
      loadWeatherService = Get.find<LoadWeatherService>();

  final splashController = Get.find<SplashController>();
  final conditionService = Get.find<ConditionService>();
  var isDrawerOpen = false.obs;
  final isLoading = false.obs;
  final selectedCities = <CityModel>[].obs;
  final selectedCity = Rx<CityModel?>(null);
  final autoScrollService = Get.find<AutoScrollService>();
  final scrollController = ScrollController();
  final isWeatherDataLoaded = false.obs;
  Timer? _autoUpdateTimer;

  @override
  void onInit() {
    super.onInit();
    _safeInit();
    WidgetUpdaterService.setupMethodChannelHandler();
    WidgetUpdateManager.startPeriodicUpdate();
  }

  Future<void> _safeInit() async {
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final allCities = splashController.allCities;
    final fallbackCity = splashController.currentCity;
    final selectedCityFromStorage = await cityStorageService.loadSelectedCity(
      allCities: allCities,
      currentLocationCity: fallbackCity,
    );

    selectedCities.value = [selectedCityFromStorage];
    await _initializeSelectedCity(selectedCityFromStorage);
    _startAutoUpdate();

    autoScrollService.setupAutoScroll(
      isWeatherDataLoaded: isWeatherDataLoaded,
      scrollController: scrollController,
    );

    ever<CityModel?>(splashController.selectedCity, (newCity) async {
      if (newCity != null &&
          LocationUtilsService.fromCityModel(selectedCity.value!) !=
              LocationUtilsService.fromCityModel(newCity)) {
        selectedCities.value = [newCity];
        await _initializeSelectedCity(newCity);

        autoScrollService.setupAutoScroll(
          isWeatherDataLoaded: isWeatherDataLoaded,
          scrollController: scrollController,
        );
      }
    });
  }

  @override
  void onClose() {
    _autoUpdateTimer?.cancel();
    isWeatherDataLoaded.value = false;
    super.onClose();
  }

  void _startAutoUpdate() {
    _autoUpdateTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      loadWeatherService.loadWeatherService(
        allCities,
        selectedCity: selectedCity.value,
        currentLocationCity: currentLocationCity,
      );
    });
  }

  Future<void> _initializeSelectedCity(CityModel city) async {
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    selectedCity.value = city;
  }

  List<CityModel> get allCities => splashController.allCities;
  CityModel? get currentLocationCity => splashController.currentCity;
  String get selectedCityName =>
      selectedCity.value?.city ?? splashController.selectedCityName;
}
