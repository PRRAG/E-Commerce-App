import 'dart:io';

import 'package:e_commerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ImagePicker _picker = ImagePicker();
  XFile? _image;

  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _titleTextController = TextEditingController();
  final _descFocusNode = FocusNode();
  final _descTextController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _priceTextController = TextEditingController();
  final _saleFocusNode = FocusNode();
  final _saleTextController = TextEditingController();
  final _stockFocusNode = FocusNode();
  final _stockTextController = TextEditingController();

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleTextController.dispose();
    _descFocusNode.dispose();
    _descTextController.dispose();
    _priceFocusNode.dispose();
    _priceTextController.dispose();
    super.dispose();
  }

  void _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await _picker
                            .pickImage(source: ImageSource.gallery)
                            .then((value) {
                          setState(() {
                            _image = value;
                          });
                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await _picker
                          .pickImage(source: ImageSource.camera)
                          .then((value) {
                        setState(() {
                          _image = value;
                        });
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Choose Image'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<Products>(context, listen: false).addProduct(
        Product(
            id: UniqueKey().toString(),
            title: _titleTextController.text,
            description: _descTextController.text,
            price: double.parse(_priceTextController.text),
            sale: _saleTextController.text.isEmpty
                ? 0
                : double.parse(_saleTextController.text),
            stock: int.parse(_stockTextController.text),
            image: _image!.path),
      );
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Add Product',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.8,
                            child: _buildTextFormField(
                                label: 'title',
                                textController: _titleTextController,
                                focusNode: _titleFocusNode,
                                nextFocusNode: _descFocusNode,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid name';
                                  }
                                  return null;
                                }),
                          ),
                          Container(
                            width: size.width * 0.8,
                            child: _buildTextFormField(
                              label: 'Description',
                              textController: _descTextController,
                              focusNode: _descFocusNode,
                              nextFocusNode: _priceFocusNode,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a description.';
                                }
                                if (value.length < 10) {
                                  return 'Should be at least 10 characters long.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.4,
                                child: _buildTextFormField(
                                  label: 'Price',
                                  textController: _priceTextController,
                                  focusNode: _priceFocusNode,
                                  nextFocusNode: _saleFocusNode,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a price.';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number.';
                                    }
                                    if (double.parse(value) <= 0) {
                                      return 'Please enter a number greater than zero.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                width: size.width * 0.4,
                                child: _buildTextFormField(
                                  label: 'Sale(%)-Optional',
                                  textController: _saleTextController,
                                  focusNode: _saleFocusNode,
                                  nextFocusNode: _stockFocusNode,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: size.width * 0.8,
                            child: _buildTextFormField(
                              label: 'Stock',
                              textController: _stockTextController,
                              focusNode: _stockFocusNode,
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter quantity in stock.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number.';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'Please enter a number greater than zero.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                child: ElevatedButton(
                                  child: Text('Add Image'),
                                  onPressed: () {
                                    _showPicker(context);
                                  },
                                ),
                              ),
                              _image != null
                                  ? Container(
                                      width: size.width * 0.4,
                                      height: size.width * 0.4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          File(_image!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        width: size.width * 0.4,
                                        height: size.width * 0.4,
                                        child:
                                            Center(child: Text('Add Image!')),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController textController,
    required FocusNode focusNode,
    String? Function(String?)? validator,
    required keyboardType,
    FocusNode? nextFocusNode,
  }) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: size.width * 0.3,
        child: TextFormField(
          controller: textController,
          decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero)),
          ),
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          focusNode: focusNode,
          validator: validator,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
      ),
    );
  }
}
