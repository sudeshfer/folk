import 'package:flutter/material.dart';
import 'package:folk/Utils/HelperWidgets/buttons.dart';
import 'package:folk/Utils/SearchAppBar/search_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/UserRequestModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/Utils/HelperWidgets/circle_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/utils/HelperWidgets/emptyResponse.dart';

class ProfileFollowers2Page extends StatefulWidget {
  @override
  _ProfileFollowers2PageState createState() => _ProfileFollowers2PageState();
}

class _ProfileFollowers2PageState extends State<ProfileFollowers2Page> {
  bool isfetching = true;
  bool isEmpty = false;
  UserModel _userModel;
  List<UserRequestsModel> followReqs = List();

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    getFollowReqs();
  }

  getFollowReqs() {
    //start get Posts !
    print("getUser reqa running.............................");

    String _url = "${Constants.SERVER_URL}user/getrequests";
    return http
        .post(_url, body: {'user_id': '${_userModel.id}'}).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        // print(data);
        setState(() {
          followReqs =
              data.map((data) => UserRequestsModel.fromJson(data)).toList();
          isfetching = false;
        });

        print("issssssssssssss ${followReqs.length}");
      } else {
        print("empty response");
        setState(() {
          isfetching = false;
          isEmpty = true;
        });
      }
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: SearchAppBar(
        color1: Colors.grey[100],
        color2: Colors.white,
        searchIconBackgroundColor: Colors.grey[100],
        leading: Container(
          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: isfetching
          ? Center(
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(255, 149, 0, 1),
                  )))
          : isEmpty
              ? EmptyResponse('assets/images/no.png', "No Following requests")
              : Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: followReqs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserRequestsModel _post = followReqs[index];

                      return ConfirmationCard(_post);
                    },
                  ),
                ),
    );
  }
}

class ConfirmationCard extends StatefulWidget {
  final bool withBorder;
  final double padding;
  final double width;
  final UserRequestsModel reqmodel;
  const ConfirmationCard(this.reqmodel,
      {Key key, this.withBorder = false, this.padding = 20, this.width})
      : super(key: key);

  @override
  _ConfirmationCardState createState() => _ConfirmationCardState();
}

class _ConfirmationCardState extends State<ConfirmationCard> {
  UserModel _userModel;

  getAge(bday) {
    final birthday = DateTime.parse(bday);
    final dtnow = DateTime.now();
    final difference = dtnow.difference(birthday).inDays;
    final age = difference / 365;
    return age.toStringAsFixed(0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  void startFollowUser() async {
    try {
      var sendBody = {
        "me": _userModel.id,
        "request_id": widget.reqmodel.id,
        "user_name": _userModel.name,
        "followed_by": widget.reqmodel.followerID
      };
      // print(sendBody);
      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

      var req = await http.post('${Constants.SERVER_URL}user/acceptrequest',
          headers: requestHeaders, body: convert.jsonEncode(sendBody));

      var res = convert.jsonDecode(req.body);
      print("**************************************************");
      print(res);
      if (!res['error']) {
        setState(() {
          widget.reqmodel.isShowing = false;
          _userModel.followercount++;
        });
        Fluttertoast.showToast(
            msg: "You accepted ${widget.reqmodel.name}'s request");
        print("follow user success ---");
      }
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    } finally {}
  }

  void startDeqReq() async {
    try {
      var req = await http.post('${Constants.SERVER_URL}user/declinerequest',
          body: {
            'user_id': '${_userModel.id}',
            'followed_by ': '${widget.reqmodel.followerID}'
          });
      print("hutttttooooooooooooooooo");

      var res = convert.jsonDecode(req.body);
      if (!res['error']) {
        setState(() {
          widget.reqmodel.isShowing = false;
        });
        Fluttertoast.showToast(
            msg: "You Declined ${widget.reqmodel.name}'s request");
        print("follow user success ---");
      }
    } catch (err) {} finally {}
  }

  @override
  Widget build(BuildContext context) {
    return widget.reqmodel.isShowing
        ? Container(
            padding: EdgeInsets.fromLTRB(widget.padding, widget.padding / 2,
                widget.padding, widget.padding / 2),
            // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleUser(
                      withBorder: widget.withBorder,
                      size: 60,
                      url: widget.reqmodel.imagesource == "userimage"
                          ? "${Constants.USERS_PROFILES_URL}" +
                              "${widget.reqmodel.img}"
                          : "${widget.reqmodel.fb_url}",
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: widget.width,
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${widget.reqmodel.name}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.venus,
                                    size: 15,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "${getAge(widget.reqmodel.bday)}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                              Text(
                                "${widget.reqmodel.followercount} " +
                                    'Followers',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          startFollowUser();
                        },
                        child: RoundedBorderButton(
                          "CONFIRM",
                          color1: Color.fromRGBO(255, 94, 58, 1),
                          color2: Color.fromRGBO(255, 149, 0, 1),
                          textColor: Colors.white,
                          width: 80,
                          fontSize: 10,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          startDeqReq();
                        },
                        child: RoundedBorderButton(
                          "DELETE",
                          color1: Colors.grey[200],
                          color2: Colors.grey[200],
                          textColor: Colors.blueGrey[700],
                          width: 80,
                          fontSize: 10,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
