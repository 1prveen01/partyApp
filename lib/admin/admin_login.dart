import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/admin/home_admin.dart';

import '../widget/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: const Color(0xff4A22BB),
          centerTitle: true,
          title: Text('Admin Panel', style: AppWidget.appBarTextStyle()),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              width: 350,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: userNameController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.person),
                          hintText: "Username",
                          hintStyle: const TextStyle(color: Color(0xff808080)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: Color(0xff4A22BB), width: 2))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: userPasswordController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.password),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Color(0xff808080)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 2)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: Color(0xff4A22BB), width: 2))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        loginAdmin();
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xff4A22BB),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: const Text('Login',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xffeaeaeaff))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      for (var result in snapshot.docs) {
        if (result.data()['username'] != userNameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("username not correct",
                style: TextStyle(
                  fontSize: 20,
                )),
          ));
        } else if (result.data()['password'] !=
            userPasswordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Password  not correct",
                style: TextStyle(
                  fontSize: 20,
                )),
          ));
        }
        else
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeAdmin()));
      }
    });
  }
}
