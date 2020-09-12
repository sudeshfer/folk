import 'package:flutter/material.dart';
import 'package:folk/models/followerModel.dart';
import 'package:folk/pages/Events/Widgets/event_participants_list.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EventParticipantList extends StatefulWidget {
  final userid;
  final eventId;
  EventParticipantList(this.eventId, this.userid, {Key key}) : super(key: key);

  @override
  _EventParticipantListState createState() => _EventParticipantListState();
}

class _EventParticipantListState extends State<EventParticipantList> {
  List<FollowerModel> _listParticipants = [];
  bool isfetched = true;
  bool isEmpty = false;
  int length = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParticipants();
  }

  getParticipants() {
    //start get Posts !
    print("get participants running............................." +
        widget.userid +
        " " +
        widget.eventId);

    String _url = "${Constants.SERVER_URL}event/geteventusers";
    return http.post(_url, body: {
      'user_id': widget.userid,
      'event_id': widget.eventId
    }).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        print(data);
        setState(() {
          _listParticipants =
              data.map((data) => FollowerModel.fromJson(data)).toList();
          isfetched = false;
          length = _listParticipants.length;
        });
        print(
            "participants arrayyyyyyyyyyyyyy length ${_listParticipants.length}");
      } else {
        print("empty response  ${convertedData['data']}");
        setState(() {
          isfetched = false;
          isEmpty = true;
        });
      }
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  initImgeUrl(index) {
    String url = "";

    if (_listParticipants[index].imagesource == "fb") {
      url = _listParticipants[index].fb_url;
    } else {
      url = "${Constants.USERS_PROFILES_URL}" + _listParticipants[index].img;
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return !isEmpty
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EventParticipantListFull(_listParticipants)),
              );
            },
            child: Container(
              alignment: Alignment.centerLeft,
              // color: Colors.red[100],
              width: 90,
              child: Stack(
                children: <Widget>[
                  isfetched
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : _listParticipants.length >= 1
                          ? AlignedCircleUser(
                              Alignment(0.33, 0),
                              CircleUser(
                                url: initImgeUrl(2),
                                // "https://linustechtips.com/main/uploads/monthly_2017_04/cool-cat.thumb.jpg.cae04ebfb8304d3e1592f0d04c24f85d.jpg",
                              ),
                            )
                          : Container(),
                  isfetched
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : _listParticipants.length >= 2
                          ? AlignedCircleUser(
                              Alignment(-0.33, 0),
                              CircleUser(
                                url: initImgeUrl(1),
                                // "https://hips.hearstapps.com/ell.h-cdn.co/assets/16/41/980x980/square-1476463747-coconut-oil-final-lowres.jpeg?resize=480:*",
                              ),
                            )
                          : Container(),
                  isfetched
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : _listParticipants.length >= 3
                          ? AlignedCircleUser(
                              Alignment(-1, 0),
                              CircleUser(
                                url: initImgeUrl(3),
                                // "https://i.pinimg.com/236x/00/f0/85/00f0854dc796254312890d7df2b02f9c.jpg",
                              ),
                            )
                          : Container(),
                  isfetched
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : _listParticipants.length >= 4
                          ? AlignedCircleUser(
                              Alignment(1, 0),
                              CircleUser(
                                val: 4,
                              ),
                            )
                          : Container(),
                ],
              ),
            ),
          )
        : Container();
  }
}
