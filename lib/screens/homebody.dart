import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:client/screens/nursery_items.dart';
import 'package:client/screens/plant_details.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:marquee_widget/marquee_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:carousel_pro/carousel_pro.dart';

import '../utils/dimensions.dart';
import '../widgets/bigtext.dart';
import '../widgets/icontext.dart';
import '../widgets/smalltext.dart';

class HomeBody extends StatefulWidget {
  late List<Map<String, dynamic>> items = [];
  HomeBody({
    super.key,
    required this.items,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  ScrollController _controller = new ScrollController();

  Map<String, List<String>> Menu = {};
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  var curr_latitude = "0".obs;
  var curr_longitude = "0".obs;
  getloc() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    curr_latitude.value = '${position.latitude}';
    curr_longitude.value = '${position.longitude}';
    print(curr_latitude);
    print(curr_longitude);
  }

  @override
  void initState() {
    super.initState();

    // this.fetchkitchen();
    // print(widget.kitchen);
    getloc();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: Dimensions.pageView,
              // color: Colors.red,
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.items.length,
                itemBuilder: (context, position) {
                  // print(widget.kitchen.length);
                  return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlantDetails(
                                para1: widget.items[position]["para1"],
                                para2: widget.items[position]["para2"],
                                plant_name: widget.items[position]
                                    ["plant_name"],
                                para_img: widget.items[position]
                                    ["plant_img"])));
                      },
                      child: _buildPageItem(position));
                },
              ),
            ),
          ],
        ),
        // ignore: unnecessary_new
        new DotsIndicator(
          dotsCount: widget.items.length == 0 ? 2 : widget.items.length,
          position: _currPageValue,
          decorator: DotsDecorator(
            activeColor: Colors.green[700],
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        SizedBox(
          height: Dimensions.width30,
        ),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Popular"),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(
                  text: ".",
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: SmallText(text: "Plant Pairing"),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("nurseries")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black45),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.width20,
                                    right: Dimensions.width20,
                                    bottom: Dimensions.height10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20),
                                          color: Colors.white38,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  snapshot.data?.docs[index]
                                                      ["n_image_url"]))),
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                Dimensions.radius20),
                                            bottomRight: Radius.circular(
                                                Dimensions.radius20)),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: Dimensions.width10,
                                            right: Dimensions.width10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BigText(
                                                text: snapshot.data?.docs[index]
                                                    ["n_name"]),
                                            SizedBox(
                                              height: Dimensions.height10,
                                            ),
                                            SizedBox(
                                              height: Dimensions.height10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconAndText(
                                                    icon: Icons.location_on,
                                                    text: calculateDistance(
                                                                double.parse(snapshot
                                                                        .data
                                                                        ?.docs[index][
                                                                    "Latitude"]),
                                                                double.parse(snapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    "Longitude"]),
                                                                double.parse(
                                                                    curr_latitude
                                                                        .toString()),
                                                                double.parse(
                                                                    curr_longitude
                                                                        .toString()))
                                                            .toStringAsFixed(1)
                                                            .toString() +
                                                        "KM",
                                                    Iconcolor: Colors.green),
                                                IconAndText(
                                                    icon: Icons
                                                        .access_time_rounded,
                                                    text: "32Min",
                                                    Iconcolor: Colors.green)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NurseryItems(
                                          DocId: snapshot
                                              .data?.docs[index].reference.id,
                                          Item_Name: snapshot.data?.docs[index]
                                              ["n_name"],
                                        )));
                              },
                            );
                          });
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - currScale) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.items[index]['plant_img']))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5)),
                  BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                  BoxShadow(color: Colors.white, offset: Offset(5, 0)),
                ],
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height15, left: 15, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: widget.items[index]['plant_name']),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(
                              5,
                              (index) => Icon(
                                    Icons.star,
                                    color: Colors.green,
                                    size: 15,
                                  )),
                        ),
                        SizedBox(
                          width: Dimensions.height20,
                        ),
                        SmallText(
                          text: "4.5",
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SmallText(text: widget.items[index]['small_info'])
                    //
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
