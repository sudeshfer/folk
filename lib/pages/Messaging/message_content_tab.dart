import 'package:flutter/material.dart';
import 'package:folk/pages/Messaging/chat_screen.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';

class MessagesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      // color: Colors.yellow[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Queue(width: width),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Messages",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Recent",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                MessageCard(),
                MessageCard(isRead: false),
                MessageCard(),
                MessageCard(),
                MessageCard(),
                SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildUserCard(context, double width) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: width * 0.2 + 10,
            // child: CircleUserBundle(width: width, urlList: ,),
          )
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final bool isRead;
  const MessageCard({
    this.isRead = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
      margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: (isRead) ? Colors.grey[100] : Colors.transparent,
      ),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => ChatScreen(
          //             urlList: imgList,
          //           )),
          // );
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircleUserBundle(
              size: 60,
              urlList: imgList,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Raymond",
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "(4)",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Text(
                        "2 hours ago",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "It's going well how about you?",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Queue extends StatelessWidget {
  const Queue({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Queue",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            height: width * 0.2 + 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                QueueCard(
                  width: width * .2,
                  urlList: imgList,
                  isOnline: true,
                ),
                QueueCard(
                  width: width * .2,
                  urlList: imgList,
                  isOnline: true,
                ),
                QueueCard(
                  width: width * .2,
                  urlList: imgList,
                  isOnline: true,
                ),
                QueueCard(
                  width: width * .2,
                  urlList: imgList,
                  isOnline: true,
                ),
                QueueCard(
                  width: width * .2,
                  urlList: imgList,
                  isOnline: true,
                ),
                QueueCard(
                  width: width * .2,
                  urlList: imgList,
                  isOnline: true,
                ),
                QueueCard(
                  width: width * .2,
                  urlList: imgList,
                  isOnline: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class QueueCard extends StatelessWidget {
  final double width;
  final bool isOnline;
  final List<String> urlList;
  const QueueCard({
    @required this.width,
    @required this.urlList,
    this.isOnline = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 5, 10),
      // color: Colors.yellow[100],
      width: width + 10,
      // height: width * 0.1,
      child: Column(
        children: <Widget>[
          CircleUserBundle(
            size: width,
            urlList: urlList,
            isOnline: isOnline,
          ),
          SizedBox(height: 5),
          Text(
            "Charlotte",
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class CircleUserBundle extends StatelessWidget {
  final List<String> urlList;
  final double size;
  final bool isOnline;

  CircleUserBundle({
    @required this.urlList,
    @required this.size,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Stack(
        // alignment: Alignment.topCenter,
        children: <Widget>[
          (urlList.length >= 1)
              ? AlignedCircleUser(
                  Alignment(0, 0),
                  CircleUser(
                    size: size * 0.9,
                    url: urlList[0],
                  ),
                )
              : Container(),
          (urlList.length >= 2)
              ? AlignedCircleUser(
                  Alignment.bottomLeft,
                  CircleUser(
                    size: size * 0.45,
                    url: urlList[1],
                  ),
                )
              : Container(),
          (urlList.length >= 3)
              ? AlignedCircleUser(
                  Alignment.bottomRight,
                  CircleUser(
                    size: size * 0.45,
                    url: urlList[2],
                    val: 4,
                  ),
                )
              : Container(),
          (urlList.length >= 4)
              ? AlignedCircleUser(
                  Alignment.topLeft,
                  CircleUser(
                    size: size * 0.45,
                    url: urlList[3],
                  ),
                )
              : Container(),
          (urlList.length >= 5)
              ? AlignedCircleUser(
                  Alignment.topRight,
                  CircleUser(
                    size: size * 0.45,
                    url: urlList[4],
                  ),
                )
              : Container(),
          (urlList.length > 5)
              ? AlignedCircleUser(
                  Alignment.topRight,
                  CircleUser(
                    size: size * 0.45,
                    val: urlList.length - 4,
                    fontSize: 12,
                  ),
                )
              : Container(),
          (isOnline)
              ? AlignedCircleUser(
                  Alignment.bottomRight,
                  CircleUser(
                    size: 18,
                    color: Colors.deepOrange,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
