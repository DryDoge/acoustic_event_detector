part of 'sensors_bloc.dart';

abstract class SensorsEvent extends Equatable {
  const SensorsEvent();

  @override
  List<Object> get props => [];
}

class SensorsRequested extends SensorsEvent {
  const SensorsRequested();
}

class SensorAddRequested extends SensorsEvent {
  final String id;
  final double latitude;
  final double longitude;
  SensorAddRequested({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
  });

  @override
  List<Object> get props => [id, latitude, longitude];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorAddRequested &&
        o.id == id &&
        o.latitude == latitude &&
        o.longitude == longitude;
  }

  @override
  int get hashCode => id.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
