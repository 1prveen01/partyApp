import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter2/services/database.dart';
import 'package:flutter2/services/shared_prefrences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import '../services/constant.dart';

class ProductDetail extends StatefulWidget {
  final String image, name, price, detail;

  const ProductDetail(
      {super.key,
      required this.name,
      required this.image,
      required this.price,
      required this.detail});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String?name, email,image;

  getTheSharedPref()async{
    name = await SharedPreferencesHelper().getUserName();
    email = await SharedPreferencesHelper().getUserEmail();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {

    });
  }
  onTheLoad()async{
    await getTheSharedPref();
    setState(() {

    });
  }
  @override
  void initState() {

    super.initState();
    onTheLoad();
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 26,
          ),
          backgroundColor: const Color(0xff4A22BB),
          automaticallyImplyLeading: true,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            )),
            child: Container(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Stack(children: [
                        Align(
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: const Color(0xff4A22BB)),
                              ),
                              child: Image.network(
                                widget.image,
                                width: 400,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          decoration: const BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Color(0xff4a22bb), width: 1),
                                right: BorderSide(
                                    color: Color(0xff4a22bb), width: 1),
                                bottom: BorderSide(
                                    color: Color(0xff4a22bb), width: 1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      )),
                                  Text("₹${widget.price}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.detail,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Color(0xffeaeaeaff),
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    makePayment(widget.price);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(50),
                                      backgroundColor: const Color(0xff4A22BB),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  child: const Text("Buy Now",
                                      style: TextStyle(
                                          color: Color(0xffeaeaeaff))))
                            ],
                          )),
                    )
                  ],
                ))));
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Aman'))
          .then((value) => {});

      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String,dynamic> orderInfoMap = {
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": email,
          "Image": image,
          "ProductImage": widget.image,
          "Status": "On the way!"
        };
        await databaseMethod().orderDetails(orderInfoMap);
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          Text("Payment Successful")
                        ],
                      )
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error is : --> $error $stackTrace");
      });
    } on StripeException catch (e) {
      print("Error is : --> $e");
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled!"),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
      body: body);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final int parsedAmount = int.parse(amount);
    final int calculatedAmount = parsedAmount * 100;
    return calculatedAmount.toString();
  }
}
