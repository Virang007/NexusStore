import 'package:flutter/material.dart';
import 'package:search_test/model_class.dart';

class ShowingFullProducat extends StatefulWidget {
  final Products product;
  const ShowingFullProducat({super.key, required this.product});

  @override
  State<ShowingFullProducat> createState() => _ShowingFullProducatState();
}

class _ShowingFullProducatState extends State<ShowingFullProducat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.product.image ?? "",
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
              SizedBox(height: 20),
              Text(widget.product.name ?? "", style: TextStyle(fontSize: 20)),
              Row(
                children: [
                  Text(
                    widget.product.price.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Off ${widget.product.discount.toString()}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Text(
                widget.product.rating.toString(),
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.product.category ?? "",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
