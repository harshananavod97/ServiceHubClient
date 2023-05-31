import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servicehub_client/model/ServiceCategory.dart';
import 'package:servicehub_client/screen/appoinment_task_screen.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:http/http.dart' as http;
import '../Colors.dart';

class AllServiceCategory extends StatefulWidget {
  @override
  _AllServiceCategoryState createState() => _AllServiceCategoryState();
}

class _AllServiceCategoryState extends State<AllServiceCategory> {
  String _capitalizeWords(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
    return words.join(' ');
  }

  ScrollController _scrollController = ScrollController();

  int count = 0;
  int itemcount = 10;
  bool searchvalue = true;
  int _page = 1;

  List<Datum> servicenameslist = [];
  List<String> filteredItems = [];

  List<SearchList> searchlist = [];

//GetList of Service  Categories(main page load)

  Future<List<Datum>> getServiceCategory(int page) async {
    //servicenameslist.clear();
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "service-categories?page=" + page.toString());
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('load sucess');

      final appontment = sericeNamesFromJson(response.body);

      //servicenameslist.addAll(appontment.data);
      print(response.body);

      if (_page == 1) {
        servicenameslist = appontment.data;
      } else {
        print("more data");
        servicenameslist.addAll(appontment.data);
      }

      return appontment.data;
    } else {
      return servicenameslist;

      throw Exception('Failed to load data');
    }
  }

  Future<List<SearchList>> getsercherblecategorylist(String query) async {
    searchlist.clear();
    //replace your restFull API here.
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(
        constant.APPEND_URL + 'searchable-service-categories?query=$query');
    final response = await http.get(url);
    var data = json.decode(response.body.toString());
    print(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      for (Map i in data) {
        SearchList searchlistnames = SearchList(name: i['name'], id: i['id']);

        searchlist.add(searchlistnames);
      }
      count = searchlist.length.toInt();
      return searchlist;

      print(searchlist);
    } else {
      return searchlist;
      // If the server returns an error, throw an exception
      throw Exception('Failed to load data');
    }
  }

  List<String> allItems = [];

  List<String> displayedItems = [];

  bool isLoading = false;
  int pageCount = 1;
  //ScrollController _scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // Display the first 10 items when the widget is first loaded

    //getServiceCategory();
    //searchController.text = searchtext;
    // getsercherblecategorylist(searchController.toString());
    trueload();

    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("End of the list");
      setState(() {
        _page++;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void trueload() {
    setState(() {
      searchController.text.isEmpty ? searchvalue = true : searchvalue = false;

      //searchlist.length > 6 ? searchlist.clear() : searchlist;
    });
  }

  void falseload() {
    setState(() {
      searchvalue = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: searchController,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    fillColor: navigationTop,
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
                onChanged: (value) {
                  trueload();
                },
                //  onSubmitted: (value) {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 65),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: searchvalue
                      ? FutureBuilder(
                          future: getServiceCategory(_page),
                          builder:
                              (context, AsyncSnapshot<List<Datum>> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                servicenameslist.isEmpty) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    "Error: ${snapshot.error.toString()}"), //Error: ${snapshot.error}
                              );
                            } else if (!snapshot.hasData &&
                                servicenameslist.isEmpty) {
                              return Center(
                                child: Text('No data'),
                              );
                            } else {
                              return Stack(
                                children: [
                                  if (!snapshot.hasData)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  GridView.builder(
                                    controller: _scrollController,
                                    itemCount: servicenameslist.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 8.0 / 5.0,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index < servicenameslist.length) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AppoinmentTaskScreen(
                                                      serviceindex:
                                                          servicenameslist[
                                                                  index]
                                                              .id
                                                              .toString()),
                                            ));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD3CECE),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data![index].name
                                                            .toString()
                                                            .length >
                                                        24
                                                    ? _capitalizeWords(snapshot
                                                            .data![index].name
                                                            .toString()
                                                            .substring(0, 24)) +
                                                        "..."
                                                    : _capitalizeWords(snapshot
                                                        .data![index].name
                                                        .toString()),
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
                                        );
                                      } else {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 32),
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        )
                      : FutureBuilder(
                          future:
                              getsercherblecategorylist(searchController.text),
                          builder: (context,
                                  AsyncSnapshot<List<SearchList>> snapshot) =>
                              GridView.builder(
                            shrinkWrap: true,
                            physics: searchlist.length > 8
                                ? const ScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 8.0 / 5.0,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12),
                            itemBuilder: (BuildContext context, index) =>
                                InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AppoinmentTaskScreen(
                                          serviceindex: snapshot.data![index].id
                                              .toString(),
                                        )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFFD3CECE),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: servicenameslist.isEmpty
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          snapshot.data![index].name.toString(),
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
                            itemCount: searchlist.length,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchList {
  String name;
  int id;

  SearchList({required this.name, required this.id});
}
