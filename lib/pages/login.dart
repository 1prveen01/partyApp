import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter2/pages/bottomnav.dart';
import 'package:flutter2/pages/homePage.dart';
import 'package:flutter2/pages/registerPage.dart';
import 'package:flutter2/widget/support_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "",password = "";
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  userLogin() async{
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Bottomnav()));
    } on FirebaseAuthException catch(e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No user found for that email!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffeaeaeaff),
                ))));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
            content: Text("Wrong password Entered!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffeaeaeaff),
                ))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xff4A22BB),
            centerTitle: true,
            title: Text('Login Page', style: AppWidget.appBarTextStyle())),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            )),
            child: Center(
              child: SizedBox(
                width: 350,
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter your Email";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.email),
                            hintText: "Enter your email",
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
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Password";
                          } else {
                            return null;
                          }
                        },

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
                        height: 12,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Forgot Password?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if(_formkey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                          }
                          userLogin();
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
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            child: const Text("Register here!",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 15)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const registerPage()));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
