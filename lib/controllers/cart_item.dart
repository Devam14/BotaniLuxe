import 'dart:ffi';
import 'dart:ui';

import 'package:client/controllers/product_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class cartItems extends StatefulWidget {
  const cartItems({required this.ind, required this.price, required this.name});
  final String? ind;
  final String? price;
  final String name;

  @override
  State<cartItems> createState() => _cartItemsState();
}

class _cartItemsState extends State<cartItems> {
  // ignore: non_constant_identifier_names
  final CartController _CartController = Get.put(CartController());
  var counter = 0.obs;
  Map freq = Map().obs;

  @override
  void initState() {
    // checkForCounterValue();

    super.initState();
  }

  checkForCounterValue() async {
    setState(() {
      if (_CartController.ItemLength[widget.name] == null) {
        // counter = 0;
      } else {
        counter = _CartController.ItemLength[widget.name];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 65),
      child: SizedBox(
        width: 150,
        height: 35,
        child: Obx(() => Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    // ignore: unnecessary_new
                    new IconButton(
                        onPressed: () {
                          if (counter != 0) {
                            setState(() {
                              counter--;
                              freq[widget.name] = counter;
                              // setCounterValue();
                              _CartController.decrement(
                                  widget.ind,
                                  int.parse(widget.price.toString()),
                                  widget.name);
                            });
                          } else {
                            null;
                          }
                        },
                        icon: new Icon(
                          Icons.remove,
                          color: Colors.amber,
                        )),
                    new Container(),
                    new Text(
                      // freq[widget.name] == null
                      //     ? "0"
                      //     : freq[widget.name].toString(),
                      "${counter}",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    new IconButton(
                        onPressed: () {
                          if (counter < 5) {
                            setState(() {
                              counter++;
                              freq[widget.name] = counter;
                              // setCounterValue();
                              _CartController.increment(
                                  widget.ind,
                                  int.parse(widget.price.toString()),
                                  widget.name);
                            });
                          } else {
                            null;
                          }
                        },
                        icon: new Icon(
                          Icons.add,
                          color: Colors.amber,
                        ))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
