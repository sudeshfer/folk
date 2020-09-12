import 'package:flutter/material.dart';

class NoCommentsMsg extends StatelessWidget {
  const NoCommentsMsg({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
         height: MediaQuery.of(context).size.height /4,
        //  width: MediaQuery.of(context).size.width /1.5,
         decoration: BoxDecoration(
             image: DecorationImage(
                 image: AssetImage('assets/images/noComments.png'),
                 fit: BoxFit.fitHeight))),
    );
  }
}