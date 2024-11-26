import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'map_marker.g.dart';

@JsonSerializable()
class MapMarker extends Equatable{
  final double latitude;
  final double longitude;
  final String name;
  final String description;
  final MarkerType markerType;

  const MapMarker({required this.latitude, required this.longitude, required this.name, required this.description, required this.markerType});

  factory MapMarker.fromJson(Map<String, dynamic> json) => _$MapMarkerFromJson(json);
  Map<String, dynamic> toJson() => _$MapMarkerToJson(this);
  
  @override
  // TODO: implement props
  List<Object?> get props => [latitude,longitude,name];

}

enum MarkerType{
  cycle(Icons.pedal_bike,Colors.blue),
  shopping(Icons.shopping_cart,Colors.green),
  restaurant(Icons.food_bank,Colors.red);

  final IconData icon;
  final Color color;

  const MarkerType(this.icon,this.color);
}

