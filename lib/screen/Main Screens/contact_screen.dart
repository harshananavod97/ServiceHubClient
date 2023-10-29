import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {



  String googleApikey = "AIzaSyCiBivWTYU4Vc6PnlOQXGJBHOcpPNiFLmA";
  double latitude = 7.977079;
  double Longitude = 79.861244;
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;

  Position? currentPosition;
  final mapfocus = FocusNode();
  final fullNameControlleer = TextEditingController();

  
  //get map controller to access map
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //**********************email need to change *******************************************************************
    String email = "contact@ouiquit.com";

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

//mail send method
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,

      //subject also can be change of the mail ***************************************************
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );
// call make method
    Future<void> _makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: LatLng(
                      //lattitude and longi tude need to change ***************************************
                      currentPosition?.latitude ?? latitude,
                      currentPosition?.longitude ?? Longitude,
                    ), //initial position
                    zoom: 14.0, //initial zoom level
                  ),

                  mapType: MapType.normal, //map type
                ),
                Center(
                  //picker image on google map
                  child: Container(
                    width: 150,
                    child: Lottie.asset("assets/pin.json"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'We\'ve here',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 25.0,
                              color: darkText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Lorem ipsum, or lipsum as it is sometimes known, is ',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20.0,
                              color: darkText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.location_on_sharp,
                              color: white,
                            ),
                          )),
                      onTap: () async {
                        Position position =
                            await Geolocator.getCurrentPosition();

                        // Launch Google Maps with the destination location
                        String url =
                            'https://www.google.com/maps/dir/?api=1&destination=$latitude,$Longitude&travelmode=driving';
                        url = url.replaceFirst('latitude',
                            currentPosition?.latitude.toString() ?? '');
                        url = url.replaceFirst('longitude',
                            currentPosition?.longitude.toString() ?? '');
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Call us',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 25.0,
                              color: darkText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Lorem ipsum, or lipsum as',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20.0,
                              color: darkText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          //phone number have to change ****************************************************
                          _makePhoneCall('0773358545');
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.call,
                              color: white,
                            ),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Email us',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 25.0,
                              color: darkText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Lorem ipsum, or lipsum as',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20.0,
                              color: darkText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          launchUrl(emailLaunchUri);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.mail,
                              color: white,
                            ),
                          )),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
