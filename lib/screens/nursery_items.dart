import 'dart:convert';
import 'dart:ffi';
import 'package:client/controllers/product_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_item.dart';
import '../utils/dimensions.dart';
import '../widgets/bigtext.dart';
import '../widgets/smalltext.dart';

class NurseryItems extends StatefulWidget {
  String? DocId = "";
  String? Item_Name = "";

  NurseryItems({super.key, required this.DocId, required this.Item_Name});
  @override
  State<NurseryItems> createState() => _NurseryItemsState();
}

class _NurseryItemsState extends State<NurseryItems> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartController controller = CartController();
    // widget.updated == null ? 0 : widget.updated;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 252, 240),
      appBar: AppBar(
        title: Text(widget.Item_Name.toString(),
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      // ignore: unnecessary_new

                      SizedBox(
                        height: Dimensions.width30,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Dimensions.width30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BigText(
                              text: "Popular",
                              color: Colors.green,
                            ),
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
                              child: SmallText(
                                text: "Plants",
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Column(
                            // height: MediaQuery.of(context).size.height,
                            children: [
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("nurseries")
                                      .doc(widget.DocId)
                                      .collection('nursery_items')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                        height: 200.0,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black45),
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (context, index) {
                                            return Container(
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
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                Dimensions
                                                                    .radius20),
                                                        color: Colors.white38,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                snapshot.data
                                                                            ?.docs[
                                                                        index][
                                                                    "item_image_url"]))),
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                Dimensions
                                                                    .radius20),
                                                        bottomRight:
                                                            Radius.circular(
                                                                Dimensions
                                                                    .radius20),
                                                      ),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(
                                                                0xFFe8e8e8),
                                                            blurRadius: 5.0,
                                                            offset:
                                                                Offset(0, 5)),
                                                        BoxShadow(
                                                            color: Colors.white,
                                                            offset:
                                                                Offset(-5, 0)),
                                                        BoxShadow(
                                                            color: Colors.white,
                                                            offset:
                                                                Offset(5, 0)),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions
                                                              .width10,
                                                          right: Dimensions
                                                              .width10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          BigText(
                                                            text: snapshot.data
                                                                    ?.docs[index]
                                                                ["item_name"],
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                            height: Dimensions
                                                                .height10,
                                                          ),
                                                          SmallText(
                                                            text: "Price:- " +
                                                                snapshot.data
                                                                            ?.docs[
                                                                        index][
                                                                    "item_price"] +
                                                                " 5ire",
                                                            color: Colors.green,
                                                          ),
                                                          cartItems(
                                                              ind: snapshot
                                                                  .data
                                                                  ?.docs[index]
                                                                  .reference
                                                                  .id,
                                                              price: snapshot
                                                                          .data
                                                                          ?.docs[
                                                                      index][
                                                                  "item_price"],
                                                              name: snapshot
                                                                          .data
                                                                          ?.docs[
                                                                      index]
                                                                  ["item_name"])
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 120,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 555.0, left: 12.0),
          //   child: Container(
          //     height: 70,
          //     width: MediaQuery.of(context).size.width - 30,
          //     decoration: BoxDecoration(
          //       color: Colors.amberAccent,
          //       borderRadius: BorderRadius.circular(20),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Color(0xFFe8e8e8),
          //             blurRadius: 5.0,
          //             offset: Offset(0, 5)),
          //         BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
          //         BoxShadow(color: Colors.white, offset: Offset(5, 0)),
          //       ],
          //     ),
          //     child: Obx(() => Row(
          //           children: [
          //             SizedBox(
          //               width: 20,
          //             ),
          //             Text(
          //               "Total Price:- " +
          //                   _CartController.total.value.toString() +
          //                   " ₹",
          //               style: TextStyle(
          //                   color: Colors.white, fontWeight: FontWeight.w700),
          //             ),
          //             SizedBox(
          //               width: 20,
          //             ),
          //             ElevatedButton(
          //                 style: ElevatedButton.styleFrom(
          //                     shape: new RoundedRectangleBorder(
          //                       borderRadius: new BorderRadius.circular(30.0),
          //                     ),
          //                     backgroundColor: Colors.greenAccent),
          //                 onPressed: () => {
          //                       if (_CartController.total.value > 0)
          //                         {
          //                           Navigator.of(context).push(
          //                               MaterialPageRoute(
          //                                   builder: (context) => OrderDetail(
          //                                       totalprice: int.parse(
          //                                           _CartController.total
          //                                               .toString()),
          //                                       ItemLength:
          //                                           _CartController.ItemLength,
          //                                       ItemPrice:
          //                                           _CartController.ItemPrice,
          //                                       phone: widget.phone,
          //                                       addr: widget.addr,
          //                                       tiff: widget.ind)))
          //                         }
          //                       else
          //                         {
          //                           null,
          //                         }
          //                     },
          //                 child: Text("Proceed to pay"))
          //           ],
          //         )),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildmenupage() {
    Matrix4 matrix = Matrix4.identity();
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: Color.fromARGB(255, 223, 228, 229),
            ),
          ),
        ],
      ),
    );
  }
}
