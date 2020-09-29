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

class SensorAddedSuccess extends SensorsState {
  final Sensor sensor;
  final List<Sensor> sensors;

  const SensorAddedSuccess({
    @required this.sensor,
    @required this.sensors,
  });

  @override
  List<Object> get props => [sensor, sensors];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorAddedSuccess &&
        o.sensor == sensor &&
        listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => sensor.hashCode ^ sensors.hashCode;
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
