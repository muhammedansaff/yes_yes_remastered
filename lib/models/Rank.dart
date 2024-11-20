import 'dart:convert';

Rank rankFromJson(String str) => Rank.fromJson(json.decode(str));
String rankToJson(Rank data) => json.encode(data.toJson());
class Rank {
  Rank({
      this.importance, 
      this.popularity,});

  Rank.fromJson(dynamic json) {
    importance = json['importance'];
    popularity = json['popularity'];
  }
  num? importance;
  num? popularity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['importance'] = importance;
    map['popularity'] = popularity;
    return map;
  }

}