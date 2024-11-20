import 'dart:convert';

Query queryFromJson(String str) => Query.fromJson(json.decode(str));
String queryToJson(Query data) => json.encode(data.toJson());
class Query {
  Query({
      this.lat, 
      this.lon, 
      this.plusCode,});

  Query.fromJson(dynamic json) {
    lat = json['lat'];
    lon = json['lon'];
    plusCode = json['plus_code'];
  }
  num? lat;
  num? lon;
  String? plusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lon'] = lon;
    map['plus_code'] = plusCode;
    return map;
  }

}