import 'package:flutter/material.dart';
import 'package:search_test/product_page.dart';
import 'package:search_test/testing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const ProductPage(title: 'Product page'),
      home: ProductPage(title: 'demo app',),
    );
  }
}
