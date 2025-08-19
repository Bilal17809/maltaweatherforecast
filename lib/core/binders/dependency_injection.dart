import 'package:get/get.dart';
import '/ad_manager/ad_manager.dart';
import '/presentation/cities/controller/cities_controller.dart';
import '../config/client.dart';
import '../local_storage/local_storage.dart';
import '/domain/use_cases/use_case.dart';
import '/data/repo/weather_api_impl.dart';
import '/domain/repo/weather_repo.dart';
import '/data/data_source/online_data_sr.dart';
import '../services/services.dart';
import '/presentation/daily_forecast/controller/daily_forecast_controller.dart';
import '/presentation/home/controller/home_controller.dart';
import '/presentation/splash/controller/splash_controller.dart';

class DependencyInjection {
  static void init() {
    /// Core services
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);
    Get.lazyPut<OnlineDataSource>(() => OnlineDataSource(apiKey), fenix: true);
    Get.lazyPut<WeatherRepo>(
      () => WeatherApiImpl(Get.find<OnlineDataSource>()),
      fenix: true,
    );
    Get.lazyPut<GetWeatherAndForecast>(
      () => GetWeatherAndForecast(Get.find<WeatherRepo>()),
      fenix: true,
    );
    Get.putAsync<WeatherCodesLoader>(() async {
      final loader = WeatherCodesLoader();
      await loader.loadWeatherCodes();
      return loader;
    });

    /// Location and local storage
    Get.lazyPut<LocalStorage>(() => LocalStorage(), fenix: true);
    Get.lazyPut(
      () => CurrentLocationService(
        localStorage: Get.find(),
        getCurrentWeather: Get.find<GetWeatherAndForecast>(),
      ),
    );
    Get.lazyPut(() => CityStorageService(localStorage: Get.find()));

    /// Cities and weather loading service
    Get.lazyPut<LoadCitiesService>(() => LoadCitiesService());
    Get.lazyPut<LoadWeatherService>(
      () => LoadWeatherService(
        getCurrentWeather: Get.find(),
        conditionService: Get.find(),
      ),
    );

    /// Controllers
    Get.lazyPut(
      () => SplashController(
        getCurrentWeather: Get.find(),
        localStorage: Get.find(),
        currentLocationService: Get.find(),
        cityService: Get.find(),
        cityStorageService: Get.find(),
        loadWeatherService: Get.find(),
      ),
    );
    Get.lazyPut<ConditionService>(() => ConditionService(), fenix: true);
    Get.lazyPut<AutoScrollService>(() => AutoScrollService(), fenix: true);
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<GetWeatherAndForecast>()),
      fenix: true,
    );
    Get.lazyPut<DailyForecastController>(
      () => DailyForecastController(),
      fenix: true,
    );
    Get.lazyPut<CitiesController>(() => CitiesController(), fenix: true);

    /// Ads
    Get.lazyPut<SplashInterstitialManager>(
      () => SplashInterstitialManager(),
      fenix: true,
    );
    Get.lazyPut<InterstitialAdManager>(
      () => InterstitialAdManager(),
      fenix: true,
    );
    Get.lazyPut<BannerAdManager>(() => BannerAdManager(), fenix: true);
    Get.lazyPut<NativeAdManager>(() => NativeAdManager(), fenix: true);
  }
}
