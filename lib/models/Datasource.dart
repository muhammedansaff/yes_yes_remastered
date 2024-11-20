import 'dart:convert';

Datasource datasourceFromJson(String str) => Datasource.fromJson(json.decode(str));
String datasourceToJson(Datasource data) => json.encode(data.toJson());
class Datasource {
  Datasource({
      this.sourcename, 
      this.attribution, 
      this.license, 
      this.url,});

  Datasource.fromJson(dynamic json) {
    sourcename = json['sourcename'];
    attribution = json['attribution'];
    license = json['license'];
    url = json['url'];
  }
  String? sourcename;
  String? attribution;
  String? license;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sourcename'] = sourcename;
    map['attribution'] = attribution;
    map['license'] = license;
    map['url'] = url;
    return map;
  }

}