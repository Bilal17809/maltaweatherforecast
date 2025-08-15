import '/data/models/forecast_model.dart';
import '/data/models/weather_model.dart';

abstract class WeatherRepo {
  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast(
    double lat,
    double lon,
  );
  Future<(String city, String region)> getCityAndRegion(double lat, double lon);
}
