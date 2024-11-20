import 'dart:convert';

Timezone timezoneFromJson(String str) => Timezone.fromJson(json.decode(str));
String timezoneToJson(Timezone data) => json.encode(data.toJson());
class Timezone {
  Timezone({
      this.name, 
      this.offsetSTD, 
      this.offsetSTDSeconds, 
      this.offsetDST, 
      this.offsetDSTSeconds, 
      this.abbreviationSTD, 
      this.abbreviationDST,});

  Timezone.fromJson(dynamic json) {
    name = json['name'];
    offsetSTD = json['offset_STD'];
    offsetSTDSeconds = json['offset_STD_seconds'];
    offsetDST = json['offset_DST'];
    offsetDSTSeconds = json['offset_DST_seconds'];
    abbreviationSTD = json['abbreviation_STD'];
    abbreviationDST = json['abbreviation_DST'];
  }
  String? name;
  String? offsetSTD;
  num? offsetSTDSeconds;
  String? offsetDST;
  num? offsetDSTSeconds;
  String? abbreviationSTD;
  String? abbreviationDST;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['offset_STD'] = offsetSTD;
    map['offset_STD_seconds'] = offsetSTDSeconds;
    map['offset_DST'] = offsetDST;
    map['offset_DST_seconds'] = offsetDSTSeconds;
    map['abbreviation_STD'] = abbreviationSTD;
    map['abbreviation_DST'] = abbreviationDST;
    return map;
  }

}