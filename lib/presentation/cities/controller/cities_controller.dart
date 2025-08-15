import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/presentation/home/controller/home_controller.dart';
import '/core/mixins/connectivity_mixin.dart';
import '/core/services/services.dart';
import '/core/platform_channels/android_widget_channel.dart';
import '/data/models/city_model.dart';
import '/presentation/splash/controller/splash_controller.dart';

class CitiesController extends GetxController with ConnectivityMixin {
  final splashController = Get.find<SplashController>();
  final conditionService = Get.find<ConditionService>();
  final homeController = Get.find<HomeController>();

  var hasSearchError = false.obs;
  var searchErrorMessage = ''.obs;
  var isSearching = false.obs;
  var filteredCities = <CityModel>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    _syncSplash();
  }

  Future<void> _syncSplash() async {
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    filteredCities.value = splashController.allCities;
    _reorderCities();
    searchController.addListener(() {
      searchCities(searchController.text);
    });
  }

  void searchCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = splashController.allCities;
      _reorderCities();
      hasSearchError.value = false;
      return;
    }

    isSearching.value = true;
    hasSearchError.value = false;

    try {
      final results = splashController.allCities
          .where(
            (city) =>
                city.city.toLowerCase().contains(query.toLowerCase()) ||
                city.cityAscii.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      if (results.isEmpty) {
        hasSearchError.value = true;
        searchErrorMessage.value = 'No cities found matching "$query"';
        filteredCities.clear();
      } else {
        filteredCities.value = results;
        _reorderCities();
        hasSearchError.value = false;
      }

      filteredCities.assignAll(results);
    } catch (e) {
      hasSearchError.value = true;
      searchErrorMessage.value = 'Search failed. Please try again.';
      filteredCities.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> selectCity(CityModel city) async {
    await initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        splashController.selectedCity.value = city;
        await splashController.cityStorageService.saveSelectedCity(city);
        WidgetUpdateManager.updateWeatherWidget();
      },
    );
  }

  void _reorderCities() {
    final selectedCity = homeController.selectedCity.value;
    if (selectedCity != null) {
      filteredCities.sort((a, b) {
        if (a.cityAscii == selectedCity.cityAscii) return -1;
        if (b.cityAscii == selectedCity.cityAscii) return 1;
        return a.city.compareTo(b.city);
      });
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
