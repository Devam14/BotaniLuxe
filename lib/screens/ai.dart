import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Ai extends StatefulWidget {
  const Ai({super.key});

  @override
  State<Ai> createState() => _AiState();
}

class _AiState extends State<Ai> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A.I."),
      ),
      body: Center(
        child: Image.network(
            "https://gateway.pinata.cloud/ipfs/QmNxjxy29wHbENJebcjJJ11YmMURW21y2Rj2G9zKHfgJMo"),
      ),
    );
  }
}
