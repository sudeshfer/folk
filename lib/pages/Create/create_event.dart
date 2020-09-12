import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/utils/HelperWidgets/tag.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/EventProvider.dart';
import 'package:folk/pages/HomePage/Home.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key key}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  //photobox variables
  // File imageFile;

  //controllers
  // final _title = TextEditingController();
  final _desc = TextEditingController();
  final _title = TextEditingController();
  final _date = TextEditingController();
  final startTime = TextEditingController();
  final _category = TextEditingController();

  final maxLines = 5;
  String _typology = "cinema";
  String _foodCat = "";
  File file;

  String city;
  String address;
  String adresslat;
  String adresslong;
  String eventDateTime = "";

  PickResult selectedPlace;

  double inilat = 6.9271;
  double inilong = 79.8612;

  //error texts
  String errorDate = '';
  String _errorTitle = '';
  String _errorDesc = '';
  String errorTime = '';
  String errorPhoto = '';
  String errorTypo = '';
  String _errorCategory = '';

  bool isCinema = true;
  bool isCoffe = false;
  bool isAperitif = false;
  bool isDinner = false;
  UserModel _userModel;
//participent slider variables
  double _value = 2;
  String maxPartecipants = "";

  //age slider variables
  RangeValues _values = RangeValues(0.3, 0.7);
  double loverAge = 18;
  double endAge = 55;
  void initiate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;

    setState(() {
      inilat = prefs.getDouble("lat");
      inilong = prefs.getDouble("lng");
      city = prefs.getString("city");
    });
  }

  @override
  void initState() {
    initiate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: _buildHeader(context),
      body: GestureDetector(
        onTap: () {
          errorPhoto = "";
          _errorDesc = '';
          _errorCategory = '';
          errorDate = '';
          errorTime = '';
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: new ListView(
          children: <Widget>[
            _buildTitle(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
              child: Container(
                // width: widget.width,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            (file == null) ? Colors.white : Colors.grey[100]),
                    child: (file == null)
                        //No img selected and camera logo is shown
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.grey[100],
                                onTap: () {
                                  print("Photo Pick Button pressed");
                                  _showChoiceDialog(context);
                                },
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/btn_upload_cover_wide.png"),
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  child: Image.file(
                                    file,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    print("Delete Button Pressed");
                                    setState(() {
                                      file = null;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/btn_close.png"),
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: errorPhoto != ''
                  ? Text(
                      "$errorPhoto",
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Loacation",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: "AIzaSyBb802m9ZqSKEBkdNxoeV7w8Hz-7geAMCM",
                            onPlacePicked: (result) {
                              print(result.formattedAddress);

                              var arr = result.formattedAddress.split(',');
                              setState(() {
                                city = arr[arr.length - 2];
                                address = "${result.formattedAddress}";
                                adresslat = "${result.geometry.location.lat}";
                                adresslong = "${result.geometry.location.lng}";
                              });
                              print("the adress issss $address");

                              Navigator.of(context).pop();
                            },
                            initialPosition: LatLng(inilat, inilong),
                            useCurrentLocation: true,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          "$city",
                          style:
                              TextStyle(fontSize: 16, color: Colors.deepOrange),
                        ),
                        SizedBox(width: 15),
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 15,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _title,
                  // maxLines: 5,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Color(0xFFE0E0E0))),
                      labelText: 'Title',
                      errorText: _errorDesc,
                      errorBorder: _errorDesc.isEmpty
                          ? OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Color(0xFFE0E0E0)))
                          : null,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _desc,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Color(0xFFE0E0E0))),
                      labelText: 'Description',
                      errorText: _errorDesc,
                      errorBorder: _errorDesc.isEmpty
                          ? OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Color(0xFFE0E0E0)))
                          : null,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: InkWell(
                  onTap: () {
                    print("hutto");
                    showDatePicker();
                  },
                  child: _entryField('Date', errorDate, _date, 1, 1)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: InkWell(
                  onTap: () {
                    print("huttiyee");
                    showTimePicker();
                  },
                  child:
                      _entryField('Starting Time', errorTime, startTime, 1, 1)),
            ),
            _buildTypologySection(context),
            isDinner ? buildCategoryTagBar(context) : Container(),
            errorTypo != ''
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: Text(
                      "$errorTypo",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Max. Partecipants : ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "$maxPartecipants",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.deepOrange,
                        inactiveTrackColor: Colors.grey[200],
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 4.0,
                        thumbColor: Colors.deepOrange,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayColor: Colors.deepOrange.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                      ),
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: _value,
                        onChanged: (val) {
                          setState(() {
                            _value = val;
                            maxPartecipants = _value.round().toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Age Range : ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${loverAge.toStringAsFixed(0)}-${endAge.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.deepOrange,
                        inactiveTrackColor: Colors.grey[200],
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 4.0,
                        thumbColor: Colors.deepOrange,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayColor: Colors.deepOrange.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                      ),
                      child: RangeSlider(
                        min: 18,
                        max: 80,
                        values: RangeValues(loverAge, endAge),
                        onChanged: (newvalues) {
                          setState(() {
                            loverAge = newvalues.start;
                            endAge = newvalues.end;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // _buildDateTime(context)
          ],
        ),
      ),
      bottomNavigationBar: _buildSubmitBtn(context),
    );
  }

  void startAdd() async {
    final lat = adresslat != null ? adresslat : inilat;
    final long = adresslong != null ? adresslong : inilong;

    final geo = {
      "pintype": "Point",
      "coordinates": [long, lat]
    };
    String _url = "${Constants.SERVER_URL}event/create";
    Fluttertoast.showToast(msg: 'posting ...');
    if (file != null && eventDateTime != '') {
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var uri = Uri.parse(_url);
      var request = new http.MultipartRequest("POST", uri);

      var multipartFile = new http.MultipartFile('img', stream, length,
          filename: Path.basename(file.path));
      request.files.add(multipartFile);
      request.headers['Content-Type'] = 'application/json';
      request.fields.addAll({
        "user_id": _userModel.id,
        "title": _title.text,
        "post_data": ' ${_desc.text}',
        "typology": _typology,
        "foodcategory": _foodCat,
        "geometry": json.encode(geo),
        "address": address != null ? address : city,
        "event_date": eventDateTime,
        "maxparticipants": maxPartecipants,
        "minage": "${loverAge.toStringAsFixed(0)}",
        "maxage": "${endAge.toStringAsFixed(0)}"
      });
      var response = await request.send();

      response.stream.transform(convert.utf8.decoder).listen((value) async {
        try {
          var jsonResponse = await convert.jsonDecode(value);
          bool error = jsonResponse['error'];
          if (error == false) {
            Fluttertoast.showToast(msg: ' done ...');
            _desc.clear();
            Provider.of<EventProvider>(context, listen: false)
                .startGetEventsData(_userModel.id);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home()));
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
      Fluttertoast.showToast(msg: ' please select an image ... ');
    }
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      file = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      file = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a source',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Select a content',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _openGallery(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              spreadRadius: 0.5,
                              blurRadius: 10,
                              offset: Offset(
                                -2,
                                10,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Container(
                            child: Image.asset(
                              'assets/images/fromGallery.png',
                              height: MediaQuery.of(context).size.height / 12,
                              // width: MediaQuery.of(context).size.width / 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _openCamera(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              spreadRadius: 0.5,
                              blurRadius: 10,
                              offset: Offset(
                                -2,
                                10,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Container(
                            child: Image.asset(
                              'assets/images/fromCamera.png',
                              height: MediaQuery.of(context).size.height / 12,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  showTimePicker() {
    DatePicker.showTime12hPicker(context, showTitleActions: true,
        onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) async {
      String selecteddate = date.toString();
      final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
      final DateFormat serverFormater = DateFormat().add_jm();
      // final DateFormat serverFormaterr = DateFormat().add_Hms();
      final DateTime displayDate = displayFormater.parse(selecteddate);
      final String formatted = serverFormater.format(displayDate);

      final DateFormat formatter = DateFormat('HH:mm:ss.SSS');

      String timeSelected = formatted;
      setState(() {
        startTime.text = timeSelected;
        eventDateTime = eventDateTime + "T" + formatter.format(displayDate);
      });
      print(startTime.text);
      print("date string $eventDateTime");
    }, locale: LocaleType.en);
  }

  showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2100, 12, 31), onChanged: (date) {
      //print the date
      print('change $date');
    }, onConfirm: (date) {
      var formatter = new DateFormat('yyyy-MM-dd');
      var selecteddate = formatter.format(date);

      setState(() {
        _date.text = selecteddate;
        eventDateTime = selecteddate;
        //eaqual the bday value to text editing controller
      });

      //print the bday
      print('confirm ' + selecteddate.toString());
    }, locale: LocaleType.en);
  }

  Widget buildCategoryTagBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Category",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  initFoodCats("culture");
                  print("food cat is $_foodCat");
                },
                child: Tag(
                  "culture",
                  _foodCat == "culture" ? Colors.black : Colors.deepOrange,
                  _foodCat == "culture"
                      ? Colors.white
                      : Colors.deepOrange.withOpacity(0.1),
                  _foodCat == "culture" ? Colors.grey[200] : Colors.transparent,
                ),
              ),
              GestureDetector(
                onTap: () {
                  initFoodCats("meat");
                  print("food cat is $_foodCat");
                },
                child: Tag(
                  "meat",
                  _foodCat == "meat" ? Colors.black : Colors.deepOrange,
                  _foodCat == "meat"
                      ? Colors.white
                      : Colors.deepOrange.withOpacity(0.1),
                  _foodCat == "meat" ? Colors.grey[200] : Colors.transparent,
                ),
              ),
              GestureDetector(
                onTap: () {
                  initFoodCats("japanese");
                  print("food cat is $_foodCat");
                },
                child: Tag(
                  "Japaneese",
                  _foodCat == "japanese" ? Colors.black : Colors.deepOrange,
                  _foodCat == "japanese"
                      ? Colors.white
                      : Colors.deepOrange.withOpacity(0.1),
                  _foodCat == "japanese"
                      ? Colors.grey[200]
                      : Colors.transparent,
                ),
              ),
              GestureDetector(
                onTap: () {
                  initFoodCats("hamburger");
                  print("food cat is $_foodCat");
                },
                child: Tag(
                  "hamburger",
                  _foodCat == "hamburger" ? Colors.black : Colors.deepOrange,
                  _foodCat == "hamburger"
                      ? Colors.white
                      : Colors.deepOrange.withOpacity(0.1),
                  _foodCat == "hamburger"
                      ? Colors.grey[200]
                      : Colors.transparent,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  initFoodCats(String val) {
    if (_foodCat == val) {
      setState(() {
        _foodCat = "";
      });
    } else {
      setState(() {
        _foodCat = val;
      });
    }
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
              child: new Text('Step 2-2',
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
      padding: const EdgeInsets.only(left: 25.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'Create an Event',
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
      TextEditingController controller, int maxLines, int minLines) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: IgnorePointer(
        ignoring: true,
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
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
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  isCinema = !isCinema;
                  isCoffe = false;
                  isAperitif = false;
                  isDinner = false;
                  // _typology = "cinema";
                });
                initTypo(isCinema, "cinema");
                print("typo iss $_typology");
              },
              child: TypologyButton(FontAwesomeIcons.film, "Cinema", isCinema)),
          GestureDetector(
              onTap: () {
                setState(() {
                  isCoffe = !isCoffe;
                  isCinema = false;
                  isAperitif = false;
                  isDinner = false;
                });
                initTypo(isCoffe, "coffe");
                print("typo iss $_typology");
              },
              child:
                  TypologyButton(FontAwesomeIcons.coffee, "Coffee", isCoffe)),
          GestureDetector(
              onTap: () {
                setState(() {
                  isAperitif = !isAperitif;
                  isCoffe = false;
                  isCinema = false;
                  isDinner = false;
                  //  _typology = "aperitif";
                });
                initTypo(isAperitif, "aperitif");
                print("typo iss $_typology");
              },
              child: TypologyButton(
                  FontAwesomeIcons.glassCheers, "Aperitif", isAperitif)),
          GestureDetector(
              onTap: () {
                setState(() {
                  isDinner = !isDinner;
                  isCoffe = false;
                  isCinema = false;
                  isAperitif = false;
                  // _typology = "dinner";
                });
                initTypo(isDinner, "dinner");
                print("typo iss $_typology");
              },
              child: TypologyButton(
                  FontAwesomeIcons.utensils, "Dinner", isDinner)),
        ]),
      )
    ]);
  }

  initTypo(bool typo, String val) {
    if (typo) {
      setState(() {
        _typology = val;
      });
    } else {
      _typology = "";
    }
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding:
          const EdgeInsets.only(bottom: 20, top: 10.0, left: 20.0, right: 20),
      child: GestureDetector(
        onTap: () {
          if (checkNull()) {
            startAdd();
          } else {
            setState(() {
              errorPhoto = "A pohoto needed !";
              _errorDesc = 'this needed';
              errorTypo = "Typology needed";
              errorDate = 'this needed';
              errorTime = 'this needed';
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

  bool checkNull() {
    if (file == null &&
        _desc.text == '' &&
        _category.text == '' &&
        _typology == '') {
      return false;
    } else {
      setState(() {
        errorPhoto = "";
        _errorDesc = '';
        _errorCategory = '';
      });
      return true;
    }
  }

  bool validate() {
    if (file == null) {
      setState(() {
        errorPhoto = "A Photo needed";
      });
      return false;
    } else if (file != null) {
      setState(() {
        errorPhoto = "";
      });
      return false;
    } else if (_typology == '') {
      setState(() {
        errorTypo = "Typology needed";
      });
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
}

class TypologyButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  // final Function onTap;
  TypologyButton(this.icon, this.text, this.isSelected);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(25),
            gradient: isSelected
                ? LinearGradient(
                    colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                  )
                : LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ),
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
          ),
        )
      ],
    );
  }
}

// class CustomRangeSlider extends StatefulWidget {
//   const CustomRangeSlider({
//     Key key,
//   }) : super(key: key);

//   @override
//   _CustomRangeSliderState createState() => _CustomRangeSliderState();
// }

// class _CustomRangeSliderState extends State<CustomRangeSlider> {
//   RangeValues _values = RangeValues(0.3, 0.7);
//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderThemeData(
//         activeTrackColor: Colors.deepOrange,
//         inactiveTrackColor: Colors.grey[200],
//         trackShape: RectangularSliderTrackShape(),
//         trackHeight: 4.0,
//         thumbColor: Colors.deepOrange,
//         thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
//         overlayColor: Colors.deepOrange.withAlpha(32),
//         overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
//       ),
//       child: RangeSlider(
//         // min: 0,
//         // max: 100,
//         values: _values,
//         onChanged: (RangeValues values) {
//           setState(() {
//             _values = values;
//           });
//           print(values);
//         },
//       ),
//     );
//   }
// }

// class CustomSlider extends StatefulWidget {
//   const CustomSlider({
//     Key key,
//   }) : super(key: key);

//   @override
//   _CustomSliderState createState() => _CustomSliderState();
// }

// class _CustomSliderState extends State<CustomSlider> {
//   double _value = 2;
//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderThemeData(
//         activeTrackColor: Colors.deepOrange,
//         inactiveTrackColor: Colors.grey[200],
//         trackShape: RectangularSliderTrackShape(),
//         trackHeight: 4.0,
//         thumbColor: Colors.deepOrange,
//         thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
//         overlayColor: Colors.deepOrange.withAlpha(32),
//         overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
//       ),
//       child: Slider(
//         min: 0,
//         max: 100,
//         value: _value,
//         onChanged: (val) {
//           // _value = val;
//           setState(() {
//             _value = val;
//           });
//         },
//       ),
//     );
//   }
// }

// class CategoryTagBar extends StatefulWidget {
//   const CategoryTagBar({
//     Key key,
//   }) : super(key: key);

//   @override
//   _CategoryTagBarState createState() => _CategoryTagBarState();
// }

// class _CategoryTagBarState extends State<CategoryTagBar> {
//   bool isCulture = false;
//   bool isMeat = false;
//   bool isJap = false;
//   bool isHam = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "Category",
//             style: TextStyle(
//               fontSize: 16,
//             ),
//           ),
//           SizedBox(height: 15),
//           Row(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isCulture = !isCulture;
//                   });
//                 },
//                 child: Tag(
//                   "culture",
//                   isCulture ? Colors.black : Colors.deepOrange,
//                   isCulture ? Colors.white : Colors.deepOrange.withOpacity(0.1),
//                   isCulture ? Colors.grey[200] : Colors.transparent,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isMeat = !isMeat;
//                   });
//                 },
//                 child: Tag(
//                   "meat",
//                   isMeat ? Colors.black : Colors.deepOrange,
//                   isMeat ? Colors.white : Colors.deepOrange.withOpacity(0.1),
//                   isMeat ? Colors.grey[200] : Colors.transparent,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isJap = !isJap;
//                   });
//                 },
//                 child: Tag(
//                   "Japaneese",
//                   isJap ? Colors.black : Colors.deepOrange,
//                   isJap ? Colors.white : Colors.deepOrange.withOpacity(0.1),
//                   isJap ? Colors.grey[200] : Colors.transparent,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isHam = !isHam;
//                   });
//                 },
//                 child: Tag(
//                   "hamburger",
//                   isHam ? Colors.black : Colors.deepOrange,
//                   isHam ? Colors.white : Colors.deepOrange.withOpacity(0.1),
//                   isHam ? Colors.grey[200] : Colors.transparent,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
