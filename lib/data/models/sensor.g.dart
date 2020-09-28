// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sensor _$SensorFromJson(Map<String, dynamic> json) {
  return Sensor(
    dbId: json['dbId'] as String,
    id: json['id'] as String,
    latitude: (json['lat'] as num)?.toDouble(),
    longitude: (json['lon'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$SensorToJson(Sensor instance) => <String, dynamic>{
      'dbId': instance.dbId,
      'id': instance.id,
      'lat': instance.latitude,
      'lon': instance.longitude,
    };
