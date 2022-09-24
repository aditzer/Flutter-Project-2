import 'dart:convert';
import '../model/quake_data_model.dart';
import 'package:http/http.dart' as http;

class Network{
  Future<Quake> getAllQuakes() async{
    var Url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";
    var uri=Uri.parse(Url);
    final response=await http.get(uri);
    if(response.statusCode == 200){
      //print(response.body);
      return Quake.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Error getting data");
    }
  }
}