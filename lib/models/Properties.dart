import 'Datasource.dart';
import 'Timezone.dart';
import 'Rank.dart';
import 'dart:convert';

Properties propertiesFromJson(String str) => Properties.fromJson(json.decode(str));
String propertiesToJson(Properties data) => json.encode(data.toJson());
class Properties {
  Properties({
      this.datasource, 
      this.country, 
      this.countryCode, 
      this.state, 
      this.stateDistrict, 
      this.county, 
      this.city, 
      this.postcode, 
      this.lon, 
      this.lat, 
      this.stateCode, 
      this.distance, 
      this.resultType, 
      this.formatted, 
      this.addressLine1, 
      this.addressLine2, 
      this.timezone, 
      this.plusCode, 
      this.rank, 
      this.placeId,});

  Properties.fromJson(dynamic json) {
    datasource = json['datasource'] != null ? Datasource.fromJson(json['datasource']) : null;
    country = json['country'];
    countryCode = json['country_code'];
    state = json['state'];
    stateDistrict = json['state_district'];
    county = json['county'];
    city = json['city'];
    postcode = json['postcode'];
    lon = json['lon'];
    lat = json['lat'];
    stateCode = json['state_code'];
    distance = json['distance'];
    resultType = json['result_type'];
    formatted = json['formatted'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    timezone = json['timezone'] != null ? Timezone.fromJson(json['timezone']) : null;
    plusCode = json['plus_code'];
    rank = json['rank'] != null ? Rank.fromJson(json['rank']) : null;
    placeId = json['place_id'];
  }
  Datasource? datasource;
  String? country;
  String? countryCode;
  String? state;
  String? stateDistrict;
  String? county;
  String? city;
  String? postcode;
  num? lon;
  num? lat;
  String? stateCode;
  num? distance;
  String? resultType;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  Timezone? timezone;
  String? plusCode;
  Rank? rank;
  String? placeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (datasource != null) {
      map['datasource'] = datasource?.toJson();
    }
    map['country'] = country;
    map['country_code'] = countryCode;
    map['state'] = state;
    map['state_district'] = stateDistrict;
    map['county'] = county;
    map['city'] = city;
    map['postcode'] = postcode;
    map['lon'] = lon;
    map['lat'] = lat;
    map['state_code'] = stateCode;
    map['distance'] = distance;
    map['result_type'] = resultType;
    map['formatted'] = formatted;
    map['address_line1'] = addressLine1;
    map['address_line2'] = addressLine2;
    if (timezone != null) {
      map['timezone'] = timezone?.toJson();
    }
    map['plus_code'] = plusCode;
    if (rank != null) {
      map['rank'] = rank?.toJson();
    }
    map['place_id'] = placeId;
    return map;
  }

}