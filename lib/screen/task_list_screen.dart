import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/screen/appoinment_task_screen.dart';
import 'package:servicehub_client/styles.dart';

class TaskListScreen extends StatelessWidget {
  TaskListScreen({super.key});

  List<String> taskList = [
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
    "Sub task name",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: Styles.appBar(context),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select task',
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
              ListView.builder(
                  itemCount: taskList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(7)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            taskList[index],
                            style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20,
                                color: darkText),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          )),
      bottomSheet: Container(
        alignment: Alignment.bottomRight,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AppoinmentTaskScreen(
                        serviceindex: '2',
                      )));
            },
            // ignore: sort_child_properties_last
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                'Confirm',
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
      ),
    );
  }
}
