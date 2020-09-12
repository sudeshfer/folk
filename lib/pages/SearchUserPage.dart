import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/PeerProfile.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:folk/utils/Constants.dart';

// ignore: must_be_immutable
class SearchUserPage extends StatefulWidget {
  String id;
  String email;

  SearchUserPage(this.id,this.email);

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  var nameController = TextEditingController();
  UserModel userModel;
  List<UserModel> _listUserModel = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getThemeData.backgroundColor,
      floatingActionButton: widget.email == Constants.ADMIN_EMAIL
          ? FloatingActionButton(
          child: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            startGetAllUsers();
          })
          : Container(),
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                startSearch(nameController.text);
              },
              child: Text('search'))
        ],
        elevation: 1,
        title: Text('search page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                _entryField('search user by name', nameController),
                SizedBox(
                  height: 15,
                ),
                userModel == null
                    ? Container()
                    : ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PeerProfile(userModel.id)));
                        },
                        title: Text('${userModel.name}'),
                        leading: CachedNetworkImage(
                          imageUrl:
                              Constants.USERS_PROFILES_URL + userModel.img,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                _listUserModel.length == 0
                    ? Container()
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _listUserModel.length,
                        itemBuilder: (c, i) {
                          return Container(
                            margin: EdgeInsets.only(top: 15),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            PeerProfile(_listUserModel[i].id)));
                              },
                              title: Text('${_listUserModel[i].name}'),
                              leading: CachedNetworkImage(
                                imageUrl: Constants.USERS_PROFILES_URL +
                                    _listUserModel[i].img,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        })
              ],
            ))),
      ),
    );
  }

  Widget _entryField(String title, controller, {bool isPassword = false}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              onSubmitted: (txt) {
                startSearch(txt);
              },
              autofocus: true,
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none, filled: true, hintText: title))
        ],
      ),
    );
  }

  startSearch(String txt) async {
    try {
      var req = await http.post('${Constants.SERVER_URL}user/getUserByEmail',
          body: {'email': '${txt.toLowerCase()}'});
      var res = convert.jsonDecode(req.body);
      if (!res['error']) {
        UserModel userModel = UserModel.fromJson(res['data']);
        setState(() {
          _listUserModel = [];
          this.userModel = userModel;
        });
      } else {
        Fluttertoast.showToast(msg: 'please check the Name');
        setState(() {
          _listUserModel = [];
          userModel = null;
        });
      }
    } catch (err) {
      Fluttertoast.showToast(msg: 'please check your connection $err');
    }
  }

  void startGetAllUsers() async {
    var req = await http.post(
      '${Constants.SERVER_URL}user/getUsers',
    );
    var res = convert.jsonDecode(req.body);

    if (!res['error']) {
      List<UserModel> temp = [];

      for (int i = 0; i < res['data'].length; i++) {
        temp.add(UserModel.fromJson(res['data'][i]));
      }

      setState(() {
        _listUserModel = temp;
      });
      Fluttertoast.showToast(
          msg: 'number of Users is ${_listUserModel.length}',
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
