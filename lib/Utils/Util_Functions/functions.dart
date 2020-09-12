import 'package:folk/utils/Constants.dart';

class Functions{

  //this returns age function
  static String getAge(bday) {
    final birthday = DateTime.parse(bday);
    final dtnow = DateTime.now();
    final difference = dtnow.difference(birthday).inDays;
    final age = difference / 365;
    return age.toStringAsFixed(0);
  }

   //this determines & returns the imgurl
   static String initPorfileImge(imagesource, fburl, img) {
    String url = "";

    if (imagesource == "fb") {
      url = fburl;
    } else {
      url = "${Constants.USERS_PROFILES_URL}" + img;
    }

    return url;
  }
}