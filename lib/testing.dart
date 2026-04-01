import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_test/model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  List<Products> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load() async {
    final data = await getdata();

    setState(() {
      items = data;
    });
  }

  Future<List<Products>> getdata() async {
    final prefs = await SharedPreferences.getInstance();

    // load data
    List<String>? cartjson = prefs.getStringList("cart");

    if (cartjson == null) return [];

    return cartjson!.map((e) {
      final data = jsonDecode(e);
      return Products.fromJson(data);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Text("data");
          },
        ),
      ),
    );
  }
}
