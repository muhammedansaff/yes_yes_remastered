import 'Properties.dart';
import 'Geometry.dart';
import 'dart:convert';

Features featuresFromJson(String str) => Features.fromJson(json.decode(str));
String featuresToJson(Features data) => json.encode(data.toJson());
class Features {
  Features({
      this.type, 
      this.properties, 
      this.geometry, 
      this.bbox,});

  Features.fromJson(dynamic json) {
    type = json['type'];
    properties = json['properties'] != null ? Properties.fromJson(json['properties']) : null;
    geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    bbox = json['bbox'] != null ? json['bbox'].cast<num>() : [];
  }
  String? type;
  Properties? properties;
  Geometry? geometry;
  List<num>? bbox;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (properties != null) {
      map['properties'] = properties?.toJson();
    }
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    map['bbox'] = bbox;
    return map;
  }

}