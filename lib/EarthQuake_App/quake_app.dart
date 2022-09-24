import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_2/EarthQuake_App/model/quake_data_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'network/network.dart';

class EarthQuake_App extends StatefulWidget {
  const EarthQuake_App({Key? key}) : super(key: key);

  @override
  State<EarthQuake_App> createState() => _EarthQuake_AppState();
}

class _EarthQuake_AppState extends State<EarthQuake_App> {
  late Future<Quake> _quakeData;
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markerList = <Marker>[];
  double zoomVal = 0.5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quakeData = Network().getAllQuakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Earthquake App"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMaps(),
          _zoomMinus(),
          _zoomPlus(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 90, bottom: 20),
        width: 200,
        height: 50,
        //decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.grey,),
        child: FloatingActionButton(
          isExtended: true,
          onPressed: () => _findQuakes(),
          elevation: 8.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Container(
            width: 200,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.green,
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight
                ),
            ),
            child: const Text(
              "Search Earthquakes",
              style: TextStyle(color: Colors.white,fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _zoomPlus() {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.magnifyingGlassPlus,
                color: Colors.black87,
              ),
              onPressed: () {
                zoomVal++;
                _plus(zoomVal);
              }),
        ));
  }

  Widget _zoomMinus() {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.magnifyingGlassMinus,
                color: Colors.black87,
              ),
              onPressed: () {
                zoomVal--;
                _minus(zoomVal);
              }),
        ));
  }

  Widget _buildGoogleMaps() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            const CameraPosition(target: LatLng(36.1083333, -117.8608333), zoom: 3),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_markerList),
      ),
    );
  }

  void _findQuakes() {
    setState(() {
      _markerList.clear();
      _handelResponse();
    });
  }

  void _handelResponse() {
    setState(() {
      _quakeData.then((quake) => {
            quake.features?.forEach((quake) => {
                  _markerList.add(Marker(
                    markerId: MarkerId(quake.id.toString()),
                    infoWindow: InfoWindow(
                        title: quake.properties?.mag.toString(),
                        snippet: quake.properties?.title),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueMagenta),
                    position: LatLng(quake.geometry!.coordinates![1],
                        quake.geometry!.coordinates![0]),
                    onTap: () {},
                  ))
                })
          });
    });
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }
}
