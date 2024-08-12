import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/services/database.dart';
import 'package:flutter2/widget/support_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameConrtroller  = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDetailController = TextEditingController();

  final ImagePicker _picker =  ImagePicker();
  File? selectedImage;
  Future getImage()async{
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {

    });
  }

  uploadImage() async{
    if(selectedImage!= null && productNameConrtroller!= ""){
      String addId = randomAlphaNumeric(10);
      Reference FirebaseStorageRef = FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = FirebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();


      String firstLetter = productNameConrtroller.text.substring(0,1).toUpperCase();

      Map<String,dynamic> addProduct ={
        "Name" : productNameConrtroller.text,
        "Image": downloadUrl,
        "SearchKey": firstLetter,
        "UpdatedName": productNameConrtroller.text.toUpperCase(),
        "Price": productPriceController.text,
        "Detail": productDetailController.text,
      };

      await databaseMethod().addProduct(addProduct, value!).then((value) async{
        await databaseMethod().addAllProducts(addProduct);
        selectedImage=null;
        productNameConrtroller.text = "";
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.purple,
            content: Text('Our product has been uploaded!',style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color(0xffeaeaeaff),
      ))));
      });
    }
  }
  String? value;
  final List<String> categoryItems = [
    'clothing',
    'cars',
    'dj',
    'decoration',
    'jewellery',
    'catering',
    'weddingCard',
    'makeupArtist'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Product', style: AppWidget.boldFeildTextStyle()),
          centerTitle: true,
          backgroundColor: const Color(0xff4A22BB),
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0,bottom: 20.0),
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upload the Product image',
                          style: AppWidget.lightFeildTextStyle()),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child:selectedImage ==null? GestureDetector(
                          onTap: (){
                            getImage();
                          },

                          child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1.5,
                                    color: const Color(0xff4A22BB),
                                  )),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 25,
                              )),
                        ):Center(
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(20),
                            child:Container(
                                height: 180,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1.5,
                                      color: const Color(0xff4A22BB),
                                    )),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(selectedImage!,fit:BoxFit.cover))),
                          ),
                        )
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Product Name',
                          style: AppWidget.lightFeildTextStyle()),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: <Widget>[

                           TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: productNameConrtroller,
                            decoration: InputDecoration(

                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xff4A22BB),
                                      width: 2,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 2,
                                    ))),
                           ) ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Product Price',
                          style: AppWidget.lightFeildTextStyle()),
                      const SizedBox(
                        height: 10,
                      ),

                      TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: productPriceController,
                        decoration: InputDecoration(

                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xff4A22BB),
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                  width: 2,
                                ))),
                      ),
                    const  SizedBox(
                        height: 20,
                      ),

                      Text('Product Detail',
                          style: AppWidget.lightFeildTextStyle()),
                      const SizedBox(
                        height: 10,
                      ),

                      TextField(
                        maxLines: 6,
                        style: const TextStyle(color: Colors.white),
                        controller: productDetailController,
                        decoration: InputDecoration(

                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xff4A22BB),
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                  width: 2,
                                ))),
                      ),


                      Text('Category', style: AppWidget.lightFeildTextStyle()),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(width: 2, color: const Color(0xff4A22BB))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: categoryItems
                                .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ))))
                                .toList(),
                            onChanged: ((value) => setState(() {
                                  this.value = value;
                                })),
                            dropdownColor: const Color(0xff4A22BB),
                            hint: const Text('Select Category',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                )),
                            icon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Colors.white,
                            ),
                            value: value,
                            iconSize: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: const Color(0xff4A22BB),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))),
                            onPressed: () {
                              uploadImage();
                            },
                            child: const Text(
                              'Add Product',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Color(0xffeaeaeaff)),
                            )),
                      ),
                    ],
                  ),
                ))));
  }
}
