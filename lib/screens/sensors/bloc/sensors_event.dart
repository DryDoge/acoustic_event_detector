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
  final String address;
  AddSensor({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
    @required this.address,
  });

  @override
  List<Object> get props => [
        id,
        latitude,
        longitude,
        address,
      ];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AddSensor &&
        o.id == id &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode;
  }
}

class UpdateSensor extends SensorsEvent {
  final int id;
  final double latitude;
  final double longitude;
  final String address;
  final Sensor oldSensor;
  UpdateSensor({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
    @required this.oldSensor,
    @required this.address,
  });

  @override
  List<Object> get props => [id, latitude, longitude, oldSensor, address];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UpdateSensor &&
        o.id == id &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.address == address &&
        o.oldSensor == oldSensor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        address.hashCode ^
        oldSensor.hashCode;
  }
}
