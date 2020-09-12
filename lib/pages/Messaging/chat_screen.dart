import 'package:flutter/material.dart';
import 'package:folk/pages/Messaging/message_content_tab.dart';
// import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:folk/utils/HelperWidgets/read_more_text.dart';

class ChatScreen extends StatelessWidget {
  // final List<String> urlList;
  // ChatScreen({
  //   @required this.urlList,
  // });

   final List<String> urlList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildChatAppBar(urlList),
      body: Stack(
        children: <Widget>[
          Container(
            height: height - 155,
            child: ListView(
              children: <Widget>[
                buildInfoBox(width),
                buildMessage(width),
                buildMyMessage(width),
                buildMessage(width),
                buildMyMessage(width),
                buildMessage(width),
                buildMyMessage(width),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomTextField(width: width),
          ),
        ],
      ),
    );
  }

  Widget buildMyMessage(double width) {
    return MyChatMessage(
      width: width,
    );
  }

  Widget buildMessage(double width) {
    return ChatMessage(
      width: width,
    );
  }

  Container buildInfoBox(double width) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(20),
        color: Colors.grey[100],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: width - 165,
            child: ReadMoreText(
              "A successful marketing plan relies heavily on the pulling.A successful marketing plan relies heavily on the pulling.A successful marketing plan relies heavily on the pulling.",
              expandingButtonColor: Colors.deepOrange,
              minLines: 2,
            ),
          ),
          RoundedBorderButton(
            "Read in Full",
            color1: Color.fromRGBO(255, 94, 58, 1),
            color2: Color.fromRGBO(255, 149, 0, 1),
            textColor: Colors.white,
            width: 120,
            shadowColor: Colors.transparent,
            fontSize: 14,
          )
        ],
      ),
    );
  }

  Widget buildChatAppBar(List<String> urlList) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
        color: Colors.grey[100],
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                CircleUserBundle(
                  size: 60,
                  urlList: urlList,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Susie, Mark, Antoine...",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FaIcon(
                FontAwesomeIcons.ellipsisH,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomTextField extends StatelessWidget {
  const BottomTextField({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            offset: new Offset(5.0, 6.0),
            spreadRadius: 2.0,
            blurRadius: 12.0,
          )
        ],
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: FaIcon(FontAwesomeIcons.laugh),
          ),
          Container(
            width: width * 0.65,
            child: TextField(
              decoration: InputDecoration(hintText: "Write a message"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: Image(
              image: AssetImage("assets/images/ic_send.png"),
              width: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class MyChatMessage extends StatelessWidget {
  final double width;
  const MyChatMessage({
    @required this.width,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: width * 0.85,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            color: Color.fromRGBO(255, 94, 58, 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "09.50 AM",
                      style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "It's going well how about you? It's going well how about you? It's going well how about you?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ChatMessage extends StatefulWidget {
  final double width;
  const ChatMessage({
    @required this.width,
    Key key,
  }) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: widget.width * 0.85,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Colors.grey[100],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleUser(
                size: 60,
                // urlList: imgList,
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
                      "It's going well how about you? It's going well how about you? It's going well how about you?",
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
        GestureDetector(
          onTap: () {
            setState(() {
              liked = !liked;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FaIcon(
              FontAwesomeIcons.solidHeart,
              color: (liked) ? Colors.red : Colors.red[100],
            ),
          ),
        )
      ],
    );
  }
}
