import 'dart:io';

import 'package:e_commerce_app/models/cart.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTile extends StatefulWidget {
  final CartItem cartItem;
  const CartTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  late Product _product;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _product = Provider.of<Products>(context, listen: false).items[
        Provider.of<Products>(context, listen: false)
            .items
            .indexWhere((element) => element.id == widget.cartItem.id)];
    var _itemCounter = Provider.of<Cart>(context).itemCount(widget.cartItem.id);
    return Card(
      elevation: 5,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Column(
            children: [
              ListTile(
                title: Text(
                  widget.cartItem.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  'Total:  ${widget.cartItem.quantity * widget.cartItem.price}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              _buildGridTileBar(_itemCounter)
            ],
          ),
          Card(
            elevation: 0,
            child: Container(
              width: size.width * 0.3,
              height: size.height * 0.15,
              child: Image.file(
                File(_product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTileBar(int _itemCounter) {
    return Card(
      elevation: 0,
      child: GridTileBar(
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                _updateQuantity('remove');
              },
              icon: Icon(
                Icons.remove,
                color: Colors.black,
                size: 30,
              ),
            ),
            Center(
              child: Text(
                _itemCounter.toString(),
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            IconButton(
              onPressed: () {
                _updateQuantity('add');
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(String operation) {
    var _itemCounter =
        Provider.of<Cart>(context, listen: false).itemCount(widget.cartItem.id);
    switch (operation) {
      case 'add':
        if (_itemCounter < _product.stock) {
          setState(() {
            Provider.of<Cart>(context, listen: false).addItem(_product.id,
                _product.price * (1 - _product.sale / 100), _product.title);
          });
        }
        break;
      case 'remove':
        if (_itemCounter > 0) {
          setState(() {
            Provider.of<Cart>(context, listen: false)
                .removeSingleItem(_product.id);
          });
        }
        break;
      default:
    }
  }
}
