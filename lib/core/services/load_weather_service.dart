import 'package:flutter/foundation.dart';
import '/core/common/app_exceptions.dart';
import '/data/models/city_model.dart';
import '/data/models/weather_model.dart';
import '/data/models/forecast_model.dart';
import '/domain/use_cases/use_case.dart';
import 'condition_service.dart';

class LoadWeatherService {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionService conditionService;

  LoadWeatherService({
    required this.getCurrentWeather,
    required this.conditionService,
  });

  Future<void> loadWeatherService(
    List<CityModel> cities, {
    CityModel? selectedCity,
    CityModel? currentLocationCity,
    int batchSize = 15,
  }) async {
    try {
      String? selectedCityName = selectedCity?.cityAscii;
      List<CityModel> citiesToFetch = List.from(cities);
      if (currentLocationCity != null) {
        final isCurrentLocationInCities = cities.any(
          (city) => city.cityAscii == currentLocationCity.cityAscii,
        );
        if (!isCurrentLocationInCities) {
          citiesToFetch.add(currentLocationCity);
        }
      }

      await _loadWeatherInBatches(citiesToFetch, batchSize, selectedCityName);
    } catch (e) {
      debugPrint('${AppExceptions().failToLoadWeather}: $e');
      conditionService.allCitiesWeather.clear();
    }
  }

  Future<void> _loadWeatherInBatches(
    List<CityModel> cities,
    int batchSize,
    String? selectedCityName,
  ) async {
    for (int i = 0; i < cities.length; i += batchSize) {
      final batch = cities.skip(i).take(batchSize).toList();

      final List<Future<_WeatherResult>> batchFutures = batch.map((city) {
        return _fetchWeatherForCity(city);
      }).toList();

      final List<_WeatherResult> batchResults = await Future.wait(
        batchFutures,
        eagerError: false,
      );

      for (final result in batchResults) {
        if (result.isSuccess) {
          conditionService.allCitiesWeather[result.city.cityAscii] =
              result.weather!;

          if (selectedCityName != null &&
              result.city.cityAscii == selectedCityName) {
            conditionService.updateWeatherData(
              [result.weather!],
              0,
              result.city.cityAscii,
            );
            conditionService.updateWeeklyForecast(result.forecast!);
          }
        } else {
          debugPrint(
            'Failed to load weather for ${result.city.cityAscii}: ${result.error}',
          );
        }
      }

      if (i + batchSize < cities.length) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  Future<_WeatherResult> _fetchWeatherForCity(CityModel city) async {
    try {
      final (weather, forecast) = await getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );
      return _WeatherResult.success(city, weather, forecast);
    } catch (e) {
      return _WeatherResult.failure(city, e.toString());
    }
  }
}

class _WeatherResult {
  final CityModel city;
  final WeatherModel? weather;
  final List<ForecastModel>? forecast;
  final String? error;
  final bool isSuccess;

  _WeatherResult._({
    required this.city,
    this.weather,
    this.forecast,
    this.error,
    required this.isSuccess,
  });

  factory _WeatherResult.success(
    CityModel city,
    WeatherModel weather,
    List<ForecastModel> forecast,
  ) {
    return _WeatherResult._(
      city: city,
      weather: weather,
      forecast: forecast,
      isSuccess: true,
    );
  }

  factory _WeatherResult.failure(CityModel city, String error) {
    return _WeatherResult._(city: city, error: error, isSuccess: false);
  }
}
