import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/services/database.dart';

import '../services/shared_prefrences.dart';
import '../widget/support_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? email;

  getTheSharedPref() async {
    email = await SharedPreferencesHelper().getUserEmail();
    setState(() {});
  }

  Stream? orderStream;

  getontheload() async {
    await getTheSharedPref();
    orderStream = await databaseMethod().getOrders(email!);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                        margin: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 10),
                        padding: const EdgeInsets.only(right: 40),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: const Color(0xff4A22BB),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(ds["ProductImage"],
                                width: 180, height: 180, fit: BoxFit.cover),
                            const Spacer(),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(ds["Product"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                    )),

                                Text("₹" + ds["Price"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    )),

                                Text("Status : "+ ds["Status"],style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ))
                              ],
                            ),
                          ],
                        ));
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff4A22BB),
          centerTitle: true,
          title: Text("Orders", style: AppWidget.appBarTextStyle()),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            )),
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(child: allOrders()),
                  ],
                ))));
  }
}
