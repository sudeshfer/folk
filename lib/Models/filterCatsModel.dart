import 'dart:convert';

class FilterCats {
  String catName;

  FilterCats({
    this.catName,
  });

  factory FilterCats.fromJson(String str) =>
      FilterCats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FilterCats.fromMap(Map<String, dynamic> json) =>
      FilterCats(catName: json["catName"]);

  Map<String, dynamic> toMap() => {"catName": catName};
}