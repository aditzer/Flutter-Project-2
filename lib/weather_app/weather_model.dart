class WeatherInfo {
  final String description;
  final String icon;
  WeatherInfo({required this.description, required this.icon});
  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}
class TempInfo {
  final String temp;
  final String pressure, humidity;
  TempInfo(
      {required this.temp, required this.pressure, required this.humidity});
  factory TempInfo.fromJson(Map<String, dynamic> json) {
    final temp = "${json['temp']}°C";
    final pressure = "${json['pressure']} hPa";
    final humidity = "${json['humidity']}%";
    return TempInfo(temp: temp, pressure: pressure, humidity: humidity);
  }
}

class WeatherResponse {
  final String cityName;
  final String countryName;
  final TempInfo tempInfo;
  final WeatherInfo weatherInfo;
  final String code;
  final String timeOfDay;
  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${weatherInfo.icon}@2x.png';
  }

  WeatherResponse(
      {required this.cityName,
      required this.countryName,
      required this.tempInfo,
      required this.weatherInfo,
      required this.code,
        required this.timeOfDay});
  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    if(json['cod']=="404"){
      return WeatherResponse(
          cityName: "",
          tempInfo: TempInfo(temp: "", pressure: "", humidity: ""),
          weatherInfo: WeatherInfo(description: "", icon: "01n"),
          countryName: "",
          code: "404",
          timeOfDay: "default_pic");
    }
    final cityName = json['name'];
    final countryName = json['sys']['country'];
    final code = json['cod'].toString();

    final tempInfoJson = json['main'];
    final tempInfo = TempInfo.fromJson(tempInfoJson);

    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

    var timeOfDay="";
    int timezone=json["timezone"];
    var utce=DateTime.now().toUtc().millisecondsSinceEpoch;
    var curr=DateTime.fromMillisecondsSinceEpoch(utce+timezone*1000,isUtc:true);
    if(curr.hour>=5 && curr.hour<=15){
      timeOfDay="Morning";
    }
    else{
      timeOfDay="Evening";
    }
    return WeatherResponse(
        cityName: cityName,
        tempInfo: tempInfo,
        weatherInfo: weatherInfo,
        countryName: countryName,
        code: code,
        timeOfDay: timeOfDay);
  }
}
