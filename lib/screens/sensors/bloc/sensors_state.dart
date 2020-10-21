part of 'sensors_bloc.dart';

abstract class SensorsState extends Equatable {
  const SensorsState();

  @override
  List<Object> get props => [];
}

class SensorsLoading extends SensorsState {
  const SensorsLoading();
}

class SensorsLoaded extends SensorsState {
  final List<Sensor> sensors;

  const SensorsLoaded({@required this.sensors});

  @override
  List<Object> get props => [sensors];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorsLoaded && listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => sensors.hashCode;
}

class SensorsError extends SensorsState {
  final String message;

  const SensorsError({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorsError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class AddSensorInitial extends SensorsState {
  const AddSensorInitial();
}

class SensorAdded extends SensorsState {
  final Sensor addedSensor;

  const SensorAdded({
    this.addedSensor,
  });

  @override
  List<Object> get props => [addedSensor];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorAdded && o.addedSensor == addedSensor;
  }

  @override
  int get hashCode => addedSensor.hashCode;
}

class UpdateSensorInitial extends SensorsState {
  final Sensor sensorToBeUpdated;
  final bool isMap;
  UpdateSensorInitial({
    this.sensorToBeUpdated,
    this.isMap,
  });

  @override
  List<Object> get props => [sensorToBeUpdated, isMap];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UpdateSensorInitial &&
        o.sensorToBeUpdated == sensorToBeUpdated &&
        o.isMap == isMap;
  }

  @override
  int get hashCode => sensorToBeUpdated.hashCode ^ isMap.hashCode;
}

class SensorUpdated extends SensorsState {
  final Sensor updatedSensor;

  const SensorUpdated({
    this.updatedSensor,
  });

  @override
  List<Object> get props => [updatedSensor];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorAdded && o.addedSensor == updatedSensor;
  }

  @override
  int get hashCode => updatedSensor.hashCode;
}

class SensorDeleted extends SensorsState {
  const SensorDeleted();
}

class SensorsMapLoaded extends SensorsState {
  final List<Sensor> sensors;

  const SensorsMapLoaded({this.sensors});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorsMapLoaded && listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => sensors.hashCode;
}
