import 'package:flutter/material.dart';

import '../Model/search_location.dart';
import '../Model/weather_api_helper.dart';
import '../Model/weather_model.dart';


class WeatherProvider extends ChangeNotifier {
  SearchLocation searchLocation = SearchLocation(
    location: "Surat",
    locationController: TextEditingController(),
  );

  searchWeather(String location) {
    searchLocation.location = location;
    notifyListeners();
  }

  Future<Weather?>? weatherData(String location) async {
    searchLocation.weather =
    (await APIHelper.apiHelper.fetchWeatherDetails(location));
    return searchLocation.weather;
  }
}