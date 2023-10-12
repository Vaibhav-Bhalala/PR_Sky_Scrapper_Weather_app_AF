import 'package:flutter/material.dart';
import 'package:pr_weather_app_af/Model/weather_model.dart';


class SearchLocation {
  String location;
  Weather? weather;
  TextEditingController locationController;

  SearchLocation({
    required this.location,
    this.weather,
    required this.locationController,
  });
}