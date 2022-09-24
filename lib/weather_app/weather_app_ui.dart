import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_2/weather_app/weather_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'data_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

class Weather_App_UI extends StatefulWidget {
  const Weather_App_UI({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Weather_App_UIState();
}

class _Weather_App_UIState extends State<Weather_App_UI> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();
  late int x = 0;
  late WeatherType w;
  WeatherResponse? _response;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",style: TextStyle(color: Colors.black),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0277bd), Colors.white],
            ),
          ),
        ),
      ),
      body: ListView(children: [
        Stack(children: [
          if (_response != null)
            WeatherBg(weatherType: w,width:MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height),
          if (_response == null)
            Container(
              margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.4),
              alignment: Alignment.center,
              child: const Text("Search a city name",style: TextStyle(fontSize: 30,color: Colors.grey),),
            ),
          if(_response?.code=="404")
            Container(
              margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.4),
              alignment: Alignment.center,
              child: const Text("Inavlid City Name",style: TextStyle(fontSize: 30,color: Colors.grey),),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: SearchBarAnimation(
                      buttonColour: Color(0xFF0277bd),
                      buttonIconColour: Colors.white,
                      isOriginalAnimation: true,
                      textEditingController: _cityTextController,
                      hintText: "Enter City Name",
                      buttonIcon: Icons.search,
                      onEditingComplete: () {
                        _search(_cityTextController.text);
                      },
                    ),
                  ),
                ),
                if (_response != null && _response?.code!="404")
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 5, top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber,
                        ),
                        child: Text(
                          "${_response!.cityName},  ${_response!.countryName}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                              colors: [Colors.lightBlueAccent, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter
                          ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: const Offset(4,4), // changes position of shadow
                              ),
                            ],
                        ),
                        child: Column(
                          children: [
                            if (_response!.code != "404")
                              Image.network(_response!.iconUrl),
                            Text(
                              _response!.tempInfo.temp,
                              style: const TextStyle(fontSize: 40),
                            ),
                            Text(_response!.weatherInfo.description),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 30, bottom: 20, left: 70, right: 70),
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                              colors: [Colors.lightBlueAccent, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(4,4),// changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: IconButton(
                                        icon: const FaIcon(FontAwesomeIcons.arrowDown),
                                        onPressed: () {}
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: IconButton(
                                        icon: const FaIcon(FontAwesomeIcons.droplet),
                                        onPressed: () {}
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 25),
                                    child: Text(
                                      "Pressure:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      "Humidity:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
                                    child: Text(
                                      _response!.tempInfo.pressure,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      _response!.tempInfo.humidity,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ])
      ]),
    );
  }

  void _search(String s) async {
    final response = await _dataService.getWeather(s);
    if (response.code == "404") {
      Fluttertoast.showToast(
          msg: "City Not Found!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    switch(response.weatherInfo.description){
      case "clear sky":
        if(response.timeOfDay=="Morning") {
          w=WeatherType.sunny;
        } else {
          w=WeatherType.sunnyNight;
        }
        break;
      case "few clouds":
        if(response.timeOfDay=="Morning") {
          w=WeatherType.cloudy;
        } else {
          w=WeatherType.cloudyNight;
        }
        break;
      case "scattered clouds":
        if(response.timeOfDay=="Morning") {
          w=WeatherType.cloudy;
        } else {
          w=WeatherType.cloudyNight;
        }
        break;
      case "overcast clouds":
        if(response.timeOfDay=="Morning") {
          w=WeatherType.cloudy;
        } else {
          w=WeatherType.cloudyNight;
        }
        break;
      case "broken clouds":
        if(response.timeOfDay=="Morning") {
          w=WeatherType.cloudy;
        } else {
          w=WeatherType.cloudyNight;
        }
        break;
      case "shower rain":
        w=WeatherType.lightRainy;
        break;
      case "rain":
        w=WeatherType.heavyRainy;
        break;
      case "thunderstorm":
        w=WeatherType.thunder;
        break;
      case "snow":
        w=WeatherType.middleSnow;
        break;
      case "mist":
        w=WeatherType.hazy;
        break;
      default:
        w=WeatherType.sunny;
        break;
    }
    setState(() => _response = response);
  }
}
