import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:servicehub_client/screen/On%20Bording%20Screens/login_screen.dart';
import 'package:servicehub_client/screen/Main%20Screens/Drawer.dart';
import 'package:servicehub_client/screen/Task/task_complete_screen.dart';
import 'package:servicehub_client/screen/Profile/verification_screen.dart';
import 'package:servicehub_client/utils/Navigation_Function.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Apicontroller extends ChangeNotifier {
//  Register Api
  // ignore: duplicate_ignore
  register(String email, phone_number, full_name, fcm_key,
      BuildContext context) async {
    final details = await SharedPreferences.getInstance();
    final detailss = await SharedPreferences.getInstance();

    Map data = {
      'email': email,
      'phone_number': phone_number,
      'full_name': full_name,
      'fcm_key': fcm_key,
    };

    // ignore: avoid_print
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "customer-register");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    // ignore: avoid_print
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);
    await details.setString('email', email);
    await details.setString('phone_number', phone_number);
    await details.setString('full_name', full_name);

    if (response.statusCode == 200) {
      final Map<String, dynamic> job = jsonData["0"];
      await detailss.setString('full_name', job['full_name'].toString());

      //Or put here your next screen using Navigator.push() method
      // Obtain shared preferences.

      Logger().i('success custom login');
      // Save an String value to 'action' key.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Your Registration Successful ")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  NavigationUtillfunction.navigateTo(
                      context, const LoginScreen());
                },
              ),
            ],
          );
        },
      );
      // ignore: use_build_context_synchronously
    } else {
      print("error");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("You are already logged ")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  NavigationUtillfunction.navigateTo(
                      context, const LoginScreen());
                },
              ),
            ],
          );
        },
      );
    }
  }

//FaceBook Register API

  fbgoogleregister(
      String email, phone_number, full_name, BuildContext context) async {
    final ids = await SharedPreferences.getInstance();
    final customerdetails = await SharedPreferences.getInstance();

    String customerid = await ids.getString("id").toString();
    Map data = {
      'email': email,
      'phone_number': phone_number,
      'full_name': full_name,
    };

    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "customer-register");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(jsonData["0"].toString());

      final Map<String, dynamic> job = jsonData["0"];
      await ids.setString('id', job['id'].toString());
      // await ids.setString('full_name', job['full_name'].toString());
      await ids.setString('full_name', full_name);

      await customerdetails.setString('phone_number', phone_number);

      print("id " + job['id'].toString());

      //otp genarate
      otpgenarate(phone_number, context);

      Logger().i('facebook google login');
      // Save an String value to 'action' key.

      // ignore: use_build_context_synchronously
      NavigationUtillfunction.navigateTo(
          context,
          VerificationScreen(
            userId: job['id'].toString(),
            PhoneNumber: phone_number,
          ));
    } else {
      Logger().e('error');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Number Allready Used")),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
              ),
            ],
          );
        },
      );
    }
  }

//Genarate Otp Api
  otpgenarate(String phone_number, BuildContext context) async {
    final idss = await SharedPreferences.getInstance();
    Map data = {
      'phone_number': phone_number,
    };
    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "otp");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      jsonResponse.toString();

      Logger().i("user id " + jsonResponse['id'].toString());
      await idss.setString('id', jsonResponse['id'].toString());

      Logger().i('otp sucess');

      print("user id ${jsonResponse['id']}");
      // ignore: use_build_context_synchronously
      NavigationUtillfunction.navigateTo(
          context,
          VerificationScreen(
            userId: jsonResponse['id'].toString(),
            PhoneNumber: phone_number,
          ));
    } else {
      Logger().e('error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("customer is not registered"),
            actions: <Widget>[
              ElevatedButton(
                child: Center(child: const Text('OK')),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
              ),
            ],
          );
        },
      );
    }
  }

//"Validate OTP Api
  validateotp(String id, String otp, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    Map data = {
      "id": id,
      'otp': otp,
    };
    print("post data $data");

    String body = json.encode(data);
    var url = Uri.parse(constant.APPEND_URL + "validate-otp");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await prefs.setBool('isLogged', true);
      //Or put here your next screen using Navigator.push() method
      Logger().i('validate sucess');
      // ignore: unused_local_variable
      var jsonResponse = jsonDecode(response.body);
      // print("user id ${jsonResponse['id']}");
      // await prefs.setString('id', id);
      //  await prefs.setBool('isLogged', true);

      // ignore: use_build_context_synchronously

      await getcustomerdetails(id.toString(), context);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false);
    } else {
      Logger().e('error');

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter Correct OTP'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

//"resend OTP Api
  resendotp(String otp, BuildContext context) async {
    Map data = {
      'resend-otp': otp,
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "validate-otp");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('otp sucess');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false);
    } else {
      Logger().e('error');
    }
  }

//update customer  by   id;
  updateCustomeId(
      String id, String full_name, String email, String phone_number) async {
    Map data = {
      "id": id,
      "full_name": full_name,
      "email": email,
      "phone_number": phone_number
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "update-customer");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String fullname, email, phonenumber;
      fullname = jsonResponse['full_name'].toString();
      email = jsonResponse['email'].toString();
      phonenumber = jsonResponse['phone_number'].toString();

      Logger().i('update sucess');
    } else {
      Logger().i('error');
    }
  }

//create customer Address

  CreaterCustomeraddressId(
      String id,
      String adreesstype,
      String adreess1,
      String adreess2,
      String city,
      String ing,
      String lat,
      BuildContext context) async {
    Map data = {
      "customer_id": id,
      "address_type": adreesstype,
      "address_1": adreess1,
      "address_2": adreess2,
      "city": city,
      "ing": ing,
      "lat": lat,
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "create-customer-address");

    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    String myid;
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Address Adding Sucessfull'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  NavigationUtillfunction.navigateTo(
                      context, const MainScreen());
                },
              ),
            ],
          );
        },
      );
      Logger().i('address create');
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Address Adding  Failed'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      Logger().e('error');
    }
  }

//Customer Address by ID

  addressbyid(String id) async {
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'customer-address?id=$id');
    final response = await http.get(url);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    //Creating a list to store input data;
  }

// getServiceCategoryID

  getServiceCategoryID(String id) async {
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "service-categories?'id':$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      // If the server returns a 200 OK response, parse the JSON

      var jsonResponse = jsonDecode(response.body);
      String name = {jsonResponse['name']}.toString();

      print(data);
    } else {
      // If the server returns an error, throw an exception
      throw Exception('Failed to load data');
    }
  }

//get list of customer

  Future<List<CustomerList>> getlistofcustomer() async {
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "customer-list");
    final response = await http.get(url);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    //Creating a list to store input data;
    List<CustomerList> customers = [];
    for (var name in responseData) {
      CustomerList customerList = CustomerList(
        name: name["id"],
      );

      //Adding user to the list.
      customers.add(customerList);
    }
    return customers;
    print(customers);
  }

//get customer details  (my profile read only)
  getcustomerdetails(String id, BuildContext context) async {
    final customerdetails = await SharedPreferences.getInstance();
    final prefs = await SharedPreferences.getInstance();

    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'customer?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    String fullname, email, phonenumber;

    fullname = jsonResponse['full_name'].toString();
    email = jsonResponse['email'].toString();
    phonenumber = jsonResponse['phone_number'].toString();
    if (jsonResponse == null ||
        jsonResponse.isEmpty ||
        jsonResponse['full_name'] == null ||
        jsonResponse['email'] == null) {
      await prefs.setBool("isLogged", false);
    }

    await customerdetails.setString('full_name', fullname);
    await customerdetails.setString('email', email);
    await customerdetails.setString('phone_number', phonenumber);
    print(customerdetails.getString('full_name is  ' + fullname));
    ;
  }

  //Get UpcomingAppoinments

  getUpcomingAppoinments(String id) async {
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + 'customer-upcoming-appointments?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    print({jsonResponse['name']}.toString());

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    //Creating a list to store input data;
  }

  getpastAppoinments(String id) async {
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url =
        // ignore: prefer_interpolation_to_compose_strings
        Uri.parse(constant.APPEND_URL + 'customer-past-appointments?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    //Creating a list to store input data;
  }

//Get All APOINMENTS

  getAppoinments(String id) async {
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url =
        Uri.parse(constant.APPEND_URL + 'customer-appointments-by-id?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    //Creating a list to store input data;
  }

//Get Request Of Jobs

  getRequestJob(String id) async {
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'jobRequests?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    //Creating a list to store input data;
  }

//GetJobRating Provider

  getJobRatingsofProviser(String id) async {
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'jobRatings?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);

    //Creating a list to store input data;
  }

//Create Appoinments

  CreateAppoinment(
    String service_category_id,
    String customer_id,
    String appointment_date_time,
    String appointment_time,
    String customer_address_id,
    String estimated_budget,
    String job_type,
    String addtional_info,
    BuildContext context,
  ) async {
    final createcustomeraddressperfs = await SharedPreferences.getInstance();
    Map data = {
      "service_category_id": service_category_id,
      "customer_id": customer_id,
      "appointment_date_time": appointment_date_time,
      "appointment_time": appointment_time,
      "customer_address_id": customer_address_id,
      "estimated_budget": estimated_budget,
      "job_type": job_type,
      "addtional_info": addtional_info
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "create-appointment");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Logger().i('Appoiments Create SucessFull');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TaskCompleteScreen()),
          (route) => false);
    } else {
      Logger().e('error');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Appoiments Create Unsuccessful'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

//Add Job Ratings

  Jobrating(String customerid, String job_id, String service_provider_id,
      String rating, String comment, BuildContext context) async {
    Map data = {
      'customer_id': customerid,
      'job_id': job_id,
      'service_provider_id': service_provider_id,
      'rating': rating,
      'comment': comment
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "create-rating");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Your Review approval.."),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    NavigationUtillfunction.navigateTo(context, MainScreen());
                  },
                ),
              ),
            ],
          );
        },
      );

      //Or put here your next screen using Navigator.push() method
      Logger().i('rating sucess');
    } else {
      Logger().e('error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("rating already exists for this job")),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    NavigationUtillfunction.navigateTo(context, MainScreen());
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

//Acept Request

  AcceptRequest(
      String service_provider_id, String job_id, String request_id) async {
    Map data = {
      'request_id': request_id,
      'service_provider_id': service_provider_id,
      'job_id': job_id,
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "accept-request");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('Request sucess');
    } else {
      Logger().e('error');
    }
  }

//Create Payments

  CreatePayment(
      String id,
      String paymentmethod,
      String paymentdate,
      String jobid,
      String payment_ref,
      String paid_amount,
      String service_provider_id,
      BuildContext context) async {
    String paymentToken;
    Map data = {
      "customer_id": id,
      "payment_method": paymentmethod,
      "payment_date": paymentdate,
      "job_id": jobid,
      "payment_ref": payment_ref,
      "paid_amount": paid_amount,
      "service_provider_id": service_provider_id
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "create-payment");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Logger().i('payment details sen sucessfull');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
    } else {
      Logger().e('error');
    }
  }

  ///get customer name by id

  getcustomernamebyid(String id) async {
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'customer-name?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    String fullname;
    fullname = {jsonResponse['full_name']}.toString();

    print(fullname);

    //Creating a list to store input data;
  }

//udate customer address (map)
  UpdateCustomerAddress(
      String id,
      String adreesstype,
      String adreess1,
      String adreess2,
      String city,
      String ing,
      String lat,
      String customerid,
      BuildContext context) async {
    Map data = {
      "id": id,
      "address_type": adreesstype,
      "address_1": adreess1,
      "address_2": adreess2,
      "customer_id": customerid,
      "ing": ing,
      "lat": lat,
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "update-customer-address");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('new update sucess');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('new update sucessfull'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  NavigationUtillfunction.navigateTo(
                    context,
                    const MainScreen(),
                  );
                },
              ),
            ],
          );
        },
      );
      // NavigationUtillfunction.navigateTo(context, MainScreen());
    } else {
      Logger().e('error');
      // NavigationUtillfunction.navigateTo(context, MainScreen());
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('new update unsucessfull'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

//Send PushNotification

  SendPushNotification(
      String fcmkey, String title, String message, BuildContext context) async {
    Map data = {
      'to': fcmkey,
      'notification': {
        'title': title,
        'body': message,
      },
    };
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAE-eDRRE:APA91bGc-7O9bML_SqczRdQyqVhCemDcV9y7DBXbWnDvGqVxk25sECnAknbkCshUkCGwgEubH8CJb4ZnaD0w45mx8Hi35XCfGANiJC6IZS6xnd-1djFkkukVmoDCFnpF-B6xarUxjniO",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('Push Notification Sucessfully');
    } else {
      Logger().e('error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: const Text('Not Selected Any provider')),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

//Remove Provider

  RemoveProviderByCustomer(String id, BuildContext context) async {
    // ignore: prefer_interpolation_to_compose_strings
    var url =
        Uri.parse(constant.APPEND_URL + "remove-provider-by-customer?id=$id");
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('Remove sucess');
      NavigationUtillfunction.navigateTo(
        context,
        const MainScreen(),
      );
    } else {
      Logger().e('error');
    }
  }

//Update Fcm Key
  CustomerFcmKeyUpdat(String Customer_id, String fcm_key) async {
    Map data = {'customer_id': Customer_id, 'fcm_key': fcm_key};
    print("post data $data");

    String body = json.encode(data);
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + "update-customer-fcm-key");
    var response = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      Logger().i('Push Notification Sucessfully');
    } else {
      Logger().e('error');
    }
  }

//Get Provider Deatails

  getproviderdetails(String id) async {
    final providerdetails = await SharedPreferences.getInstance();
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(constant.APPEND_URL + 'provider?id=$id');
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    String fcm_key;
    fcm_key = jsonResponse['fcm_key'].toString();

    await providerdetails.setString('fcmkey', fcm_key);

    await providerdetails
      ..setString('fcm_key', fcm_key);

    //Creating a list to store input data;
  }
}

class CustomerAdressList {
  final String id;

  CustomerAdressList({
    required this.id,
  });
}

class CustomerList {
  final String name;

  CustomerList({
    required this.name,
  });
}
