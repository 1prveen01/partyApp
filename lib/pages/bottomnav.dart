import 'package:flutter/material.dart';
import 'package:flutter2/pages/homePage.dart';
import 'package:flutter2/pages/order.dart';
import 'package:flutter2/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  late List<Widget> pages;

  late homePage Home;
  late OrderPage orderPage;
  late ProfilePage profilepage;
  int currentTabIndex = 0;

  @override
  void initState() {
    Home = const homePage();
    orderPage = const OrderPage();
    profilepage = const ProfilePage();

    pages = [Home, orderPage, profilepage];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
          height: 40,
          backgroundColor: Colors.transparent,
          color: const Color(0xff4A22BB),
          animationDuration: const Duration(milliseconds: 400),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: const [
            Icon(Icons.home_outlined, color: Colors.white),
            Icon(Icons.shopping_bag_outlined, color: Colors.white),
            Icon(Icons.person_2_outlined, color: Colors.white),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
