import 'package:flutter/widgets.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  double sale;
  int stock;
  String image;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sale,
    required this.stock,
    required this.image,
    this.isFavorite = false,
  });
}

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: UniqueKey().toString(),
    //   title: 'Dog',
    //   description: 'A very Funny dog',
    //   price: 20000,
    //   sale: 0,
    //   stock: 5,
    //   image: 'assets/dog.jpg',
    // ),
    // Product(
    //   id: UniqueKey().toString(),
    //   title: 'Dog2',
    //   description: 'A very Funny dog',
    //   price: 2000,
    //   sale: 10,
    //   stock: 5,
    //   image: 'assets/dog.jpg',
    // ),
  ];

  List<Product> get items {
    return _items;
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  int get favoriteCount {
    return _items
        .where((prodItem) => prodItem.isFavorite == true)
        .toList()
        .length;
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void toggleFavoriteStatus(String id) {
    int index = _items.indexWhere((element) => element.id == id);
    _items[index].isFavorite = !_items[index].isFavorite;
    notifyListeners();
  }
}
