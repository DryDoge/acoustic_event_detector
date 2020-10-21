import 'package:json_annotation/json_annotation.dart';

part 'historical_event.g.dart';

@JsonSerializable()
class HistoricalEvent {
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
  HistoricalEvent({
    this.id,
    this.centerLatitude,
    this.centerLongitude,
    this.happened,
    this.sensorsCount,
  });

  factory HistoricalEvent.fromJson(Map<String, dynamic> json) =>
      _$HistoricalEventFromJson(json);

  Map<String, dynamic> toJson() => _$HistoricalEventToJson(this);
}

@JsonSerializable()
class HistoricalEventSensor {
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lon')
  final double longitude;

  HistoricalEventSensor({this.latitude, this.longitude});

  factory HistoricalEventSensor.fromJson(Map<String, dynamic> json) =>
      _$HistoricalEventSensorFromJson(json);

  Map<String, dynamic> toJson() => _$HistoricalEventSensorToJson(this);
}

class HistoricalEventWrapper {
  final HistoricalEvent event;
  final List<HistoricalEventSensor> sensors;

  HistoricalEventWrapper({this.event, this.sensors});
}
