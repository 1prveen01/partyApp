import 'package:flutter/material.dart';
import 'package:flutter2/admin/add_product.dart';
import 'package:flutter2/admin/all_orders.dart';

import '../widget/support_widget.dart';
class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff4A22BB),
        centerTitle: true,
        title: Text("Home Admin ", style: AppWidget.appBarTextStyle()),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
        ),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [


              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProduct()));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 50),
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xff4A22BB),
                      width: 2
                    )
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Add Products!", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                      ),)
                    ],
                  ),
                ),
              ),




              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AllOrders()));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 50),
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xff4A22BB),
                          width: 2
                      )
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("All Orders!", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                      ),)
                    ],
                  ),
                ),
              )





            ],
          ),
        ),
      )
    );
  }
}
