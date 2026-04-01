import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search_test/cart.dart';
import 'package:search_test/model_class.dart';
import 'package:search_test/showing_full_producat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  final String title;
  const ProductPage({super.key, required this.title});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController seacrchController = TextEditingController();
  final FocusNode inputFocus = FocusNode();
  List<Products> productsList = [];
  List<Products> searchList = [];
  List<Products> cart = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    var url = Uri.parse("https://mockapi.me/custom/m1");
    var repose = await http.get(url);

    if (repose.statusCode == 200) {
      final data = jsonDecode(repose.body);
      model m = model.fromJson(data);
      setState(() {
        productsList = m.products ?? [];
        searchList = productsList;
      });
    }
  }

  // search products
  void searchProduct(String query) {
    if (query.isEmpty) {
      setState(() {
        searchList = productsList;
      });
      return;
    }

    final result = productsList.where((e) {
      return e.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchList = result;
    });
  }

  Future<void> save(Products newproduct) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cartjson = prefs.getStringList("cart") ?? [];

    List<Products> cart = cartjson.map((e) {
      return Products.fromJson(jsonDecode(e));
    }).toList();

    cart.add(newproduct);

    List<String> update = cart.map((e) {
      return jsonEncode({"id": e.id, "name": e.name});
    }).toList();

    await prefs.setStringList("cart", update);
  }

  @override
void dispose() {
  inputFocus.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Cart(cart: cart)),
              );
            },
            icon: Icon(Icons.card_travel, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: TextField(
                focusNode: inputFocus,

                controller: seacrchController,
                onChanged: searchProduct,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hint: Text("search any Products"),
                  border: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  final p = searchList[index];
                  final prices = p.price;
                  return InkWell(
                    onTap: () {
                   inputFocus.unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShowingFullProducat(product: p),
                        ),
                      );
                      seacrchController.clear();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              p.image ?? '',
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Text(p.name ?? " "),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(p.price.toString()),
                              SizedBox(width: 10),
                              Text(
                                style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                p.discount.toString(),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              overlayColor: Colors.amber,
                              foregroundColor: Colors.white,
                              surfaceTintColor: Colors.yellow,
                            ),
                            onPressed: () async {
                              setState(() {
                                cart.add(p);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("add to cart")),
                                );
                              });
                              await save(p);
                            },
                            child: Text(
                              "Add to cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
