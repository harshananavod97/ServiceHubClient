// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:servicehub_client/utils/Custom_Text.dart';

import '../Colors.dart';

class OtherAdreessComponent extends StatefulWidget {
  OtherAdreessComponent({
    required this.addres_type,
    required this.address_1,
    required this.address_2,
    required this.city,
    required this.editonPress,
    required this.btn,
    required this.saveonPress,
  });
  String addres_type;
  String address_1;
  String address_2;
  String city;
  bool btn;

  final VoidCallback saveonPress;
  final VoidCallback editonPress;

  @override
  State<OtherAdreessComponent> createState() => _OtherAdreessComponentState();
}

class _OtherAdreessComponentState extends State<OtherAdreessComponent> {
  TextEditingController address_2controller = TextEditingController();
  TextEditingController address_1controller = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController city_controller = TextEditingController();

  setveriable() {
    address_1controller.text = widget.address_1;
    address_2controller.text = widget.address_2;
    city_controller.text = widget.city;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setveriable();
  }

  @override
  Widget build(BuildContext context) {
    final allFocusNode = FocusNode();
    return Container(
      decoration: const BoxDecoration(
          color: inputFieldBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                      text: 'Others',
                      color: lightText,
                      fontfamily: 'Segoe UI',
                      fontweight: FontWeight.w900,
                      size: 20),
                  widget.btn
                      ? IconButton(
                          onPressed: widget.editonPress,
                          icon: const Icon(Icons.edit),
                          color: darkText,
                        )
                      : IconButton(
                          onPressed: widget.saveonPress,
                          icon: const Icon(Icons.save),
                          color: darkText,
                        )
                ],
              ),
              TextFormField(
                  readOnly: widget.btn,
                  controller: address_1controller,
                  keyboardType: TextInputType.streetAddress,
                  style: const TextStyle(
                      fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                  decoration: formInputStyle),
              TextFormField(
                  readOnly: widget.btn,
                  controller: address_2controller,
                  keyboardType: TextInputType.streetAddress,
                  style: const TextStyle(
                      fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                  decoration: formInputStyle),
              TextFormField(
                  readOnly: widget.btn,
                  controller: city_controller,
                  keyboardType: TextInputType.streetAddress,
                  style: const TextStyle(
                      fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                  decoration: formInputStyle),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class OfficeAdddressComponet extends StatefulWidget {
  OfficeAdddressComponet({
    required this.addres_type,
    required this.address_1,
    required this.address_2,
    required this.city,
    required this.editonPress,
    required this.btn,
    required this.saveonpress,
  });
  String addres_type;
  String address_1;
  String address_2;
  String city;
  bool btn;

  final VoidCallback editonPress;
  final VoidCallback saveonpress;

  @override
  State<OfficeAdddressComponet> createState() => _OfficeAdddressComponetState();
}

class _OfficeAdddressComponetState extends State<OfficeAdddressComponet> {
  TextEditingController address_2controller = TextEditingController();
  TextEditingController address_1controller = TextEditingController();
  TextEditingController city_controller = TextEditingController();
  setveriable() {
    address_1controller.text = widget.address_1;
    address_2controller.text = widget.address_2;
    city_controller.text = widget.city;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setveriable();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: inputFieldBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                      text: 'Office',
                      color: lightText,
                      fontfamily: 'Segoe UI',
                      fontweight: FontWeight.w900,
                      size: 20),
                  widget.btn
                      ? IconButton(
                          onPressed: widget.editonPress,
                          icon: const Icon(Icons.edit),
                          color: darkText,
                        )
                      : IconButton(
                          onPressed: widget.saveonpress,
                          icon: const Icon(Icons.save),
                          color: darkText,
                        )
                ],
              ),
              TextFormField(
                  readOnly: widget.btn,
                  controller: address_1controller,
                  keyboardType: TextInputType.streetAddress,
                  style: const TextStyle(
                      fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                  decoration: formInputStyle),
              TextFormField(
                  readOnly: widget.btn,
                  controller: address_2controller,
                  keyboardType: TextInputType.streetAddress,
                  style: const TextStyle(
                      fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                  decoration: formInputStyle),
              TextFormField(
                  readOnly: widget.btn,
                  controller: city_controller,
                  keyboardType: TextInputType.streetAddress,
                  style: const TextStyle(
                      fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                  decoration: formInputStyle)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class homeAddressComponent extends StatefulWidget {
  homeAddressComponent(
      {required this.addres_type,
      required this.address_1,
      required this.address_2,
      required this.city,
      required this.editonPress,
      required this.btn,
      required this.saveonpress});
  String addres_type;
  String address_1;
  String address_2;
  String city;
  bool btn;

  final VoidCallback editonPress;

  final VoidCallback saveonpress;

  @override
  State<homeAddressComponent> createState() => _homeAddressComponentState();
}

// ignore: camel_case_types
class _homeAddressComponentState extends State<homeAddressComponent> {
  TextEditingController address_2controller = TextEditingController();
  TextEditingController address_1controller = TextEditingController();
  TextEditingController city_controller = TextEditingController();

  setveriable() {
    address_1controller.text = widget.address_1;
    address_2controller.text = widget.address_2;
    city_controller.text = widget.city;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setveriable();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            color: inputFieldBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                        text: 'Home',
                        color: lightText,
                        fontfamily: 'Segoe UI',
                        fontweight: FontWeight.w900,
                        size: 20),
                    widget.btn
                        ? IconButton(
                            onPressed: widget.editonPress,
                            icon: const Icon(Icons.edit),
                            color: darkText,
                          )
                        : IconButton(
                            onPressed: widget.saveonpress,
                            icon: const Icon(Icons.save),
                            color: darkText,
                          )
                  ],
                ),
                TextFormField(
                    readOnly: widget.btn,
                    controller: address_1controller,
                    keyboardType: TextInputType.streetAddress,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle),
                TextFormField(
                    readOnly: widget.btn,
                    controller: address_2controller,
                    keyboardType: TextInputType.streetAddress,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle),
                TextFormField(
                    readOnly: widget.btn,
                    controller: city_controller,
                    keyboardType: TextInputType.streetAddress,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
