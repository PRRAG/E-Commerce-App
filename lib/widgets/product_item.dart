import 'dart:io';

import 'package:e_commerce_app/models/cart.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    var _itemCounter = Provider.of<Cart>(context).itemCount(widget.product.id);
    final size = MediaQuery.of(context).size;
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            color: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
          ),
        ],
      ),
      onDismissed: (_) {
        setState(() {
          _toggleFavorite();
        });
      },
      child: Dismissible(
        key: UniqueKey(),
        direction: widget.product.stock == 0
            ? DismissDirection.none
            : DismissDirection.up,
        background: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              color: Colors.blue[900],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ],
        ),
        onDismissed: (_) {
          print('added');
          setState(() {
            _updateQuantity('add');
          });
        },
        child: Card(
          elevation: 4,
          child: Container(
            color: Colors.white,
            child: GridTile(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildFavButton(),
                  Container(
                    height: size.height * 0.15,
                    child: Image.file(
                      File(widget.product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  _gab(height: size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            _gab(height: size.height * 0.002),
                            Text(widget.product.description),
                            _gab(height: size.height * 0.002),
                            Row(
                              children: [
                                Text('Price'),
                                _gab(width: size.width * 0.02),
                                if (widget.product.sale != 0)
                                  Text(
                                    ((widget.product.price *
                                            (1 - widget.product.sale / 100))
                                        .round()
                                        .toString()),
                                    style: TextStyle(color: Colors.green),
                                  ),
                                _gab(width: size.width * 0.02),
                                Text(
                                  widget.product.price.toString(),
                                  style: TextStyle(
                                    color: widget.product.sale != 0
                                        ? Colors.red
                                        : Colors.black,
                                    decoration: widget.product.sale != 0
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              footer: widget.product.stock == 0
                  ? null
                  : _buildGridTileBar(_itemCounter),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridTileBar(int _itemCounter) {
    return GridTileBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          _updateQuantity('remove');
        },
        icon: Icon(
          Icons.remove,
          color: Colors.black,
        ),
      ),
      title: Center(
        child: Text(
          _itemCounter.toString(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          _updateQuantity('add');
        },
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  InkWell _buildFavButton() {
    return InkWell(
      onTap: () {
        _toggleFavorite();
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Icon(Icons.favorite, color: Colors.white),
          widget.product.isFavorite
              ? Icon(Icons.favorite, color: Colors.red)
              : Icon(Icons.favorite_border, color: Colors.red),
        ],
      ),
    );
  }

  Container _gab({double? width, double? height}) {
    return Container(
      width: width ?? 0,
      height: height ?? 0,
    );
  }

  void _toggleFavorite() {
    setState(() {
      Provider.of<Products>(context, listen: false)
          .toggleFavoriteStatus(widget.product.id);
    });
  }

  void _updateQuantity(String operation) {
    var _itemCounter =
        Provider.of<Cart>(context, listen: false).itemCount(widget.product.id);
    switch (operation) {
      case 'add':
        if (_itemCounter < widget.product.stock) {
          setState(() {
            Provider.of<Cart>(context, listen: false).addItem(
                widget.product.id,
                widget.product.price * (1 - widget.product.sale / 100),
                widget.product.title);
          });
        }
        break;
      case 'remove':
        if (_itemCounter > 0) {
          setState(() {
            Provider.of<Cart>(context, listen: false)
                .removeSingleItem(widget.product.id);
          });
        }
        break;
      default:
    }
  }
}
