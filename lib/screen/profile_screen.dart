import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/model/AddressList.dart';
import 'package:servicehub_client/screen/add_new_address.dart';
import 'package:servicehub_client/screen/adress_update_page.dart';

import 'package:servicehub_client/screen/verification_screen.dart';
import 'package:servicehub_client/utils/Custom_Text.dart';
import 'package:servicehub_client/utils/Navigation_Function.dart';
import 'package:servicehub_client/utils/constant.dart';

import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import '../provider/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

//Creating a list to store input data;

class _ProfileScreenState extends State<ProfileScreen> {
  int maxlenth = 10;
  final _fullnameformKey = GlobalKey<FormState>();
  final _emailformKey = GlobalKey<FormState>();
  final _phnnumberformkey = GlobalKey<FormState>();
  final CarouselController _controller = CarouselController();
  int _current = 0;
  Color btn1 = darkText;
  Color btn2 = white;
  Color btn3 = white;
  bool _readonly = true;

  bool onupdate = false;
  bool _isButtonOn = true;
  // ignore: non_constant_identifier_names
  String address_type = '';
  String address_1 = "";
  String address_2 = "You Can Add Adrress ";
  String city = "Using Button";
  String ing = '110';
  String lat = '45';
  String customerid = '';
  TextEditingController idcontroller = TextEditingController();

  TextEditingController haddress1contrller = TextEditingController();
  TextEditingController haddress2contrller = TextEditingController();
  TextEditingController hcitycontroller = TextEditingController();

  TextEditingController ofaddress1contrller = TextEditingController();
  TextEditingController ofaddress2contrller = TextEditingController();
  TextEditingController ofcitycontroller = TextEditingController();

  TextEditingController otaddress1contrller = TextEditingController();
  TextEditingController otaddress2contrller = TextEditingController();
  TextEditingController otcitycontroller = TextEditingController();

  List<AddressList> addresslists = [];

  Future<List<AddressList>> GetCustomerAddressList(String customerid) async {
    print(customerid);
    final addressload = await SharedPreferences.getInstance();
    addresslists.clear();
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "customer-address-list?customer_id=$customerid");
    final response = await http.get(url);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final address = addressListFromJson(response.body);

      addresslists.addAll(address);
      print(response.body);
      setState(() {
        for (int i = 0; i < data.length; i++) {
          if (data[i]['address_type'].toString() == "Home") {
            addressload.setString(
                'homeaddress1', data[i]['address_1'].toString());
            addressload.setString(
                'homeaddress2', data[i]['address_2'].toString());
            addressload.setString('homecity', data[i]['city'].toString());
//  await addressload.setDouble(
//                                   'homelatitude', latitude);
//                               await addressload.setDouble(
//                                   'homelogitude', logitude);
          } else if (data[i]['address_type'].toString() == "Other") {
            addressload.setString(
                'otheraddress1', data[i]['address_1'].toString());
            addressload.setString(
                'otheraddress2', data[i]['address_2'].toString());
            addressload.setString('othercity', data[i]['city'].toString());
          } else {
            addressload.setString(
                'officeaddress1', data[i]['address_1'].toString());
            addressload.setString(
                'officeaddress2', data[i]['address_2'].toString());
            addressload.setString('officecity', data[i]['city'].toString());
          }
        }
        setState(() {
          if (addressload != null &&
              addressload.getString('homeaddress1') != null) {
            homeaddress1 = addressload.getString('homeaddress1').toString();
          } else {
            officeaddress1 = " ";
          }

          if (addressload != null &&
              addressload.getString('homeaddress2') != null) {
            homeaddress2 = addressload.getString('homeaddress2').toString();
          } else {
            homeaddress2 = "Add Your Home Address Here...";
          }

          if (addressload != null &&
              addressload.getString('homecity') != null) {
            homecity = addressload.getString('homecity').toString();
          } else {
            homecity = "";
          }

          // homelatitude = addressload.getDouble('homelatitude').toString();
          // homelogitude = addressload.getDouble('homelogitude').toString();

          if (addressload != null &&
              addressload.getString('officeaddress1') != null) {
            officeaddress1 = addressload.getString('officeaddress1').toString();
          } else {
            officeaddress1 = "";
          }
          if (addressload != null &&
              addressload.getString('officeaddress2') != null) {
            officeaddress2 = addressload.getString('officeaddress2').toString();
          } else {
            officeaddress2 = "Add Your Office Address Here...";
          }
          if (addressload != null &&
              addressload.getString('officecity') != null) {
            officecity = addressload.getString('officecity').toString();
          } else {
            officecity = " ";
          }

          // oficelogitude = addressload.getDouble('officelogitude').toString();
          //officelatitude = addressload.getDouble('officelatitude').toString();

          if (addressload != null &&
              addressload.getString('otheraddress1') != null) {
            otheraddress1 = addressload.getString('otheraddress1').toString();
          } else {
            otheraddress1 = "";
          }
          if (addressload != null &&
              addressload.getString('otheraddress2') != null) {
            otheraddress2 = addressload.getString('otheraddress2').toString();
          } else {
            otheraddress2 = "Add Your Other Address Here...";
          }
          if (addressload != null &&
              addressload.getString('othercity') != null) {
            othercity = addressload.getString('othercity').toString();
          } else {
            othercity = "";
          }

          //     : "";
          // otherlogitude = addressload.getDouble('otherlogitude').toString();
          // otherlatitude = addressload.getDouble('otherlatitude').toString();
        });
      });

      return addresslists;
    } else {
      return addresslists;

      throw Exception('Failed to load data');
    }
  }

  String homeaddress1 = ' ',
      homeaddress2 = '',
      homecity = '',
      homelatitude = '',
      homelogitude = '';
  String officeaddress1 = '',
      officeaddress2 = '',
      officecity = '',
      officelatitude = '',
      oficelogitude = '';
  String otheraddress1 = '',
      otheraddress2 = '',
      othercity = '',
      otherlatitude = '',
      otherlogitude = '';
  Apicontroller apicontroller = Apicontroller();

  final fullNameControlleer = TextEditingController();
  final phoneNumberControlleer = TextEditingController();
  final emailControlleer = TextEditingController();

  final addressControlleer = TextEditingController();

  final fullNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final addressFocusNode = FocusNode();

  bool homeswitch = true;
  bool officeswitch = true;
  bool otherswitch = true;
  bool elog = true;
  // ignore: non_constant_identifier_names
  String phone_number = '';

  String newemail = '';
  int itemindex = 1;
  String id = "";
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    ids.getString("id").toString().isNotEmpty
        ? customerid = ids.getString("id").toString()
        : customerid = idss.getString("id").toString();

    GetCustomerAddressList(customerid.toString());
    idcontroller.text = ids.getString("id").toString();
  }

  @override
  void initState() {
    print("init state called");
    getUserData();

    getcustomerdata();

    super.initState();
  }

  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();
    setState(() {
      print(customerdetails.getString('full_name').toString());
      customerdetails != null && customerdetails.getString('full_name') != null
          ? fullNameControlleer.text =
              customerdetails.getString('full_name').toString()
          : fullNameControlleer.text = "Full name";

      customerdetails != null && customerdetails.getString('email') != null
          ? emailControlleer.text =
              customerdetails.getString('email').toString()
          : emailControlleer.text =
              customerdetails.getString('email').toString();

      phoneNumberControlleer.text =
          customerdetails.getString('phone_number').toString();
    });
  }

  void _toggleButton() {
    setState(() {
      _isButtonOn = !_isButtonOn;
    });
  }

//customer detais readonly method
  void readonly() {
    setState(() {
      _readonly = !_readonly;
    });
  }

  void dispose() {
    super.dispose();
    fullNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    fullNameControlleer.dispose();
    phoneNumberControlleer.dispose();
    emailControlleer.dispose();
    addressControlleer.dispose();
    addressFocusNode.dispose();
  }

  @override
  build(BuildContext context) {
    //customer detais save and edit button changing method
    List<Widget> list = [
      SliderItem(
        visibleicon:
            homeaddress2 == "Add Your Home Address Here..." ? true : false,
        address1: homeaddress1,
        address2: homeaddress2,
        city: homecity,
        addresstype: 'Home',
        onpress: () => NavigationUtillfunction.navigateTo(
            context,
            UpdateAdress(
              Latitude: homelatitude,
              longitude: homelogitude,
              addressType: 'home',
            )),
      ),
      SliderItem(
        visibleicon:
            officeaddress2 == "Add Your Office Address Here..." ? true : false,
        address1: officeaddress1,
        address2: officeaddress2,
        city: officecity,
        addresstype: 'Office',
        onpress: () => NavigationUtillfunction.navigateTo(
            context,
            UpdateAdress(
              Latitude: officelatitude,
              longitude: oficelogitude,
              addressType: 'office',
            )),
      ),
      SliderItem(
        visibleicon:
            otheraddress2 == "Add Your Other Address Here..." ? true : false,
        address1: otheraddress1,
        address2: otheraddress2,
        city: othercity,
        addresstype: 'Other',
        onpress: () => NavigationUtillfunction.navigateTo(
            context,
            UpdateAdress(
              Latitude: otherlatitude,
              longitude: otherlogitude,
              addressType: 'other',
            )),
      ),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          child: Consumer<AuthProvider>(
            builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Profile',
                  style: screenTitle,
                ),
                const SizedBox(
                  height: 10,
                ),

                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputField('Full Name', fullNameControlleer,
                        TextInputType.text, fullNameFocusNode, _readonly),
                    Form(
                      key: _fullnameformKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        readOnly: _readonly,
                        controller: fullNameControlleer,
                        keyboardType: TextInputType.text,
                        focusNode: fullNameFocusNode,
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                          color: lightText,
                        ),
                        decoration: formInputStyle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                            return 'Full name can only contain letters and spaces';
                          }
                          if (value.length > 255) {
                            return 'Full name cannot exceed 255 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    inputField('Phone Number', phoneNumberControlleer,
                        TextInputType.text, phoneNumberFocusNode, _readonly),
                    Form(
                      key: _phnnumberformkey,
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        maxLength: maxlenth,
                        readOnly: _readonly,
                        controller: phoneNumberControlleer,
                        keyboardType: TextInputType.phone,
                        focusNode: phoneNumberFocusNode,
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                          color: lightText,
                        ),
                        decoration: formInputStyle,
                        validator: (value) {
                          if (phoneNumberControlleer.text == "phone number") {
                            return null;
                          } else {
                            if (value == null || value.isEmpty) {
                              return 'Phone number is required';
                            }
                            if (value.length != 10) {
                              return 'Phone number must have 10 digits';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'Invalid phone number';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    inputField('Email', emailControlleer,
                        TextInputType.emailAddress, emailFocusNode, _readonly),
                    Form(
                      key: _emailformKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        readOnly: _readonly,
                        controller: emailControlleer,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: emailFocusNode,
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                          color: lightText,
                        ),
                        decoration: formInputStyle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email address';
                          }
                          if (value.length > 255) {
                            return 'Email name cannot exceed 255 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                _isButtonOn
                    ? RoundedButton(
                        buttonText: 'Edit Profile',
                        onPress: () {
                          print("edit button");
                          readonly();
                          _toggleButton();
                        },
                      )
                    : RoundedButton(
                        buttonText: 'Save',
                        onPress: () {
                          setState(() async {
                            final customerdetails =
                                await SharedPreferences.getInstance();

                            if (_emailformKey.currentState!.validate() &&
                                _fullnameformKey.currentState!.validate() &&
                                _emailformKey.currentState!.validate()) {
                              if (customerdetails
                                      .getString('phone_number')
                                      .toString() ==
                                  phoneNumberControlleer.text) {
                                apicontroller.updateCustomeId(
                                    customerid.toString(),
                                    fullNameControlleer.text,
                                    emailControlleer.text,
                                    phoneNumberControlleer.text);
                                apicontroller.getcustomerdetails(
                                    customerid.toString(), context);
                              } else {
                                setState(() async {
                                  await apicontroller.updateCustomeId(
                                      customerid.toString(),
                                      fullNameControlleer.text,
                                      emailControlleer.text,
                                      phoneNumberControlleer.text);

                                  await apicontroller.otpgenarate(
                                      phoneNumberControlleer.text, context);

                                  NavigationUtillfunction.navigateTo(
                                      context,
                                      await VerificationScreen(
                                        userId: customerid.toString(),
                                        PhoneNumber:
                                            phoneNumberControlleer.text,
                                      ));
                                });
                                apicontroller.getcustomerdetails(
                                    customerid.toString(), context);
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Profile Updated Successfully"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Center(child: const Text('OK')),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                              readonly();
                              _toggleButton();
                            }
                          });
                        }),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'My Addresses',
                  style: screenTitle,
                ),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 10,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    height: 200.0,
                  ),
                  items: list.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: inputFieldBackgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SingleChildScrollView(
                              child: Column(children: [i]),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: list.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : darkText)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 15,
                ),
                RoundedButton(
                  buttonText: 'Add New Address',
                  onPress: () {
                    print("my id" + customerid);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddNewAdrressScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(String labelName, TextEditingController controller,
      TextInputType inputType, FocusNode focusNode, bool off) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: labelText,
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget adrressField(TextEditingController controller, bool off) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            readOnly: off,
            controller: controller,
            keyboardType: TextInputType.none,
            style: const TextStyle(
                fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
            decoration: formInputStyle),
      ],
    );
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(email);
  }

//phone number validation function
  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r"^\d{10}$");
    return regex.hasMatch(phoneNumber);
  }
}

class SliderItem extends StatelessWidget {
  const SliderItem(
      {super.key,
      required this.address1,
      required this.address2,
      required this.city,
      required this.addresstype,
      required this.onpress,
      required this.visibleicon});

  final String address1;
  final String address2;
  final String city;
  final String addresstype;
  final VoidCallback onpress;
  final bool visibleicon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: addresstype,
                  color: lightText,
                  fontfamily: 'Segoe UI',
                  fontweight: FontWeight.w900,
                  size: 20),
              visibleicon
                  ? Container()
                  : IconButton(
                      onPressed: onpress,
                      icon: const Icon(Icons.edit),
                      color: darkText,
                    )
            ],
          ),
          const SizedBox(
            width: 80,
          ),
          CustomText(
              text: address1,
              color: lightText,
              fontfamily: 'Segoe UI',
              fontweight: FontWeight.normal,
              size: 20),
          CustomText(
              text: address2,
              color: lightText,
              fontfamily: 'Segoe UI',
              fontweight: FontWeight.normal,
              size: 20),
          CustomText(
              text: city,
              color: lightText,
              fontfamily: 'Segoe UI',
              fontweight: FontWeight.normal,
              size: 20),
        ],
      ),
    );
  }

  //email validation function
}

class DetailsList {
  String full_name, email, phone_number;

  DetailsList({
    required this.full_name,
    required this.email,
    required this.phone_number,
  });
}
