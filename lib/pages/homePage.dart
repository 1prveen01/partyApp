import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/pages/category_products.dart';
import 'package:flutter2/pages/product_detail.dart';
import 'package:flutter2/services/database.dart';
import 'package:flutter2/services/shared_prefrences.dart';
import 'package:flutter2/widget/support_widget.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController searchController = TextEditingController();
  bool search = false;
  List categories = [
    "assets/images/cars.png",
    "assets/images/decoration.png",
    "assets/images/dj.jpg",
    "assets/images/makeupArtist2.jpg",
    "assets/images/weddingCard.png",
    "assets/images/catering.jpg",
    "assets/images/jwellery.png",
    "assets/images/clothing.png",
  ];

  List categoryName = [
    "cars",
    "decoration",
    "dj",
    "makeupArtist",
    "weddingCard",
    "catering",
    "jewellery",
    "clothing",
  ];

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    setState(() {
      search = true;
    });

    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      databaseMethod().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      for (var element in queryResultSet) {
        if (element["UpdatedName"].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferencesHelper().getUserName();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: name == null
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                )),
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 20, top: 30, right: 20, bottom: 0),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hey, ${name!}',
                                    style: AppWidget.boldFeildTextStyle()),
                                Text('Good Morning',
                                    style: AppWidget.lightFeildTextStyle()),
                              ],
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(image!,
                                    height: 68, width: 68, fit: BoxFit.cover))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 55,
                          child: TextField(
                            controller: searchController,
                              onChanged: (value) {
                                initiateSearch(value.toUpperCase());
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: AppWidget.lightFeildTextStyle(),
                                prefixIcon: search? GestureDetector(
                                    onTap: (){
                                      search: false;

                                      tempSearchStore = [];
                                      queryResultSet = [];
                                      searchController.text = "";
                                      setState(() {
                                      });
                                    }, child: const Icon(Icons.close)): const Icon(Icons.search,
                                    color: Colors.black),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        search
                            ? ListView(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                primary: false,
                                shrinkWrap: true,
                                children: tempSearchStore.map((element) {
                                  return buildResultCard(element);
                                }).toList(),
                              )
                            : Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Categories",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                      Text("see all",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 160,
                                          padding: const EdgeInsets.all(15),
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff4A22BB),
                                            border: Border.all(
                                                color: const Color(0xff4A22BB),
                                                width: 3),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Center(
                                              child: Text('All',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20)))),
                                      Expanded(
                                        child: SizedBox(
                                            height: 160,
                                            child: ListView.builder(
                                                itemCount: categories.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return CategoryTile(
                                                      image: categories[index],
                                                      name:
                                                          categoryName[index]);
                                                })),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("All Products",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                      Text("see all",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                      height: 230,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  width: 3,
                                                  color:
                                                      const Color(0xff4A22BB)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide(
                                                    color: Color(0xff4A22BB),
                                                    width: 3,
                                                  ))),
                                                  child: Image.asset(
                                                      "assets/images/makeupArtist.png",
                                                      height: 160,
                                                      width: 160,
                                                      fit: BoxFit.cover),
                                                ),
                                                const Text("Killer Makeup",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("₹1000",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                            )),
                                                        const SizedBox(
                                                          width: 40,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: const Icon(
                                                              Icons.add,
                                                              color: Color(
                                                                  0xff4A22BB)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  width: 3,
                                                  color:
                                                      const Color(0xff4A22BB)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide(
                                                    color: Color(0xff4A22BB),
                                                    width: 3,
                                                  ))),
                                                  child: Image.asset(
                                                      "assets/images/dj2.jpg",
                                                      height: 160,
                                                      width: 160,
                                                      fit: BoxFit.cover),
                                                ),
                                                const Text("Raja Dj Sound",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("₹7000",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                            )),
                                                        const SizedBox(
                                                          width: 40,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: const Icon(
                                                              Icons.add,
                                                              color: Color(
                                                                  0xff4A22BB)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  width: 3,
                                                  color:
                                                      const Color(0xff4A22BB)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide(
                                                    color: Color(0xff4A22BB),
                                                    width: 3,
                                                  ))),
                                                  child: Image.asset(
                                                      "assets/images/cars2.jpg",
                                                      height: 160,
                                                      width: 160,
                                                      fit: BoxFit.cover),
                                                ),
                                                const Text("Aman CarServices",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("₹4000",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                            )),
                                                        const SizedBox(
                                                          width: 40,
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: const Icon(
                                                              Icons.add,
                                                              color: Color(
                                                                  0xff4A22BB)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                      ],
                    ),
                  ),
                )));
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(name: data["Name"], image: data["Image"], price: data["Price"], detail: data["Details"])));
      },
      child: Container(
        margin : const EdgeInsets.only(
          bottom: 15,
        ),
        padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xff4A22BB),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12)
          ),
          height: 100,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(data["Image"],
                    height: 70, width: 70, fit: BoxFit.cover),
              ),
      
              const SizedBox(
                width: 15,
              ),
              Text(
                data["Name"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image, name;

  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProducts(category: name)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff4A22BB), width: 3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2, color: Color(0xffff4a22bb)))),
                child: Image.asset(image,
                    width: 120, height: 120, fit: BoxFit.cover)),
            const SizedBox(
              height: 6,
            ),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
