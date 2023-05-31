import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/screen/task_list_screen.dart';

class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({super.key});

  List<String> featureServiceList = [
    "Computer Repair",
    "Plumbing Works",
    "Cleaning Service",
    "Vehicle Repair",
    "Paint Works",
    "Electrical Service",
    "Cleaning Service",
    "Vehicle Repair",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Featured Services',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20.0,
                        color: darkText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 8.0 / 5.0,
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12),
                      itemBuilder: (_, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TaskListScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFD3CECE),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              featureServiceList[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF4E4848),
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      itemCount: featureServiceList.length,
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  child: Container(
                    color: navigationTop,
                    height: 23,
                    width: MediaQuery.of(context).size.width,
                  )),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 47,
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 18),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.black,
                        )),
                    onSubmitted: (value) {
                      // Navigator.of(context).pushReplacement(
                      //         MaterialPageRoute(
                      //             builder: (BuildContext context) =>
                      //                 const MainScreen()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
