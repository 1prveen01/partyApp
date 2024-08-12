import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/pages/login.dart';
import 'package:flutter2/pages/registerPage.dart';
import 'package:flutter2/services/auth.dart';
import 'package:flutter2/services/shared_prefrences.dart';
import 'package:flutter2/widget/support_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  String? name, image, email;

  getthesharedpref() async {
    name = await SharedPreferencesHelper().getUserName();
    image = await SharedPreferencesHelper().getUserImage();
    email = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadImage();
    setState(() {});
  }

  uploadImage() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference FirebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = FirebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();

      await SharedPreferencesHelper().saveUserImage(downloadUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: const Color(0xff4A22BB),
          centerTitle: true,
          title: Text("Profile", style: AppWidget.appBarTextStyle()),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
            ),
            child: name == null
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                        selectedImage != null
                            ? GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Center(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.file(selectedImage!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover),
                                )),
                              )
                            : GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Center(
                                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(image!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover),
                                )),
                              ),
                        Container(
                            margin:
                                const EdgeInsets.only(right: 20, left: 20, top: 50),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xff4A22BB),
                                  width: 2,
                                )),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Name",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          )),
                                      Text(name!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 25,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            margin:
                                const EdgeInsets.only(right: 20, left: 20, top: 30),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xff4A22BB),
                                  width: 2,
                                )),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Email",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          )),
                                      Text(email!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 25,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        GestureDetector(
                          onTap: ()async{
                              await AuthMethods().logOut().then((value){
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                              });
                          },
                          child: SizedBox(
                            height: 100,
                            child: Container(
                                margin:
                                    const EdgeInsets.only(right: 20, left: 20, top: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xff4A22BB),
                                      width: 2,
                                    )),
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Logout",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 25,
                                              )),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 40,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),

                        GestureDetector(
                          onTap: ()async{
                            await AuthMethods().deleteUser().then((value){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const registerPage()));
                            });
                          },
                          child: SizedBox(
                            height: 100,
                            child: Container(
                                margin:
                                const EdgeInsets.only(right: 20, left: 20, top: 20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xff4A22BB),
                                      width: 2,
                                    )),
                                child: Container(
                                  padding:
                                  const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                                  child: const Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text("Delete Account!",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 25,
                                              )),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 40,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),


                      ],
                    ))));
  }
}
