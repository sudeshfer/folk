import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:folk/Controllers/ApiServices/GetInterestsService.dart';
import 'package:folk/Models/interestModel.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/app_localizations.dart';

class SetupStepThree extends StatefulWidget {
  // final bday;
  // final gender;
  // final email;
  // final phone;
  // final fbId;
  // final fbName;
  // final fbEmail;
  // final fbPicUrl;
  // PincodeVerify({Key key}) : super(key: key);
  SetupStepThree(
      // {
      //this.bday,
      // this.gender,
      // this.email,
      // this.phone,
      // this.fbId,
      // this.fbName,
      // this.fbEmail,
      // this.fbPicUrl
      // }
      );

  @override
  _SetupStepThreeState createState() => _SetupStepThreeState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _SetupStepThreeState extends State<SetupStepThree> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Interest> interest = List();
  List<Interest> filteredInterests = List();

  List _selectedIndexs = [];
  final _search = TextEditingController();

  bool isClicked = false;
  bool isSearchFocused = false;
  String isExpanded = "";

  @override
  void initState() {
    super.initState();
    GetInterestService.getInterests().then((interestFromServer) {
      setState(() {
        interest = interestFromServer;
        filteredInterests = interest;
      });
    });

    setState(() {
      isExpanded = "true";
    });
  }

  Future<bool> _onBackPressed() {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            // customHeader: Image.asset("assets/images/macha.gif"),
            animType: AnimType.TOPSLIDE,
            btnOkText: AppLocalizations.of(context).translate('yes'),
            btnCancelText: AppLocalizations.of(context).translate('no'),
            tittle: AppLocalizations.of(context).translate('you_sure'),
            desc: AppLocalizations.of(context).translate('exit_app'),
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              exit(0);
            }).show() ??
        false;
  }

  // _clearSearch() {
  //   _search.clear();
  // }

  changeIcon(){
   setState(() {
     isExpanded= "false";
   });
   print(isExpanded);
    
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          isSearchFocused = false; //
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false, // this avoids the overflow error
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 45.0, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 38,
                          onPressed: () {
                            log('Clikced on back btn');
                            Navigator.of(context).pop(); //go back
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 30.0),
                          width: MediaQuery.of(context).size.width / 1.4,
                          height: 45,
                          // margin: EdgeInsets.only(top: 32),
                          padding: EdgeInsets.only(
                              top: 4, left: 16, right: 16, bottom: 2),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            // controller: _search,
                            onTap: () {
                              setState(() {
                                isSearchFocused = true;
                              });
                            },
                            onChanged: (string) {
                              _debouncer.run(() {
                                setState(() {
                                  filteredInterests = interest
                                      .where((u) => (u.intName
                                          .toLowerCase()
                                          .contains(string.toLowerCase())))
                                      .toList();
                                });
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 30,
                              ),
                              // suffixIcon:isSearchFocused?
                              //      Icon(
                              //       Icons.close,
                              //       color: Colors.orange,
                              //     )
                              //     :null,

                              hintText: AppLocalizations.of(context).translate('search'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeAnimation(
                    0.8,
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 30, bottom: 20),
                      child: Text(
                        AppLocalizations.of(context).translate('choose_intrst'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(64, 75, 105, 1),
                          fontSize: 25,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  FadeAnimation(
                    0.9,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 18),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Hobby",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        onExpansionChanged: changeIcon(),
                        trailing: Icon(
                          Icons.keyboard_arrow_down,
                          size: 35,
                          color: isExpanded== "false"? Colors.black : Colors.black,
                        ),
                        initiallyExpanded: true,
                        children: <Widget>[
                          FadeAnimation(
                            0.5,
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      height: 35,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final _isSelected =
                                              _selectedIndexs.contains(index);
                                          return Wrap(
                                            direction: Axis.vertical,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (_isSelected) {
                                                      _selectedIndexs
                                                          .remove(index);
                                                    } else {
                                                      _selectedIndexs
                                                          .add(index);
                                                    }
                                                  });
                                                },
                                                child: new Container(
                                                  margin:
                                                      EdgeInsets.only(right: 7),
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5.2,
                                                  decoration: BoxDecoration(
                                                      color: _isSelected
                                                          ? Colors.white
                                                          : Color(0xFFFFEBE7),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFE0E0E0)),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      50.0),
                                                              topRight:
                                                                  Radius.circular(
                                                                      50.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      50.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      0.0))),
                                                  child: Center(
                                                    child: Text(
                                                      filteredInterests[index]
                                                          .intName,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          color:
                                                              Color(0xFFFF5E3A),
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        itemCount: filteredInterests.length,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeAnimation(
                    1.1,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 30),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Sport,Activity,Fitness",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                         trailing: Icon(
                          Icons.keyboard_arrow_down,
                          size: 35,
                          color: isExpanded== "false"? Colors.black : Colors.black,
                        ),
                        children: <Widget>[
                          FadeAnimation(
                            0.5,
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 7),
                                    // padding: const EdgeInsets.all(12.0),
                                    // margin: const EdgeInsets.only(right: 5),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xFFE0E0E0)),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeAnimation(
                    1.2,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 30),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Family",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                         trailing: Icon(
                          Icons.keyboard_arrow_down,
                          size: 35,
                          color: isExpanded== "false"? Colors.black : Colors.black,
                        ),
                        children: <Widget>[
                          FadeAnimation(
                            0.5,
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 7),
                                    // padding: const EdgeInsets.all(12.0),
                                    // margin: const EdgeInsets.only(right: 5),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xFFE0E0E0)),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeAnimation(
                    1.3,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 30),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Sports",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                         trailing: Icon(
                          Icons.keyboard_arrow_down,
                          size: 35,
                          color: isExpanded== "false"? Colors.black : Colors.black,
                        ),
                        children: <Widget>[
                          FadeAnimation(
                            0.5,
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 7),
                                    // padding: const EdgeInsets.all(12.0),
                                    // margin: const EdgeInsets.only(right: 5),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color(0xFFE0E0E0)),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: const EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 5.2,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffebee),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        "culture",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Container(
              height: 100,
              // decoration: BoxDecoration(
              //   color:Colors.red
              // ),
              child: FadeAnimation(
                1.4,
                InkWell(
                  onTap: () {
                    log('Clikced on trouble with login');
                    Navigator.of(context).pushNamed("/location");
                  },
                  child: Container(
                    // padding: EdgeInsets.only(top: 35, bottom: 25),
                    child: Center(
                      child: Container(
                        height: 51,
                        width: MediaQuery.of(context).size.width / 1.12,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Next'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
