import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  String IpfsUrl = "";
  Future<void> uploadToPinata() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    // Replace YOUR_PINATA_API_KEY and YOUR_PINATA_SECRET_API_KEY with your API keys
    final uri = Uri.parse('https://api.pinata.cloud/pinning/pinFileToIPFS');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'pinata_api_key': '4b195cf7c465832b6caa',
        'pinata_secret_api_key':
            '2fedab0a6381efcc5347e2b5d05c4288de16e45254beed845d23f4be317a5e67'
      })
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final decodedData = jsonDecode(responseData);

      final ipfsUrl = decodedData['IpfsHash'];
      setState(() {
        IpfsUrl = ipfsUrl;
      });
      print('Image uploaded to Pinata. IPFS URL: $ipfsUrl');
    } else {
      print(
          'Error uploading image to Pinata. Status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    uploadToPinata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController desc = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dour Dorcel',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                  Text(
                    '#324',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffA9ADB7),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              IpfsUrl == ""
                  ? CircularProgressIndicator.adaptive()
                  : Container(
                      height: 299,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://gateway.pinata.cloud/ipfs/${IpfsUrl}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 24,
              ),
              const SizedBox(
                height: 27,
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('About NFT',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black)),
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: desc,
                maxLength: 80,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(
                height: 43,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection("posts").add({
                      "post_desc": desc.text.toString(),
                      "post_img":
                          "https://gateway.pinata.cloud/ipfs/${IpfsUrl}",
                      "post_username": "pratham",
                      "post_userimg":
                          "https://gateway.pinata.cloud/ipfs/QmQpDi5UQzFuRmhTqddQefTHTw3nBuiK8jBt7P6DWaayww"
                    });
                  },
                  child: Text("Post")),
              const SizedBox(
                height: 43,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
