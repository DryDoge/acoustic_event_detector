part of 'sensors_bloc.dart';

abstract class SensorsEvent extends Equatable {
  const SensorsEvent();

  @override
  List<Object> get props => [];
}

class SensorsRequested extends SensorsEvent {
  const SensorsRequested();
}

class DeleteSensor extends SensorsEvent {
  final Sensor sensorToBeDeleted;

  const DeleteSensor({this.sensorToBeDeleted});

  @override
  List<Object> get props => [sensorToBeDeleted];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DeleteSensor && o.sensorToBeDeleted == sensorToBeDeleted;
  }

  @override
  int get hashCode => sensorToBeDeleted.hashCode;
}

class AddSensorRequested extends SensorsEvent {
  const AddSensorRequested();
}

class UpdateSensorRequested extends SensorsEvent {
  final Sensor sensorToBeUpdated;
  const UpdateSensorRequested({
    this.sensorToBeUpdated,
  });

  @override
  List<Object> get props => [sensorToBeUpdated];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UpdateSensorRequested &&
        o.sensorToBeUpdated == sensorToBeUpdated;
  }

  @override
  int get hashCode => sensorToBeUpdated.hashCode;
}

class _SensorsLoaded extends SensorsEvent {
  final List<Sensor> sensors;

  _SensorsLoaded(this.sensors);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _SensorsLoaded && listEquals(o.sensors, sensors);
  }

  @override
  List<Object> get props => [sensors];

  @override
  int get hashCode => sensors.hashCode;
}

class AddSensor extends SensorsEvent {
  final int id;
  final double latitude;
  final double longitude;
  AddSensor({
    this.id,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object> get props => [
        id,
        latitude,
        longitude,
      ];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AddSensor &&
        o.id == id &&
        o.latitude == latitude &&
        o.longitude == longitude;
  }

  @override
  int get hashCode => id.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}

class UpdateSensor extends SensorsEvent {
  final int id;
  final double latitude;
  final double longitude;
  final Sensor oldSensor;
  UpdateSensor({
    this.id,
    this.latitude,
    this.longitude,
    this.oldSensor,
  });

  @override
  List<Object> get props => [
        id,
        latitude,
        longitude,
        oldSensor,
      ];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UpdateSensor &&
        o.id == id &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.oldSensor == oldSensor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        oldSensor.hashCode;
  }
}
