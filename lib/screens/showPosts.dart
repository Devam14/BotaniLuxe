import 'package:client/screens/addPosts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShowPosts extends StatefulWidget {
  const ShowPosts({super.key});

  @override
  State<ShowPosts> createState() => _ShowPostsState();
}

class _ShowPostsState extends State<ShowPosts> {
  var postt = FirebaseFirestore.instance.collection("posts");
  List<Map<String, dynamic>> posts = [];
  fetchPosts() async {
    print("Helloooo");
    var data = await postt.get();

    List<Map<String, dynamic>> templist = [];
    data.docs.forEach((element) {
      templist.add(element.data());
    });
    setState(() {
      print(templist);
      posts = templist;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchPosts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddPosts()));
          },
          child: Icon(Icons.add_a_photo),
        ),
        backgroundColor: Color.fromARGB(255, 215, 248, 216),
        appBar: AppBar(
          title: Text(
            "Feeds",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green[700],
        ),
        body: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 214, 233, 206),
                      border: Border.all(width: 1, color: Colors.white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(posts[index]["post_userimg"]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            posts[index]["post_username"],
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      ),
                      Divider(thickness: 2),
                      Container(
                        decoration: BoxDecoration(color: Colors.black),
                        height: 250,
                        width: 350,
                        child: Image.network(
                          posts[index]["post_img"],
                          // fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            posts[index]["post_desc"],
                            style: TextStyle(color: Colors.green),
                          ))
                    ],
                  ),
                );
              })
        ])));
  }
}
