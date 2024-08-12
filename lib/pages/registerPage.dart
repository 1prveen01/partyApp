import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/pages/bottomnav.dart';
import 'package:flutter2/pages/homePage.dart';
import 'package:flutter2/pages/login.dart';
import 'package:flutter2/main.dart';
import 'package:flutter2/services/database.dart';
import 'package:flutter2/services/shared_prefrences.dart';
import 'package:flutter2/widget/support_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  String? name, email, password, cpassword;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

registration() async{
  if(password != null && name != null && email != null && cpassword != null) {
    try{
    UserCredential userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.white,
        content : Text("Registered Successfully!",style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color(0xffeaeaeaff),
    ))));
    String Id = randomAlphaNumeric(10);

    await SharedPreferencesHelper().saveUserEmail(emailController.text);
    await SharedPreferencesHelper().saveUserId(Id);
    await SharedPreferencesHelper().saveUserName(nameController.text);
    await SharedPreferencesHelper().saveUserImage("https://firebasestorage.googleapis.com/v0/b/testing-10c32.appspot.com/o/userImage%2Ff.png?alt=media&token=a25e1b93-3986-4627-9c59-3f5c5afaa849");

    Map<String,dynamic> userInfoMap={
      "Name": nameController.text,
      "Email": emailController.text,
      "Id": Id,
      "Image": "https://firebasestorage.googleapis.com/v0/b/testing-10c32.appspot.com/o/userImage%2Ff.png?alt=media&token=a25e1b93-3986-4627-9c59-3f5c5afaa849"
    };
    await databaseMethod().addUserDetail(userInfoMap, Id);
     Navigator.push(context, MaterialPageRoute(builder: (context) => const Bottomnav()));


    }
  on FirebaseException catch(e){
    if(e.code == "weak-password"){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content : Text("Password provided is too weak!",style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Color(0xffeaeaeaff),
      ))));
    }

    else if(e.code == "email-already-in-use"){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content : Text("Account Already exists!",style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Color(0xffeaeaeaff),
      ))));
      
    }
  }
  }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff4A22BB),
        centerTitle: true,
        title: Text('Sign Up', style: AppWidget.appBarTextStyle()
        ),
        automaticallyImplyLeading: false,
      ),
      body:

      Container(

        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/bg.png'
              ), fit: BoxFit.cover,
            )
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),

            width: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [


                    TextFormField(
                    validator : (value)
                {
                if(value == null || value.isEmpty){
                return "Please Enter Your Name";
                }
                else{
                return null;
                }
                },

                controller: nameController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.person),
                    hintText: "Your Name",
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your Email";
                  }
                  else {
                    return null;
                  }
                },
                controller: emailController,
                style: const TextStyle(
                color: Colors.white,
                            ),

                            decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.email),
                  hintText: "Your Email",
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
                            validator : (value){
                if(value == null || value.isEmpty){
                  return "Please Enter Your Name";
                }
                else{
                  return null;
                }
                            },
                            controller: passwordController,
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

                          TextFormField(
                            controller: cpasswordController,

                            style: const TextStyle(
                color: Colors.white,
                            ),

                            decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.password),
                  hintText: "Confirm Password",
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
                            height: 45,
                          ),

                          ElevatedButton(onPressed: () {
                            if(_formkey.currentState!.validate()) {
                              setState(() {
                                name = nameController.text;
                                password = passwordController.text;
                                email = emailController.text;
                                cpassword = cpasswordController.text;
                              });
                            }

                              registration();
                          },
                            style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color(0xff4A22BB),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14))),
                            child: const Text('Sign Up', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xffeaeaeaff)
                            )),
                          ),
                          const SizedBox(
                            height: 12,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                const Text("Already have an account?",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(
                  width: 8,
                ),
                InkWell(

                    child: const Text("Login here!", style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 15,
                    )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Login()));
                    }
                )
                            ],
                          )
                          ],
                        ),
              ),
      ),

    ),

    )
    ,
    )
    );
  }
}
