import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid({Key? key, required this.showFavs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _productData = Provider.of<Products>(context);
    final _products =
        showFavs ? _productData.favoriteItems : _productData.items;
    return showFavs && _products.length == 0
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No Favorites',
                style: TextStyle(fontSize: 30),
              ),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: _products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: _products[i],
                  child: ProductItem(product: _products[i]),
                ));
  }
}
