// weather_provider.dart

import 'package:eighty7_api_task/model/WeatherModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eighty7_api_task/const.dart';

class WeatherProvider with ChangeNotifier {
  WeatherModel? _weatherData;

  WeatherModel? get weatherData => _weatherData;

  Future<void> fetchWeatherData(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikey'));

      if (response.statusCode == 200) {
        final jsonData = response.body;
        _weatherData = WeatherModel.fromJson(json.decode(jsonData));
        notifyListeners();
      } else {
        print("Failed to load weather data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
