import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '/core/common/app_exceptions.dart';
import '/presentation/home/controller/home_controller.dart';
import '/core/local_storage/local_storage.dart';
import '/core/mixins/connectivity_mixin.dart';
import '/core/services/services.dart';
import '/data/models/city_model.dart';
import '/domain/use_cases/use_case.dart';

class SplashController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final LocalStorage localStorage;
  final CurrentLocationService currentLocationService;
  final LoadCitiesService cityService;
  final CityStorageService cityStorageService;
  final LoadWeatherService loadWeatherService;

  SplashController({
    required this.getCurrentWeather,
    required this.localStorage,
    required this.currentLocationService,
    required this.cityService,
    required this.cityStorageService,
    required this.loadWeatherService,
  });

  final conditionService = Get.find<ConditionService>();
  final isLoading = true.obs;
  final isDataLoaded = false.obs;
  final allCities = <CityModel>[].obs;
  final currentLocationCity = Rx<CityModel?>(null);
  final selectedCity = Rx<CityModel?>(null);
  final isFirstLaunch = true.obs;
  final RxMap<String, Map<String, dynamic>> _rawDataStorage =
      <String, Map<String, dynamic>>{}.obs;
  final rawForecastData = <String, dynamic>{}.obs;
  var showButton = false.obs;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 500), () {
      initWithConnectivityCheck(
        context: Get.context!,
        onConnected: () async {
          _initializeApp();
        },
      );
    });
  }

  Future<void> _initializeApp() async {
    try {
      isLoading.value = true;
      isDataLoaded.value = false;
      allCities.value = await cityService.loadAllCities();
      await _checkFirstLaunch();
      currentLocationCity.value = await currentLocationService
          .getCurrentLocationCity(allCities);
      if (isFirstLaunch.value) {
        await _setupFirstLaunch();
      } else {
        selectedCity.value = await cityStorageService.loadSelectedCity(
          allCities: allCities,
          currentLocationCity: currentLocationCity.value,
        );
        await cityStorageService.saveSelectedCity(selectedCity.value);
      }
      await loadWeatherService.loadWeatherService(
        allCities,
        selectedCity: selectedCity.value,
        currentLocationCity: currentLocationCity.value,
      );
      _updateRawForecastDataForCurrentCity();
      Get.find<HomeController>().isWeatherDataLoaded.value = true;
      isDataLoaded.value = true;
    } catch (e) {
      debugPrint('${AppExceptions().errorAppInit}: $e');
      isDataLoaded.value = true;
    } finally {
      isLoading.value = false;
      showButton.value = true;
    }
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final savedCityJson = await localStorage.getString('selected_city');
      final hasCurrentLocation =
          await localStorage.getBool('has_current_location') ?? false;
      isFirstLaunch.value = savedCityJson == null || !hasCurrentLocation;
    } catch (e) {
      debugPrint('${AppExceptions().firstLaunch}: $e');
      isFirstLaunch.value = true;
    }
  }

  Future<void> _setupFirstLaunch() async {
    final currentCity = currentLocationCity.value;

    if (currentCity != null) {
      selectedCity.value = currentCity;
    } else {
      final valletta = allCities.firstWhere(
        (city) => city.cityAscii.toLowerCase() == 'valletta',
        orElse: () => allCities.first,
      );
      selectedCity.value = valletta;
    }
    await cityStorageService.saveSelectedCity(selectedCity.value);
    await localStorage.setBool('has_current_location', currentCity != null);
  }

  void cacheCityData(String key, Map<String, dynamic> data) {
    _rawDataStorage[key] = data;
  }

  void _updateRawForecastDataForCurrentCity() {
    final key = LocationUtilsService.fromCityModel(selectedCity.value!);
    if (_rawDataStorage.containsKey(key)) {
      rawForecastData.value = Map<String, dynamic>.from(_rawDataStorage[key]!);
    }
  }

  Map<String, dynamic> getCityForecastData(CityModel city) {
    final key = LocationUtilsService.fromCityModel(city);
    return _rawDataStorage[key] ?? {};
  }

  String get selectedCityName => selectedCity.value?.cityAscii ?? 'Loading...';
  bool get isAppReady => isDataLoaded.value;
  CityModel? get currentCity => currentLocationCity.value;
  CityModel? get chosenCity => selectedCity.value;
  bool get isFirstTime => isFirstLaunch.value;
  Map<String, dynamic> get rawWeatherData {
    final key = LocationUtilsService.fromCityModel(selectedCity.value!);
    return _rawDataStorage[key] ?? {};
  }
}
