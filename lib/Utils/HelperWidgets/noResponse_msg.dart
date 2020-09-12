import 'package:flutter/material.dart';

class Noresponse extends StatelessWidget {
  const Noresponse({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
         height: MediaQuery.of(context).size.height /3,
         width: MediaQuery.of(context).size.width /1.5,
         decoration: BoxDecoration(
             image: DecorationImage(
                 image: AssetImage('assets/images/noposts.jpg'),
                 fit: BoxFit.cover))),
    );
  }
}