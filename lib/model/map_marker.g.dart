// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapMarker _$MapMarkerFromJson(Map<String, dynamic> json) => MapMarker(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String,
      description: json['description'] as String,
      markerType: $enumDecode(_$MarkerTypeEnumMap, json['markerType']),
    );

Map<String, dynamic> _$MapMarkerToJson(MapMarker instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'name': instance.name,
      'description': instance.description,
      'markerType': _$MarkerTypeEnumMap[instance.markerType]!,
    };

const _$MarkerTypeEnumMap = {
  MarkerType.cycle: 'cycle',
  MarkerType.shopping: 'shopping',
  MarkerType.restaurant: 'restaurant',
};
