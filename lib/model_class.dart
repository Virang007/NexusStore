class model {
  List<Products>? products;

  model({this.products});

  model.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? name;
  int? price;
  int? discount;
  double? rating;
  int? stock;
  String? category;
  String? image;

  Products(
      {this.id,
      this.name,
      this.price,
      this.discount,
      this.rating,
      this.stock,
      this.category,
      this.image});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    discount = json['discount'];
    rating = json['rating'];
    stock = json['stock'];
    category = json['category'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['rating'] = this.rating;
    data['stock'] = this.stock;
    data['category'] = this.category;
    data['image'] = this.image;
    return data;
  }
}
