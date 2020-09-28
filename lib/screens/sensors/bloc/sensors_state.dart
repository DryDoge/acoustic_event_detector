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

  const SensorsLoaded(this.sensors);

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

class SensorsAdding extends SensorsState {
  final List<Sensor> sensors;

  const SensorsAdding(this.sensors);

  @override
  List<Object> get props => [sensors];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SensorsAdding && listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => sensors.hashCode;
}

class SensorsError extends SensorsState {
  final String message;

  const SensorsError(this.message);

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
