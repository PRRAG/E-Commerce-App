import 'package:e_commerce_app/models/user.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  var _user = User(
    name: '',
    phone: '',
    email: '',
  );
  final _form = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _nameTextController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _phoneTextController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _emailTextController = TextEditingController();

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      _user = User(
        name: _nameTextController.text,
        phone: _phoneTextController.text,
        email: _emailTextController.text,
      );
      print(_user.name);
      print(_user.phone);
      print(_user.email);
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
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: _isLoading
              ? CircularProgressIndicator()
              : Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTextFormField(
                        label: 'Name',
                        textController: _nameTextController,
                        focusNode: _nameFocusNode,
                        nextFocusNode: _phoneFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        label: 'Phone',
                        textController: _phoneTextController,
                        focusNode: _phoneFocusNode,
                        nextFocusNode: _emailFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value.';
                          }
                        },
                      ),
                      _buildTextFormField(
                        label: 'Email',
                        textController: _emailTextController,
                        focusNode: _emailFocusNode,
                        nextFocusNode: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value.';
                          }
                          if (!(value.contains('@') ||
                              value.contains('.com'))) {
                            return 'Enter a Valid E-mail';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          onPressed: () => _saveForm(),
                          child: Container(
                            width: 100,
                            child: Center(child: Text('Run App')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    ));
  }

  Widget _buildTextFormField(
      {required String label,
      required TextEditingController textController,
      required FocusNode focusNode,
      FocusNode? nextFocusNode,
      String? Function(String?)? validator}) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: size.width * 0.8,
        child: TextFormField(
          controller: textController,
          decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero)),
          ),
          textInputAction: TextInputAction.next,
          keyboardType: label == 'Phone'
              ? TextInputType.phone
              : TextInputType.emailAddress,
          focusNode: focusNode,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
          validator: validator,
        ),
      ),
    );
  }
}
