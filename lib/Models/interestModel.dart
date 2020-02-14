class Interest {
  String intType;
  String intName;
  
 
  Interest({this.intType,this.intName });
 
  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      intType: json["itype"] as String,
      intName: json["iname"] as String,
    );
  }
}