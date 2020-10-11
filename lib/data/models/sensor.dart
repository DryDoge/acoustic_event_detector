import 'package:json_annotation/json_annotation.dart';

part 'sensor.g.dart';

@JsonSerializable()
class Sensor {
  @JsonKey(name: 'dbId')
  final String dbId;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lon')
  final double longitude;

  Sensor({
    this.dbId,
    this.id,
    this.latitude,
    this.longitude,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) => _$SensorFromJson(json);

  Map<String, dynamic> toJson() => _$SensorToJson(this);
}
