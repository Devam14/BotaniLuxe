import 'package:client/controllers/product_controller.dart';
import 'package:client/screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 238, 252, 240),
        appBar: AppBar(
          title: Text(
            "My Cart",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            Obx(() => SingleChildScrollView(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartController.ItemLength.length,
                      itemBuilder: ((context, index) {
                        var keys = cartController.ItemLength.keys.toList();
                        return cartController.ItemLength[keys[index]] > 0
                            ? Container(
                                height: 50,
                                margin: new EdgeInsets.only(
                                    left: 10.0,
                                    bottom: 5.0,
                                    top: 10.0,
                                    right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        keys[index].toString(),
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "x ${cartController.ItemLength[keys[index]].toString()}",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            var price_key = cartController
                                                .ItemLength.keys
                                                .toList();

                                            print(price_key);
                                            print(index);
                                            cartController.decrement(
                                                index.toString(),
                                                1,
                                                keys[index].toString());
                                            // print(cartController.currItems);
                                            // print(cartController.ItemPrice);
                                          },
                                          icon: Icon(
                                            Icons
                                                .remove_circle_outline_outlined,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      })),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 555.0, left: 12.0),
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 206, 239, 211),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 216, 247, 221),
                        blurRadius: 5.0,
                        offset: Offset(0, 5)),
                  ],
                ),
                child: Obx(() => Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Total Price:- " +
                              cartController.total.value.toString() +
                              " 5ire",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.green),
                            onPressed: () => {
                                  if (cartController.total.value > 0)
                                    {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailss()))
                                    }
                                  else
                                    {
                                      null,
                                    }
                                },
                            child: Text(
                              "Proceed to pay",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )),
              ),
            ),
          ],
        ));
  }
}
