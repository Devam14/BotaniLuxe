import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlantDetails extends StatefulWidget {
  String para1 = "";
  String para2 = "";
  String para_img = "";
  String plant_name = "";
  PlantDetails(
      {super.key,
      required this.para1,
      required this.para2,
      required this.para_img,
      required this.plant_name});

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant_name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 299,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.para_img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(widget.para1),
            SizedBox(
              height: 5,
            ),
            Text(widget.para2)
          ],
        ),
      ),
    );
  }
}
