import 'dart:async';

import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/data/repositories/sensors_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';

class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  final SensorsRepository sensorsRepository;
  StreamSubscription _subscription;

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
        await _subscription?.cancel();
        _subscription = sensorsRepository.sensors.listen(
          (QuerySnapshot _snapshot) => add(
            _SensorsLoaded(_snapshot.sensors),
          ),
        );
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }

    if (event is _SensorsLoaded) {
      yield SensorsLoaded(sensors: event.sensors);
    }

    if (event is AddSensorRequested) {
      yield SensorsLoading();
      try {
        yield AddSensorInitial();
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }

    if (event is AddSensor) {
      yield SensorsLoading();
      try {
        final added = await sensorsRepository.addSensor(
          id: event.id,
          latitude: event.latitude,
          longitude: event.longitude,
          address: event.address,
        );
        if (added) {
          final Sensor addedSensor = await sensorsRepository.findSensorById(
            id: event.id,
          );
          yield SensorAdded(addedSensor: addedSensor);
          await _subscription?.cancel();
          _subscription = sensorsRepository.sensors.listen(
            (QuerySnapshot _snapshot) => add(
              _SensorsLoaded(_snapshot.sensors),
            ),
          );
        }
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }
    if (event is UpdateSensorRequested) {
      yield SensorsLoading();
      try {
        yield UpdateSensorInitial(sensorToBeUpdated: event.sensorToBeUpdated);
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }

    if (event is UpdateSensor) {
      yield SensorsLoading();
      try {
        final updated = await sensorsRepository.updateSensor(
          oldSensor: event.oldSensor,
          id: event.id,
          latitude: event.latitude,
          longitude: event.longitude,
          address: event.address,
        );

        if (updated) {
          final Sensor updatedSensor = await sensorsRepository.findSensorById(
            id: event.id,
          );

          yield SensorUpdated(updatedSensor: updatedSensor);
          await _subscription?.cancel();
          _subscription = sensorsRepository.sensors.listen(
            (QuerySnapshot _snapshot) => add(
              _SensorsLoaded(_snapshot.sensors),
            ),
          );
        }
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }

    if (event is DeleteSensor) {
      yield SensorsLoading();

      try {
        final deleted = await sensorsRepository.deleteSensor(
            sensorDbId: event.sensorToBeDeleted.dbId);

        if (deleted) {
          yield SensorDeleted();
          await _subscription?.cancel();
          _subscription = sensorsRepository.sensors.listen(
            (QuerySnapshot _snapshot) => add(
              _SensorsLoaded(_snapshot.sensors),
            ),
          );
        }
      } catch (error) {
        yield SensorsError(message: error.toString());
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
