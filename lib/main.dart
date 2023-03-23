import 'package:client/screens/cart.dart';
import 'package:client/screens/homeScreen.dart';
import 'package:client/screens/phone_otp.dart';
import 'package:client/screens/phone_verify.dart';
import 'package:client/screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    initialRoute: 'splash',
    themeMode: ThemeMode.light,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.green,
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.green,
      colorSchemeSeed: Colors.green,
    ),
    debugShowCheckedModeBanner: false,
    routes: {
      'splash': (context) => const SplashScreen(),
      'home': (context) => MyHome(),
      'phone': (context) => const MyPhone(),
      'verify': (context) => const MyVerify(),
      'cart': (context) => const MyCart()
    },
  ));
}
