import 'dart:async';

import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';

class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  SensorsBloc() : super(SensorsLoading());

  @override
  Stream<SensorsState> mapEventToState(
    SensorsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
