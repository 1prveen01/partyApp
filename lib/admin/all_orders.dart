import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/services/database.dart';
import 'package:flutter2/widget/support_widget.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? allOrderStream;

  getontheload() async {
    allOrderStream = await databaseMethod().allOrders();
    setState(() {

    });
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
        stream: allOrderStream,
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
                        padding: const EdgeInsets.only(right: 20),
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
                                width: 120, height: 130, fit: BoxFit.cover),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("Name : " + ds["Name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    )),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Text(ds["Email"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,

                                      )),
                                ),
                                Text(ds["Product"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    )),

                                Row(
                                  children: [
                                    Text("₹ " + ds["Price"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        )),

                                    const SizedBox(
                                      width: 20,
                                    ),

                                    ElevatedButton(onPressed: ()async{
await databaseMethod().updateStatus(ds.id);
setState(() {

});
                                    }, style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff4A22BB),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12)
                                        )
                                    )
                                        ,child: const Text("Done",style: TextStyle(
                                          color:Colors.white,
                                        ),))
                                  ],
                                ),




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
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'All Orders',
            style: AppWidget.appBarTextStyle(),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff4A22BB),
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
                  Expanded(child: allOrders())
                ],
              ),
            )));
  }
}
