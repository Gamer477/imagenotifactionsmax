import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imagefirebaseupload/widgets/picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    File image,
    String password,
    bool islogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _userEmail = '';
  var _username = '';
  var _userpassword = '';
  File? _userImageFile;
  var _isLogin = true;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  final _formkey = GlobalKey<FormState>();
  void _trysubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please Pick an Image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formkey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _username.trim(),
        _userImageFile!,
        _userpassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (val) {
                      if (val!.isEmpty || !val.contains('@')) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (val) {
                      _userEmail = val!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please Enter at Least 4 Charcters';
                        }
                        return null;
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: 'UserName',
                      ),
                      onSaved: (val) {
                        _username = val!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password Must be 7 Charcters Long';
                      }
                      return null;
                    },
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (val) {
                      _userpassword = val!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: () {
                        _trysubmit();
                      },
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create New Account'
                          : 'I Already Have an Account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
