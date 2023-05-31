import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/model/pastappoiments.dart';
import 'package:servicehub_client/model/providerDetails.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class RatingScreen extends StatefulWidget {
  const RatingScreen(
      {super.key, required this.index, required this.serviceindex});
  final int index;
  final serviceindex;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  AutovalidateMode switched = AutovalidateMode.disabled;
  final _comment = GlobalKey<FormState>();

  final commentControlleer = TextEditingController();
  final commentFocusNode = FocusNode();

  var rating = 0.0;
  List<PastApoinmentList> pastapoinmentlist = [];
  Future<List<PastApoinmentList>> getPastApoiment(String id) async {
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "customer-past-appointments?id=$id");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('load sucess');

      final appontment = pastApoinmentListFromJson(response.body);

      print("appointment " + appontment.length.toString());

      pastapoinmentlist.addAll(appontment);
      print(response.body);

      return pastapoinmentlist;
    } else {
      return pastapoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  String customerid = "";
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? customerid = ids.getString("id").toString()
          : customerid = idss.getString("id").toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getPastApoiment(customerid);
  }

  Apicontroller apicontroller = Apicontroller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          //leadingWidth: 30,
          titleSpacing: 0,
          backgroundColor: white,
          foregroundColor: Colors.black,
          leading: Padding(
            padding: const EdgeInsets.only(left: 22),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: const Text('Back'),
        ),
        body: FutureBuilder(
            future: getPastApoiment(customerid),
            builder:
                (context, AsyncSnapshot<List<PastApoinmentList>> snapshot) {
              // render the UI when data is available
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Your Rating',
                        style: screenTitle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      snapshot.hasData && snapshot.data!.isNotEmpty
                          ? widget.index >= 0 &&
                                  widget.index < snapshot.data!.length
                              ? Center(
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: ClipOval(
                                      child: snapshot
                                                  .data![widget.index]
                                                  .serviceProvider
                                                  ?.profilePic ==
                                              null
                                          ? Center(child: Text('No Image'))
                                          : Image.network(
                                              'https://servicehub.clickytesting.xyz/' +
                                                  snapshot
                                                      .data![widget.index]
                                                      .serviceProvider!
                                                      .profilePic
                                                      .toString(),
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
                      SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: SmoothStarRating(
                            allowHalfRating: false,
                            onRatingChanged: (v) {
                              setState(() {
                                rating = v;
                              });
                            },
                            starCount: 5,
                            rating: rating,
                            size: 30.0,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.blur_on,
                            color: Colors.red,
                            borderColor: darkText,
                            spacing: 0.0),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _comment,
                        autovalidateMode: switched,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Comment is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: 3,
                          controller: commentControlleer,
                          focusNode: commentFocusNode,
                          style: const TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 20,
                              color: lightText),
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter Your Comment...',
                            fillColor: inputFieldBackgroundColor,
                            contentPadding: EdgeInsets.all(12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      RoundedButton(
                        buttonText: 'Confirm',
                        onPress: () {
                          setState(() {
                            switched = AutovalidateMode.always;

                            if (_comment.currentState!.validate()) {
                              apicontroller.Jobrating(
                                snapshot
                                    .data![widget.index].jobPayment.customerId
                                    .toString(),
                                snapshot.data![widget.index].jobPayment.jobId
                                    .toString(),
                                snapshot.data![widget.index].serviceProvider.id
                                    .toString(),
                                rating.toString(),
                                commentControlleer.text,
                                context,
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
