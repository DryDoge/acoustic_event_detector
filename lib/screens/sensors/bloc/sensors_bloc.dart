import 'dart:async';

import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/data/repositories/sensors_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';

class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  final SensorsRepository sensorsRepository;

  SensorsBloc({
    @required this.sensorsRepository,
  }) : super(SensorsLoading());

  @override
  Stream<SensorsState> mapEventToState(
    SensorsEvent event,
  ) async* {
    if (event is SensorsRequested) {
      yield SensorsLoading();
      try {
        final List<Sensor> sensors = await sensorsRepository.getAllSensors();
        yield SensorsLoaded(sensors: sensors);
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }
    if (event is SensorAddRequested) {
      yield SensorsLoading();
      try {
        final bool added = await sensorsRepository.addSensor(
          id: event.id,
          latitude: event.latitude,
          longitude: event.longitude,
        );

        if (added) {
          final List<Sensor> sensors = await sensorsRepository.getAllSensors();
          final Sensor addedSensor =
              await sensorsRepository.findSensorById(id: event.id);

          yield SensorAddedSuccess(sensors: sensors, sensor: addedSensor);
        }
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }
  }
}
