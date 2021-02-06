import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'center_lat')
  final double centerLatitude;
  @JsonKey(name: 'center_lon')
  final double centerLongitude;
  @JsonKey(name: 'timestamp')
  final DateTime happened;
  @JsonKey(name: 'sensors_count')
  final int sensorsCount;

  Event({
    this.id,
    this.centerLatitude,
    this.centerLongitude,
    this.happened,
    this.sensorsCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

@JsonSerializable()
class EventSensor {
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lon')
  final double longitude;

  EventSensor({this.latitude, this.longitude});

  factory EventSensor.fromJson(Map<String, dynamic> json) =>
      _$EventSensorFromJson(json);

  Map<String, dynamic> toJson() => _$EventSensorToJson(this);
}

class EventWrapper {
  final Event event;
  final List<EventSensor> sensors;

  EventWrapper({this.event, this.sensors});
}
