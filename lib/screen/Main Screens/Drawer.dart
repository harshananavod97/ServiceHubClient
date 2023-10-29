import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/provider/auth_provider.dart';
import 'package:servicehub_client/screen/Appoiment/appontment_screen.dart';
import 'package:servicehub_client/screen/Main%20Screens/contact_screen.dart';
import 'package:servicehub_client/screen/Main%20Screens/faq_screen.dart';
import 'package:servicehub_client/screen/Main%20Screens/home_screen.dart';
import 'package:servicehub_client/screen/On%20Bording%20Screens/login_screen.dart';
import 'package:servicehub_client/screen/Profile/profile_screen.dart';
import 'package:servicehub_client/screen/Main%20Screens/terms_condition_screen.dart';
import 'package:servicehub_client/widget/app_name_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  String name = '';


  //Drawer Screen List 
  
  List<Widget> list = [
    const HomeScreen(),
    AppointmentScreen(
      on: false,
      size: 30,
    ),
    const ProfileScreen(),
    const ContactScreen(),
    const FaqScreen(),
    const TermsConditionScreen(),
    const LoginScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: index == 0 ? navigationTop : white,
          foregroundColor: darkText,
          title: index == 0 ? const Text("Servicehub") : const Text(""),
        ),
        body: list[index],
        drawer: MyDrawer());
  }
}

//Drawer Screen

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //get user id
  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    print("getcustomerdata called " + ids.getString('full_name').toString());

    ids.getString("id").toString().isNotEmpty
        ? customerid = ids.getString("id").toString()
        : customerid = idss.getString("id").toString();

    print("my id is" + customerid);
  }

//get customer name
  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();

    setState(
      () {
        fullname = customerdetails.getString('full_name').toString() != null
            ? fullname = customerdetails.getString('full_name').toString()
            : fullname = "";
      },
    );
  }

//user login saved
  looged() async {
    final prefs = await SharedPreferences.getInstance();

    bool? islog = prefs.getBool('isLogged');
    print(prefs.getBool('isLogged'));
  }

  String customerid = '';
  String fullname = '';
  bool islog = false;
  String id = '';

  Apicontroller apicontroller = Apicontroller();
  final fullNameControlleer = TextEditingController();

  @override
  void initState() {
    looged();
    getUserData();
    getcustomerdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: white,
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(left: 35, top: 20),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppNameWidget(),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Hey",
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    fullname,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 25,
                        color: darkText,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              ListTile(
                leading: const Icon(Icons.home, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "Home",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    )),
              ),
              ListTile(
                leading: const Icon(Icons.list, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "Appoinments",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(
                        on: false,
                        size: 30,
                      ),
                    )),
              ),
              ListTile(
                  leading: const Icon(Icons.person, color: kPrimary),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  title: const Text(
                    "My Profile",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 22,
                        color: darkText,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ));
                  }),
              ListTile(
                  leading: const Icon(Icons.mail, color: kPrimary),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  title: const Text(
                    "Contact us",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 22,
                        color: darkText,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactScreen(),
                      ))),
              ListTile(
                leading: const Icon(Icons.message, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "FAQs",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaqScreen(),
                    )),
              ),
              ListTile(
                leading:
                    const Icon(Icons.content_paste_outlined, color: kPrimary),
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                title: const Text(
                  "Terms & Conditions",
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 22,
                      color: darkText,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsConditionScreen(),
                    )),
              ),
              ListTile(
                  leading: const Icon(Icons.logout, color: kPrimary),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 22,
                        color: darkText,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.setBool("isLogged", false);

                    prefs.clear();

                    //Fb Google Logout Method Called
                    Provider.of<AuthProvider>(context, listen: false)
                        .logout(context);

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
