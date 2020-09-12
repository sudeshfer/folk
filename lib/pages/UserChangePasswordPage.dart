//created by Suthura


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:folk/utils/Constants.dart';

class UserChangePasswordPage extends StatefulWidget {
  @override
  _UserChangePasswordPageState createState() => _UserChangePasswordPageState();
}

class _UserChangePasswordPageState extends State<UserChangePasswordPage> {
  UserModel userModel;
  var userOldPasswordController = TextEditingController();
  var userNewPasswordController = TextEditingController();
  var userNewPasswordConformController = TextEditingController();

  @override
  void initState() {
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNewPasswordConformController.dispose();
    userNewPasswordController.dispose();
    userOldPasswordController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getThemeData.backgroundColor,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text('${userModel.name}'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              _entryField('OldPassword', userOldPasswordController),
              _entryField('NewPassword', userNewPasswordController),
              _entryField('ConfirmPassword', userNewPasswordConformController),
              SizedBox(
                height: 20,
              ),
              currnetLoading == 0 ? _submitButton() : prograss,
            ],
          ))),
    );
  }

  Widget _entryField(String title, controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration:
                  InputDecoration(border: InputBorder.none, filled: true))
        ],
      ),
    );
  }

  int currnetLoading = 0;

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        setState(() {
          currnetLoading = 1;
        });
        if (userNewPasswordController.text ==
            userNewPasswordConformController.text) {
          startUpdate();
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('confirm password and new password not match'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('close'))
                  ],
                );
              });

          setState(() {
            currnetLoading = 0;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Update Password',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget prograss = Container(
    padding: EdgeInsets.symmetric(vertical: 15),
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      backgroundColor: Colors.green,
      strokeWidth: 7,
    ),
  );

  void startUpdate() async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      var response = await http.post(
        '${Constants.SERVER_URL}user/update_password',
        body: {
          'user_id': userModel.id,
          'old_password': userOldPasswordController.text,
          'new_password': userNewPasswordConformController.text
        },
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      if (error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('${jsonResponse['data']}'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('close'))
                ],
              );
            });
      } else {
        //save to shared !
        updatePassword();

        Fluttertoast.showToast(msg: 'Done');
      }
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('check your internet connection'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('close'))
              ],
            );
          });
    } finally {
      setState(() {
        currnetLoading = 0;
      });
    }
  }

  void updatePassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('password', userNewPasswordController.text);

    userNewPasswordConformController.clear();
    userOldPasswordController.clear();
    userNewPasswordController.clear();
  }
}
