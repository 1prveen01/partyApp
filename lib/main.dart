import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter2/pages/bottomnav.dart';
import 'package:flutter2/services/constant.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
Stripe.publishableKey = publishableKey;

  await Firebase.initializeApp();

  runApp(const testingApp());
}

class testingApp extends StatelessWidget {
  const testingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "testingApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const Bottomnav(),
    );
  }
}


