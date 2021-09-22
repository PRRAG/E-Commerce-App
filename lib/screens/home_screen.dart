import 'package:badges/badges.dart';
import 'package:e_commerce_app/models/cart.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showFavs = false;
  double _total = 0;
  int _cartCount = 0;
  int _favCount = 0;

  @override
  void didChangeDependencies() {
    _total = Provider.of<Cart>(context).totalAmount;
    _cartCount = Provider.of<Cart>(context).totalCount;
    _favCount = Provider.of<Products>(context).favoriteCount;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _productData = Provider.of<Products>(context).favoriteItems.length;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'E-Commerce App',
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed('/add_product');
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: _buildCartOverView(context),
            ),
            Expanded(
              flex: 12,
              child: Row(children: [
                Expanded(
                  flex: 15,
                  child: ProductsGrid(showFavs: _showFavs),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showFavs = !_showFavs;
                          if (_showFavs && _productData == 0) {
                            _showFavs = !_showFavs;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.black,
                                content: Text('No Favorite Items'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        });
                      },
                      child: Badge(
                        badgeColor: Colors.white,
                        position: BadgePosition.bottomEnd(bottom: -5, end: -6),
                        borderRadius: BorderRadius.circular(5),
                        badgeContent: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text('$_favCount'),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildCartOverView(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/cart');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total: $_total',
            style: TextStyle(fontSize: 16),
          ),
          Container(
            width: 25,
          ),
          Badge(
            badgeColor: Colors.white,
            borderRadius: BorderRadius.circular(5),
            badgeContent: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text('$_cartCount'),
            ),
            position: BadgePosition.bottomEnd(bottom: -4, end: -2),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.blue[900],
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
