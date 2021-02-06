// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as String,
    centerLatitude: (json['center_lat'] as num)?.toDouble(),
    centerLongitude: (json['center_lon'] as num)?.toDouble(),
    happened: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    sensorsCount: json['sensors_count'] as int,
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'center_lat': instance.centerLatitude,
      'center_lon': instance.centerLongitude,
      'timestamp': instance.happened?.toIso8601String(),
      'sensors_count': instance.sensorsCount,
    };

EventSensor _$EventSensorFromJson(Map<String, dynamic> json) {
  return EventSensor(
    latitude: (json['lat'] as num)?.toDouble(),
    longitude: (json['lon'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$EventSensorToJson(EventSensor instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'lon': instance.longitude,
    };
