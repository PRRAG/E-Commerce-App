import 'package:e_commerce_app/models/cart.dart';
import 'package:e_commerce_app/widgets/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final _cartData = Provider.of<Cart>(context);
    var _cart = _cartData.items;
    var _total = _cartData.totalAmount;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _cart.isEmpty
          ? _emptyCart()
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Total: $_total',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: ListView.builder(
                        itemCount: _cart.length,
                        itemBuilder: (context, i) => CartTile(
                              cartItem: _cart.values.toList()[i],
                            )),
                  )
                ],
              ),
            ),
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.remove_shopping_cart,
            size: 100,
            color: Colors.grey,
          ),
          Container(
            height: 20,
          ),
          Text(
            'Empty Cart!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
