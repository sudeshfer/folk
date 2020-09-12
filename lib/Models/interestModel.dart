class Interest {
  String catiId;
  String intType;
  List<InterestData> interestData;

  Interest({this.catiId, this.intType, this.interestData});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      catiId: json["_id"] as String,
      intType: json["itype"] as String,
      interestData: (json['interests'] as List)
          ?.map((i) => InterestData.fromJson(i))
          ?.toList(),
    );
  }
}

class InterestData {
  String interestname;
  String interestid;

  InterestData({this.interestname, this.interestid});

  InterestData.fromJson(Map<String, dynamic> json) {
    interestname = json['iname'];
    interestid = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iname'] = this.interestname;
    data['_id'] = this.interestid;
    return data;
  }
}
