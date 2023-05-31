import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/utils/constant.dart';

class MultiplePointsOfMap extends StatefulWidget {
  @override
  _MultiplePointsOfMapState createState() => _MultiplePointsOfMapState();
}

class _MultiplePointsOfMapState extends State<MultiplePointsOfMap> {
  GoogleMapController? mapController;
  LatLng showLocation = LatLng(7.8731, 80.7718);
  List<Marker> _marker = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(constant.APPEND_URL +
        'provider-location')); //replace with your API endpoint
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      for (var item in data) {
        final double? lat =
            item['lat'] != null ? double.parse(item['lat']) : null;
        final double? lng =
            item['ing'] != null ? double.parse(item['ing']) : null;
        final LatLng position = LatLng(lat ?? 0, lng ?? 0);
        final String title = item['name'];
        final String snippet = item['name'];
        final Marker marker = Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: snippet,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
        _marker.add(marker);
      }
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Providers Locations"),
          centerTitle: true,
          backgroundColor: kPrimary,
        ),
        body: GoogleMap(
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: showLocation,
            zoom: 08.0,
          ),
          markers: Set<Marker>.of(_marker),
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }
}
