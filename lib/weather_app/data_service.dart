import 'dart:convert';

import 'package:flutter_project_2/weather_app/weather_model.dart';
import 'package:http/http.dart' as http;
class DataService{
  Future<WeatherResponse> getWeather(String city) async{
    final queryParams={
      "q":city,
      'appid': '98e8dfcf4ea2319b693eb4c58b2a6018',
      'units': 'metric'
    };
    final uri=Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParams);
    final response=await http.get(uri);
    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}