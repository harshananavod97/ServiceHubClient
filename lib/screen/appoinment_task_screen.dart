import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/model/AddressList.dart';
import 'package:servicehub_client/screen/profile_screen.dart';
import 'package:servicehub_client/screen/task_confirmation_screen.dart';
import 'package:servicehub_client/styles.dart';
import 'package:servicehub_client/utils/Custom_Text.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../utils/Navigation_Function.dart';

// ignore: must_be_immutable
class AppoinmentTaskScreen extends StatefulWidget {
  AppoinmentTaskScreen({super.key, required this.serviceindex});
  String serviceindex;

  @override
  State<AppoinmentTaskScreen> createState() => _AppoinmentTaskScreenState();
}

class _AppoinmentTaskScreenState extends State<AppoinmentTaskScreen> {
  final _timeformKey = GlobalKey<FormState>();
  final _dateformKey = GlobalKey<FormState>();
  final _budgetformKey = GlobalKey<FormState>();

  final _additionalinformation = GlobalKey<FormState>();
  AutovalidateMode switched = AutovalidateMode.disabled;
  String customerid = '';
  String homeaddress1 = '', homeaddress2 = '', homecity = '';
  String officeaddress1 = '', officeaddress2 = '', officecity = '';
  String otheraddress1 = '', otheraddress2 = '', othercity = '';
  String selectaddressType = '', selectaddressId = '';
  String addressid = '';
  Color selectcolor = Colors.blue;
  Color unselectcolor = inputFieldBackgroundColor;
  Color unselectcolor1 = Colors.blue;
  Color unselectcolor2 = inputFieldBackgroundColor;
  Color unselectcolor3 = inputFieldBackgroundColor;
  Color selecttextcolor = Colors.white;
  Color unselecttextcolor = lightText;
  Color textcolor1 = Colors.white;
  Color textcolor2 = lightText;
  Color textcolor3 = lightText;

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

  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();
    ids.getString("id").toString().isNotEmpty
        ? customerid = ids.getString("id").toString()
        : customerid = idss.getString("id").toString();
    GetCustomerAddressList(customerid.toString());

    //await prefs.setBool('isLogged', false);
  }

  // ignore: non_constant_identifier_names
  GetAddressId(String customer_id, String address_type) async {
    var url = Uri.parse(constant.APPEND_URL +
        "customer-address-id?customer_id=$customer_id&address_type=$address_type");
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    setState(() {
      addressid = jsonResponse['Address ID'].toString();
    });

    print("addres id" + jsonResponse['Address ID'].toString());

    //Creating a list to store input data;
  }

  String addresstype = 'home';
  Apicontroller apicontroller = Apicontroller();
  final dateControlleer = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final budgetControlleer = TextEditingController();
  final locationControlleer = TextEditingController();
  final additionalInformationControlleer = TextEditingController();

  final dateFocusNode = FocusNode();
  final timeFocusNode = FocusNode();
  final budgetFocusNode = FocusNode();
  final locationFocusNode = FocusNode();
  final additionalInformationFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    dateControlleer.dispose();

    budgetControlleer.dispose();
    dateFocusNode.dispose();
    timeFocusNode.dispose();
    budgetFocusNode.dispose();
    additionalInformationFocusNode.dispose();
  }

  void selectAddress1() {
    setState(() {
      addresstype = "Home";
      unselectcolor1 = selectcolor;
      unselectcolor2 = unselectcolor;
      unselectcolor3 = unselectcolor;
      textcolor1 = selecttextcolor;
      textcolor2 = unselecttextcolor;
      textcolor3 = unselecttextcolor;
    });
  }

  void selectAddress2() {
    setState(() {
      addresstype = "Office";
      unselectcolor1 = unselectcolor;
      unselectcolor2 = selectcolor;
      unselectcolor3 = unselectcolor;
      textcolor1 = unselecttextcolor;
      textcolor2 = selecttextcolor;
      textcolor3 = unselecttextcolor;
    });
  }

  void selectAddress3() {
    setState(() {
      addresstype = "Other";
      unselectcolor1 = unselectcolor;
      unselectcolor2 = unselectcolor;
      unselectcolor3 = selectcolor;
      textcolor1 = unselecttextcolor;
      textcolor2 = unselecttextcolor;
      textcolor3 = selecttextcolor;
    });
  }

  @override
  void initState() {
    getUserData();

    GetAddressId(customerid.toString(), addresstype.toString());

    super.initState();
  }

  int index = 0;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:
          DateTime.now(), // set the first selectable date to the current date
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd')
          .format(DateTime(picked.year, picked.month, picked.day));
      setState(() {
        dateControlleer.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      String formattedTime = TimeOfDay(hour: picked.hour, minute: picked.minute)
          .format(context)
          .replaceAll(RegExp('[a-z]'), ''); // remove 'am' or 'pm'
      setState(() {
        _timeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool validatePrice() {
      RegExp regExp = new RegExp(
          r'^\d+(\.\d{1,2})?$'); // regex pattern for price with up to 2 decimal places
      if (regExp.hasMatch(budgetControlleer.text.trim())) {
        return true;
      }
      return false;
    }

    List<Widget> list = [
      homeaddress1 == ""
          ? InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: inputFieldBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 140,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                                text: "Other",
                                color: lightText,
                                fontfamily: 'Segoe UI',
                                fontweight: FontWeight.w900,
                                size: 20),
                          ],
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        CustomText(
                            text: "",
                            color: lightText,
                            fontfamily: 'Segoe UI',
                            fontweight: FontWeight.normal,
                            size: 15),
                        CustomText(
                            text: "Add Your Other Address...",
                            color: lightText,
                            fontfamily: 'Segoe UI',
                            fontweight: FontWeight.normal,
                            size: 15),
                        CustomText(
                            text: "",
                            color: lightText,
                            fontfamily: 'Segoe UI',
                            fontweight: FontWeight.normal,
                            size: 15),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SliderItem(
              address1: homeaddress1,
              address2: homeaddress2,
              city: homecity,
              addresstype: 'Home',
              color: unselectcolor1,
              textcolor: textcolor1,
            ),
      officeaddress1 == ""
          ? InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 140,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              text: "Office",
                              color: lightText,
                              fontfamily: 'Segoe UI',
                              fontweight: FontWeight.w900,
                              size: 20),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      CustomText(
                          text: "",
                          color: lightText,
                          fontfamily: 'Segoe UI',
                          fontweight: FontWeight.normal,
                          size: 15),
                      CustomText(
                          text: "Add Your Office Address...",
                          color: lightText,
                          fontfamily: 'Segoe UI',
                          fontweight: FontWeight.normal,
                          size: 15),
                      CustomText(
                          text: "",
                          color: lightText,
                          fontfamily: 'Segoe UI',
                          fontweight: FontWeight.normal,
                          size: 15),
                    ],
                  ),
                ),
              ),
            )
          : SliderItem(
              address1: officeaddress1,
              address2: officeaddress2,
              city: officecity,
              addresstype: 'Office',
              color: unselectcolor2,
              textcolor: textcolor2,
            ),
      otheraddress1 == ""
          ? InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: inputFieldBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 140,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              text: "Other",
                              color: lightText,
                              fontfamily: 'Segoe UI',
                              fontweight: FontWeight.w900,
                              size: 20),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      CustomText(
                          text: "",
                          color: lightText,
                          fontfamily: 'Segoe UI',
                          fontweight: FontWeight.normal,
                          size: 15),
                      CustomText(
                          text: "Add Your Other Address...",
                          color: lightText,
                          fontfamily: 'Segoe UI',
                          fontweight: FontWeight.normal,
                          size: 15),
                      CustomText(
                          text: "",
                          color: lightText,
                          fontfamily: 'Segoe UI',
                          fontweight: FontWeight.normal,
                          size: 15),
                    ],
                  ),
                ),
              ),
            )
          : SliderItem(
              address1: otheraddress1,
              address2: otheraddress2,
              city: othercity,
              addresstype: 'Other',
              color: unselectcolor3,
              textcolor: textcolor3,
            ),
    ];
    return Scaffold(
      appBar: Styles.appBar(context),
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date',
              style: labelText,
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: Form(
                  autovalidateMode: switched,
                  key: _dateformKey,
                  child: TextFormField(
                    controller: dateControlleer,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: inputFieldBackgroundColor,
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      color: lightText,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Time',
              style: labelText,
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                _selectTime(context);
              },
              child: AbsorbPointer(
                child: Form(
                  autovalidateMode: switched,
                  key: _timeformKey,
                  child: TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: inputFieldBackgroundColor,
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      color: lightText,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Time is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Select Location',
              style: labelText,
            ),
            const SizedBox(
              height: 8,
            ),
            CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
              ),
              items: list.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  list.indexOf(i) == 0
                                      ? selectAddress1()
                                      : list.indexOf(i) == 1
                                          ? selectAddress2()
                                          : selectAddress3();
                                });
                              },
                              child: i)
                        ]),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Estimated Budget',
              style: labelText,
            ),
            const SizedBox(
              height: 8,
            ),
            Form(
              autovalidateMode: switched,
              key: _budgetformKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }

                  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) {
                    return 'Invalid price format';
                  }
                  if (value.length > 255) {
                    return 'Estimated Budget cannot exceed 255 characters';
                  }
                  return null;
                },
                controller: budgetControlleer,
                keyboardType: TextInputType.number,
                focusNode: budgetFocusNode,
                style: const TextStyle(
                    fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                decoration: formInputStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Additional Info',
              style: labelText,
            ),
            const SizedBox(
              height: 8,
            ),
            Form(
              key: _additionalinformation,
              autovalidateMode: switched,
              child: TextFormField(
                  validator: (value) {
                    if (value!.length < 25) {
                      return 'Additional information must be at least 25 characters long';
                    }
                    if (value == null || value.isEmpty) {
                      return 'additional information is required';
                    }
                    return null;
                  },
                  maxLength: 100,
                  controller: additionalInformationControlleer,
                  keyboardType: TextInputType.text,
                  focusNode: additionalInformationFocusNode,
                  style: const TextStyle(
                      fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                  decoration: formInputStyle),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.bottomRight,
              height: 70,
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      switched = AutovalidateMode.always;
                    });
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (BuildContext context) =>
                    //         const TaskConfirmationScreen()));
                    await GetAddressId(
                        customerid.toString(), addresstype.toString());
                    print("my address id is =" + addressid.toString());

                    if (_budgetformKey.currentState!.validate() &&
                        _additionalinformation.currentState!.validate() &&
                        _timeformKey.currentState!.validate() &&
                        _dateformKey.currentState!.validate()) {
                      if (homeaddress1 != "" ||
                          officeaddress1 != "" ||
                          otheraddress1 != "") {
                        NavigationUtillfunction.navigateTo(
                            context,
                            TaskConfirmationScreen(
                              budget: budgetControlleer.text,
                              servececategoryid: widget.serviceindex,
                              date: dateControlleer.text,
                              time: _timeController.text,
                              addtionalinfo:
                                  additionalInformationControlleer.text,
                              addressid: addressid.toString(),
                            ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Adrress is Required"),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Center(child: const Text('OK')),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfileScreen()),
                                        (route) => false);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  // ignore: sort_child_properties_last
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: kPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7), // <-- Radius
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget inputField(String labelName, TextEditingController controller,
      TextInputType inputType, FocusNode focusNode) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelName,
            style: labelText,
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
              controller: controller,
              keyboardType: inputType,
              focusNode: focusNode,
              style: const TextStyle(
                  fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
              decoration: formInputStyle),
        ],
      ),
    );
  }
}

class SliderItem extends StatelessWidget {
  const SliderItem({
    super.key,
    required this.address1,
    required this.address2,
    required this.city,
    required this.addresstype,
    required this.color,
    required this.textcolor,
  });

  final String address1;
  final String address2;
  final String city;
  final String addresstype;
  final Color color;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        height: 140,
        width: 420,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                      text: addresstype,
                      color: textcolor,
                      fontfamily: 'Segoe UI',
                      fontweight: FontWeight.w900,
                      size: 20),
                ],
              ),
              SizedBox(
                width: 80,
              ),
              CustomText(
                  text: address1,
                  color: textcolor,
                  fontfamily: 'Segoe UI',
                  fontweight: FontWeight.normal,
                  size: 15),
              CustomText(
                  text: address2,
                  color: textcolor,
                  fontfamily: 'Segoe UI',
                  fontweight: FontWeight.normal,
                  size: 15),
              CustomText(
                  text: city,
                  color: textcolor,
                  fontfamily: 'Segoe UI',
                  fontweight: FontWeight.normal,
                  size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
