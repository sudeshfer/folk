import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/Create/chooseCategories.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/pages/HomePage/Home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:folk/Controllers/ApiServices/Post/AddPostController.dart';
import 'dart:convert';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:async/async.dart';

// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreatePost extends StatefulWidget {
  List catlist;
  CreatePost(this.catlist, {Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _expdate = TextEditingController();
  final _category = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File file;
  Position _currentPosition;
  UserModel _userModel;

  bool isPostClicked = false;
  bool isChtGroupClicked = true;
  final maxLines = 5;
  bool togglevalue = false;
  String _typology = "post";
  String _errorTitle = '';
  String _errorDesc = '';
  String _errorCategory = '';
  
  getCats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _category.text = prefs.getString("catString");
    });

     if(prefs.getString("Postdescription") != null){
      print("DESCRIPTION INITIALIZED ");
      setState(() {
        _desc.text =  prefs.getString("Postdescription");
      });  
    }

    if(prefs.getBool("toggleVal") != null){
      print("toggle value INITIALIZED ");
      setState(() {
        togglevalue =  prefs.getBool("toggleVal");
      });  
    }

     if(prefs.getString("selectedDate") != null){
      print("selectedDate INITIALIZED ");
      setState(() {
        _expdate.text =  prefs.getString("selectedDate");
      });  
    }

    if(prefs.getBool("isChatGroup") != null){
      print("isChatGroup value INITIALIZED ");
      setState(() {
        isChtGroupClicked =  prefs.getBool("isChatGroup");
        isPostClicked = false;
        _typology =  prefs.getString("typology");
      });  
    }

     if(prefs.getBool("isPost") != null){
      print("isPost value INITIALIZED ");
      setState(() {
        isPostClicked =  prefs.getBool("isPost");
        isChtGroupClicked = false;
        _typology =  prefs.getString("typology");
      });  
    }


  }

  // _getCurrentLocation() async {
  //   _currentPosition = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   print(_currentPosition.latitude.toString());
  //   print(_currentPosition.longitude.toString());
  // }

  @override
  void initState() {
 
    getCats();
    // _getCurrentLocation();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: _buildHeader(context),
      body: GestureDetector(
        onTap: () {
          _errorTitle = "";
          _errorDesc = '';
          _errorCategory = '';
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          _buildTitle(context),
          SizedBox(
            height: 15,
          ),
          _buildTextFields(context),
          _buildTypologySection(context),
          _builExpField(context),
          // _buildDateTime(context)
        ])),
      ),
      bottomNavigationBar: _buildSubmitBtn(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            height: 80.0,
            alignment: Alignment.center,
            child: _buildheader(context),
          ),
          _buildDevider(context),
        ],
      ),
    );
  }

  Widget _buildheader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                log('Clikced on back btn');
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(),
              child: new Text('Step 1-2',
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 17.0)),
            ),
            Container(
                child: Text(
              "blah",
              style: TextStyle(color: Colors.white),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildDevider(BuildContext context) {
    return Flexible(
        fit: FlexFit.loose,
        child: Container(
          margin: const EdgeInsets.only(top: 7),
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFf45d27), Color(0xFFFF8A65)],
            ),
          ),
        ));
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 15),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'Create a post',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500),
        )
      ]),
    );
  }

  Widget _entryField(String labelTXt, String errorTxt,
      TextEditingController controller, int maxLines) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("Postdescription", _desc.text);
        },
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Color(0xFFE0E0E0))),
            labelText: labelTXt,
            errorText: errorTxt,
            errorBorder: errorTxt.isEmpty
                ? OutlineInputBorder(
                    borderSide: new BorderSide(color: Color(0xFFE0E0E0)))
                : null,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
      ),
    );
  }

  Widget _buildTextFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          // _entryField('Title', _errorTitle, _title, 1),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChooseCategories()));
              },
              child: IgnorePointer(
                ignoring: true,
                child: TextField(
                  controller: _category,
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Color(0xFFE0E0E0))),
                      labelText: "Category",
                      errorText: _errorCategory,
                      errorBorder: _errorCategory.isEmpty
                          ? OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Color(0xFFE0E0E0)))
                          : null,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
                ),
              ),
            ),
          ),
          _entryField('Description', _errorDesc, _desc, 5),
        ],
      ),
    );
  }

  Widget _buildTypologyTitle(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 25),
        child: Text(
          'Typology',
          style: TextStyle(
            color: Color.fromRGBO(64, 75, 105, 1),
            fontSize: 15,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  Widget _buildTypologySection(BuildContext context) {
    return Column(children: <Widget>[
      _buildTypologyTitle(context),
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[_postBtn(context), _chatGroupBtn(context)]),
      )
    ]);
  }

  Widget _postBtn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              isPostClicked = true;
              isChtGroupClicked = false;
              _typology = "post";
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
           prefs.setBool("isPost", true);
           prefs.setString("typology", _typology);
           prefs.remove('isChatGroup');

            print("Selected typology = " + _typology);
          },
          child: Container(
            margin: EdgeInsets.only(left: 55),
            height: 60.0,
            width: 60.0,
            decoration: new BoxDecoration(
              border: Border.all(color: Color(0xFFE0E0E0)),
              shape: BoxShape.circle,
              gradient:isPostClicked ? LinearGradient(
                colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
              ):LinearGradient(
                colors: [Colors.white, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                child: isPostClicked
                    ? Image.asset('assets/images/post_white.png')
                    : Image.asset('assets/images/post_black.png'),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 60.0),
          child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Text('Post')),
        )
      ],
    );
  }

  Widget _chatGroupBtn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              isChtGroupClicked = true;
              isPostClicked = false;
              _typology = "chat_group";
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
           prefs.setBool("isChatGroup", true);
           prefs.setString("typology", _typology);
           prefs.remove('isPost');

            print("Selected typology = " + _typology);
          },
          child: Container(
            margin: EdgeInsets.only(right: 55),
            height: 60.0,
            width: 60.0,
            decoration: new BoxDecoration(
              border: Border.all(color: Color(0xFFE0E0E0)),
              shape: BoxShape.circle,
               gradient:isChtGroupClicked ? LinearGradient(
                colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
              ):LinearGradient(
                colors: [Colors.white, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                child: isChtGroupClicked
                    ? Image.asset(
                        'assets/images/chatgroup_white.png') //white icon show
                    : Image.asset(
                        'assets/images/chatgroup_black.png'), //black icon show
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 60.0),
          child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Text('Chat group')),
        )
      ],
    );
  }

  Widget _builExpField(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: new EdgeInsetsDirectional.only(start: 42.0, end: 1.0),
              alignment: Alignment.centerLeft,
              child: Text("Set Expiration",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Montserrat')),
            ),
            Container(
              margin: new EdgeInsetsDirectional.only(start: 112.0, end: 23.0),
              alignment: Alignment.centerRight,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: togglevalue
                          ? Colors.greenAccent[400]
                          : Colors.grey.withOpacity(0.5)),
                  child: Stack(
                    children: <Widget>[
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        top: 3.0,
                        left: togglevalue ? 40.0 : 0.0,
                        right: togglevalue ? 0.0 : 40.0,
                        child: InkWell(
                            onTap: toggleButton,
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return RotationTransition(
                                    child: child,
                                    turns: animation,
                                  );
                                },
                                child: togglevalue
                                    ? Icon(Icons.check_circle,
                                        color: Colors.white,
                                        size: 35,
                                        key: UniqueKey())
                                    : Icon(Icons.remove_circle_outline,
                                        color: Colors.grey,
                                        size: 35.0,
                                        key: UniqueKey()))),
                      )
                    ],
                  )),
            ),
          ],
        ),
        togglevalue
            ? Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: InkWell(
                  onTap: (){
                    showDatePicker2();
                  },
                                  child: IgnorePointer(
                    ignoring: true,
                    child: _entryField('Expiration Date', _errorDesc, _expdate, 1)),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding:
          const EdgeInsets.only(bottom: 20, top: 10.0, left: 20.0, right: 20),
      child: GestureDetector(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (checkNull()) {
            if (validate()) {
              print("validated");
              startAdd(widget.catlist);
              // AddPostService.addPost(body).then((success) {
              //   if (success) {
              //     print("added");
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
              //   } else {
              //     print("failed");
              //   }
              // });
            }
          } else {
            setState(() {
              _errorTitle = "This needed";
              _errorDesc = 'this needed';
              _errorCategory = "this needed";
            });
          }
        },
        child: Container(
          height: 50,
          // width: MediaQuery.of(context).size.width / 4,
          // width: 200,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Center(
            child: Text(
              'Create'.toUpperCase(),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildDateTime(BuildContext context){
  //    return FlatButton(
  //   onPressed: () {
  //       DatePicker.showDatePicker(context,
  //                             showTitleActions: true,
  //                             minTime: DateTime(1980, 12, 31),
  //                             maxTime: DateTime.now(), onChanged: (date) {
  //                           print('change $date');
  //                         }, onConfirm: (date) {
  //                           print('confirm $date');
  //                         }, currentTime: DateTime.now(), locale: LocaleType.en);
  //   },
  //   child: Text(
  //       'show date time picker',
  //       style: TextStyle(color: Colors.blue),
  //   ));
  // }

  bool checkNull() {
    if (_title.text == '' && _desc.text == '' && _category.text == '') {
      return false;
    } else {
      setState(() {
        _errorTitle = "";
        _errorDesc = '';
        _errorCategory = '';
      });
      return true;
    }
  }

  bool validate() {
    if (_desc.text == '') {
      return false;
    } else if (_desc.text == '') {
      setState(() {
        _errorDesc = "this needed";
      });
      return false;
    } else if (_category.text == '') {
      setState(() {
        _errorCategory = "this needed";
      });
      return false;
    } else {
      return true;
    }
  }

  toggleButton() async {
    if (togglevalue == false) {
      showDatePicker();
    } else {
      setState(() {
        togglevalue = !togglevalue;
      });
      
    }
  }

  showDatePicker() {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
        ),
        maxTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 365), onChanged: (date) {
      //print the date
      print('change $date');
    }, onConfirm: (date) async {
      // final bday = "$date";

      // age = (date.difference(DateTime.now()).inDays) * -1;
      // print("age in days:" + age.toString());

      // var formatter = new DateFormat('yyyy-MM-dd');
      var selecteddate = date;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("selectedDate", selecteddate.toString());

      setState(() {
        _expdate.text = selecteddate.toString();
        togglevalue = !togglevalue;
      });
      print(togglevalue);
      prefs.setBool("toggleVal", togglevalue);
      print(_expdate.text);
      //print the bday
      // print('confirm ' + selecteddate.toString());
    }, locale: LocaleType.en);
  }

  showDatePicker2() {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
        ),
        maxTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 365), onChanged: (date) {
      //print the date
      print('change $date');
    }, onConfirm: (date) {
      // final bday = "$date";

      // age = (date.difference(DateTime.now()).inDays) * -1;
      // print("age in days:" + age.toString());

      // var formatter = new DateFormat('yyyy-MM-dd');
      var selecteddate = date;

      setState(() {
        _expdate.text = selecteddate.toString();
        // togglevalue = !togglevalue;
      });
      print(_expdate.text);
      //print the bday
      // print('confirm ' + selecteddate.toString());
    }, locale: LocaleType.en);
  }

  void startAdd(catlist) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble("lat");
    final long = prefs.getDouble("lng");

    final geo = {
      "pintype": "Point",
      "coordinates": [long,lat]
    };
    String _url = "${Constants.SERVER_URL}post/create";
    Fluttertoast.showToast(msg: 'posting ...');
    if (file != null) {
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var uri = Uri.parse(_url);
      var request = new http.MultipartRequest("POST", uri);

      var multipartFile = new http.MultipartFile('img', stream, length,
          filename: Path.basename(file.path));
      request.files.add(multipartFile);
      request.fields.addAll({
        "user_id": _userModel.id,
        "post_data": ' ${_desc.text}',
        "typology": _typology,
        "geometry": json.encode(geo),
        "exp_date": togglevalue == true ? _expdate.text : null,
        // "category": widget.catlist != [] ? json.encode(widget.catlist) : null
      });
      var response = await request.send();

      response.stream.transform(convert.utf8.decoder).listen((value) async {
        try {
          var jsonResponse = await convert.jsonDecode(value);
          bool error = jsonResponse['error'];
          if (error == false) {
            Provider.of<PostProvider>(context, listen: false)
                .startGetPostsData(_userModel.id);
            Fluttertoast.showToast(msg: ' done ...');
            _desc.clear();
            clearSharedPrefValues();
           Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Home()));
          } else {
            print('error! ' + jsonResponse);

            Fluttertoast.showToast(
                msg: "unkown error !" + jsonResponse,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (err) {
          print(err);
          print(value);
          Fluttertoast.showToast(
              msg: "unkown error ! check your connection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } finally {
          setState(() {});
        }
      });
    } else {
      try {
        Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

        print("here adding post");
        
        var req = await http.post(_url, headers: requestHeaders, body: jsonEncode({
          'user_id': _userModel.id,
          'post_data': '${_desc.text}',
          "typology": _typology.toString(),
          "geometry": json.encode(geo),
          "exp_date": togglevalue == true ? _expdate.text : null,
          "category": widget.catlist != [] ? widget.catlist : null
        }));

        var response = convert.jsonDecode(req.body);

        if (!response['error']) {
          Provider.of<PostProvider>(context, listen: false)
              .startGetPostsData(_userModel.id);
          Fluttertoast.showToast(msg: ' done ...');
          _desc.clear();
          clearSharedPrefValues();
         Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Home()));
        }
      } catch (err) {
        print(err);
        Fluttertoast.showToast(msg: ' error while upload ... $err');
      } finally {
        setState(() {});
      }
    }
  }

  clearSharedPrefValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('catString');
    prefs.remove('Postdescription');
    prefs.remove('toggleVal');
    prefs.remove('selectedDate');
    prefs.remove('typology');
    prefs.remove('isPost');
    prefs.remove('isChatGroup');
    prefs.remove("postcats");
    print("sharedPref Values Cleared ");
  }
}
