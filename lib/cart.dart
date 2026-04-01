import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_test/model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  final List<Products> cart;
  const Cart({super.key, required this.cart});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Products> cartItems = [];

  @override
  void initState() {
    // TODO: implement initStatecartItems
    super.initState();
    getload();
  }

  void getload() async {
    final data = await getsave();
    setState(() {
      cartItems = data;
    });
  }

  Future<List<Products>> getsave() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList("cart");

    if (cartJson == null) return [];
    return cartJson.map((e) {
      final data = jsonDecode(e);
      return Products.fromJson(data);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cp = cartItems[index];
                  return Text("${cp.name}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
