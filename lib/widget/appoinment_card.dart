import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/screen/Appoiment/appoinment_info_screen.dart';
import 'package:servicehub_client/screen/Appoiment/past_appoinment_info_screen.dart';

class AppoinmentCard extends StatelessWidget {
  const AppoinmentCard(
      {super.key,
      required this.isPending,
      this.isPast = false,
      required this.date,
      required this.time,
      required this.budget,
      required this.jobtype,
      required this.additionalinfo,
      required this.addresstype,
      required this.index,
      required this.jobstatus,
      required this.serviceindex});
  final int index;
  final bool isPending;
  final bool isPast;
  final String date;
  final String time;
  final String jobtype;
  final String jobstatus;
  final String budget;
  final String additionalinfo;
  final String addresstype;
  final String serviceindex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("my select index :" + index.toString());
        if (isPast) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PastAppoinmentInfoScreen(
                    index: index,
                    serviceindex: serviceindex.toString(),
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  AppoinmentInfoScreen(index: index)));
        }
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: isPast ? darkText : kPrimary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12.0,
                            color: white,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 9.0,
                          color: white,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 10,
                          ),
                          Text(
                            addresstype,
                            style: const TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 8.0,
                              color: white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            jobtype,
                            style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 16.0,
                                color: darkText,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              additionalinfo,
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 10.0,
                                color: darkText,
                              ),
                            ),
                          ),
                          Text(
                            budget,
                            style: const TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 10.0,
                              color: darkText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      isPending
                          ? Positioned(
                              right: 8,
                              top: 10,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 2, bottom: 2),
                                    child: Text(
                                      isPast ? "past" : jobstatus,
                                      style: const TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 8.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )))
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
