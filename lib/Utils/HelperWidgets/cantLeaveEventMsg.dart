import 'package:flutter/material.dart';

class CantLeaveEvent extends StatelessWidget {
  const CantLeaveEvent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You can't leave this event. Since its 8 hours has left to start the event",
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 35,
                    ),
                  ],
                ),
              );
  }
}