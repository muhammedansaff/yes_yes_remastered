import 'Features.dart';
import 'Query.dart';
import 'dart:convert';

Geolocator geolocatorFromJson(String str) => Geolocator.fromJson(json.decode(str));
String geolocatorToJson(Geolocator data) => json.encode(data.toJson());
class Geolocator {
  Geolocator({
      this.type, 
      this.features, 
      this.query,});

  Geolocator.fromJson(dynamic json) {
    type = json['type'];
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
    query = json['query'] != null ? Query.fromJson(json['query']) : null;
  }
  String? type;
  List<Features>? features;
  Query? query;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (features != null) {
      map['features'] = features?.map((v) => v.toJson()).toList();
    }
    if (query != null) {
      map['query'] = query?.toJson();
    }
    return map;
  }

}