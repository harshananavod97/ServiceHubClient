// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lottie/lottie.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewAdrressScreen extends StatefulWidget {
  const AddNewAdrressScreen({super.key});

  @override
  _AddNewAdrressScreenState createState() => _AddNewAdrressScreenState();
}

class _AddNewAdrressScreenState extends State<AddNewAdrressScreen> {


  //Address Veribales (Home Office Others)
  String haddressType = '', haddress1 = '', haddress2 = '', hcity = '';
  String ofaddressType = '', ofaddress1 = '', ofaddress2 = '', ofcity = '';
  String oaddressType = '', oaddress1 = '', oaddress2 = '', ocity = '';

  TextEditingController addressTypecontrller = TextEditingController();
  TextEditingController address1contrller = TextEditingController();
  TextEditingController address2contrller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  TextEditingController ofaddressTypecontroller = TextEditingController();
  TextEditingController ingcontroller = TextEditingController();
  TextEditingController latcontroller = TextEditingController();
  Apicontroller apicontroller = Apicontroller();

  String addressType = 'home';
  int selectedIndex = 0;
  String address1 = '';
  String address2 = '';
  String city = '';

  double latitude = 0.0;
  double logitude = 0.0;
  String id = '';
  String googleApikey = "AIzaSyCiBivWTYU4Vc6PnlOQXGJBHOcpPNiFLmA";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(7.8731, 80.7718);
  String location = "Search Location";
  Position? currentPosition; // Add this line


//Get Id
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    id = ids.getString("id").toString();
    print("my id :" + id);
  }

  @override
  void initState() {
    super.initState();
    // Get the user's current location continuously
    Geolocator.getPositionStream().listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                GoogleMap(
                  //Map widget from google_maps_flutter package
                  //zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: LatLng(
                      currentPosition?.latitude ?? 6.927079,
                      currentPosition?.longitude ?? 79.861244,
                    ), //initial position
                    zoom: 14.0, //initial zoom level
                  ),

                  mapType: MapType.normal, //map type
                  onMapCreated: (controller) {
                    //method called when map is created
                    setState(() {
                      mapController = controller;
                    });
                  },
                  onCameraMove: (CameraPosition cameraPositiona) {
                    cameraPosition = cameraPositiona;
                  },
                  onCameraIdle: () async {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        cameraPosition!.target.latitude,
                        cameraPosition!.target.longitude);
                    setState(() {
                      // ignore: prefer_interpolation_to_compose_strings
                      location = placemarks.first.administrativeArea
                              .toString() +
                          ", " +
                          placemarks.first.street.toString() +
                          "," +
                          placemarks.first.subAdministrativeArea.toString() +
                          "" +
                          placemarks.first.country.toString();

                      city = placemarks.first.administrativeArea.toString();
                      address1 = placemarks.first.street.toString();
                      address2 =
                          placemarks.first.subAdministrativeArea.toString();
                      latitude = cameraPosition!.target.latitude;
                      logitude = cameraPosition!.target.longitude;
                    });
                  },
                ),

                Center(
                  //picker image on google map
                  child: Container(
                    width: 150,
                    child: Lottie.asset("assets/pin.json"),
                  ),
                ),

                //search autoconplete input
                Positioned(
                  //search input bar
                  top: 20,
                  child: InkWell(
                    onTap: () async {
                      var place = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: googleApikey,
                          mode: Mode.overlay,
                          types: [],
                          strictbounds: false,
                          //google_map_webservice package
                          onError: (err) {
                            print(err);
                          });

                      if (place != null) {
                        setState(() {
                          location = place.description.toString();
                        });
                        //form google_maps_webservice package
                        final plist = GoogleMapsPlaces(
                          apiKey: googleApikey,
                          apiHeaders: await GoogleApiHeaders().getHeaders(),
                          //from google_api_headers package
                        );
                        String placeid = place.placeId ?? "0";
                        final detail = await plist.getDetailsByPlaceId(placeid);
                        final geometry = detail.result.geometry!;
                        final lat = geometry.location.lat;
                        final lang = geometry.location.lng;

                        var newlatlang = LatLng(lat, lang);

                        //move map camera to selected place with animation
                        mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: newlatlang, zoom: 17)));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            leading: Lottie.asset("assets/pin.json"),
                            title: Text(
                              location,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Select Address Type',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 25.0,
                      color: darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            addressType = 'Home';
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectedIndex == 0
                                  ? darkText
                                  : const Color(0xFFFDF8F8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 19),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                color: selectedIndex == 0 ? white : darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                            addressType = 'Office';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectedIndex == 1
                                  ? darkText
                                  : const Color(0xFFFDF8F8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 19),
                            child: Text(
                              'Office',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                color: selectedIndex == 1 ? white : darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            addressType = 'Other';
                            selectedIndex = 2;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectedIndex == 2
                                  ? darkText
                                  : const Color(0xFFFDF8F8),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 19),
                            child: Text(
                              'Other',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                color: selectedIndex == 2 ? white : darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Column(
                      children: [
                        Text(
                          address1,
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20.0,
                            color: selectedIndex == 4 ? white : darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          address2,
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20.0,
                            color: selectedIndex == 4 ? white : darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          city,
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20.0,
                            color: selectedIndex == 4 ? white : darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RoundedButton(
                      buttonText: 'Save Address',
                      onPress: () {
                        print(id);
                        setState(() async {
                          if (selectedIndex == 0) {
                            setState(() async {
                              address1contrller.text = address1;
                              address2contrller.text = address2;
                              addressTypecontrller.text = 'home';
                              citycontroller.text = city;
                              ingcontroller.text = logitude.toString();
                              latcontroller.text = latitude.toString();
                              apicontroller.CreaterCustomeraddressId(
                                id,
                                addressType.toString(),
                                address1contrller.text,
                                address2contrller.text,
                                citycontroller.text,
                                ingcontroller.text,
                                latcontroller.text,
                                context,
                              );
                            });
                          } else if (selectedIndex == 1) {
                            setState(() async {
                              address1contrller.text = address1;
                              address2contrller.text = address2;
                              addressTypecontrller.text = 'office';
                              citycontroller.text = city;
                              ingcontroller.text = logitude.toString();
                              latcontroller.text = latitude.toString();

                              apicontroller.CreaterCustomeraddressId(
                                  id,
                                  addressType.toString(),
                                  address1contrller.text,
                                  address2contrller.text,
                                  citycontroller.text,
                                  ingcontroller.text,
                                  latcontroller.text,
                                  context);
                            });
                          } else if (selectedIndex == 2) {
                            setState(() async {
                              address1contrller.text = address1;
                              address2contrller.text = address2;
                              addressTypecontrller.text = 'other';
                              citycontroller.text = city;
                              ingcontroller.text = logitude.toString();
                              latcontroller.text = latitude.toString();

                              apicontroller.CreaterCustomeraddressId(
                                  id,
                                  addressType.toString(),
                                  address1contrller.text,
                                  address2contrller.text,
                                  citycontroller.text,
                                  ingcontroller.text,
                                  latcontroller.text,
                                  context);
                            });
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
