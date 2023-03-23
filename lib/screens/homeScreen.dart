import 'dart:convert';
import 'dart:math';
// import 'package:geolocator/geolocator.dart';
import 'package:client/screens/account.dart';
import 'package:client/screens/addPosts.dart';
import 'package:client/screens/ai.dart';
import 'package:client/screens/cart.dart';
import 'package:client/screens/homebody.dart';
import 'package:client/screens/showPosts.dart';
import 'package:client/screens/splashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

// import 'package:restart_app/restart_app.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class MyHome extends StatefulWidget {
  MyHome();

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String currentVal = "";
  late Future myFuture;
  final auth = FirebaseAuth.instance;
  int i = 0;
  var nur = FirebaseFirestore.instance.collection("plants");
  List<Map<String, dynamic>> items = [];
  fetchNurseries() async {
    var data = await nur.get();

    List<Map<String, dynamic>> templist = [];
    data.docs.forEach((element) {
      templist.add(element.data());
    });
    setState(() {
      print(templist);
      items = templist;
    });
  }

  // List kitchen = [
  //   {
  //     "Tiffin_Name": "Test1",
  //     "Tiffin_Image_url":
  //         "https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?cs=srgb&dl=pexels-pixabay-268533.jpg&fm=jpg",
  //     "distance": "50"
  //   },
  //   {
  //     "Tiffin_Name": "Test2",
  //     "Tiffin_Image_url":
  //         "https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?cs=srgb&dl=pexels-pixabay-268533.jpg&fm=jpg",
  //     "distance": "60"
  //   }
  // ];
  Future<void> logout() async {
    // await auth.signOut().then((value) => Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const SplashScreen())));
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushReplacement(
            MaterialPageRoute(builder: (context) => const SplashScreen())));
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchNurseries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 45, bottom: 15),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "India",
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 20),
                      ),
                      Row(
                        children: [
                          Text(
                            "Gujarat",
                            style: TextStyle(
                                color: Colors.green[700], fontSize: 12),
                          ),
                          Icon(Icons.arrow_drop_down_rounded)
                        ],
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width: 45,
                      height: 45,
                      // ignore: sort_child_properties_last
                      child: IconButton(
                        onPressed: () async {
                          await auth.signOut().then((value) {
                            Navigator.pushNamed(context, 'splash');
                          });
                        },
                        // onPressed: () {
                        //   logout();
                        // },
                        icon: Icon(Icons.logout),
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green[700]),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: HomeBody(items: items),
          )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ShowPosts()));
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
          notchMargin: 5.0,
          shape: CircularNotchedRectangle(),
          color: Colors.green[700],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0, top: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      Text(
                        "Cart",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MyCart()));
                },
              ),
              InkWell(
                onTap: (() => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => Ai()))
                    }),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                      Text(
                        "A.I.",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      Text(
                        "Account",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyAccount()));
                },
              ),
            ],
          )),
    );
  }
}
