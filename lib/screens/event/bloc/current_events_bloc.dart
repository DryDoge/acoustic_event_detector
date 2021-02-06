import 'dart:async';

import 'package:acoustic_event_detector/data/models/event.dart';
import 'package:acoustic_event_detector/data/repositories/events_repository.dart';
import 'package:acoustic_event_detector/services/location_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'current_events_event.dart';

part 'current_events_state.dart';

class CurrentEventsBloc extends Bloc<CurrentEventsEvent, CurrentEventsState> {
  final EventsRepository eventsRepository;
  StreamSubscription _subscription;
  final LocationService locationService = LocationService();

  CurrentEventsBloc({
    @required this.eventsRepository,
  }) : super(CurrentEventsLoading());

  @override
  Stream<CurrentEventsState> mapEventToState(
    CurrentEventsEvent event,
  ) async* {
    if (event is CurrentEventsRequested) {
      yield CurrentEventsLoading();
      try {
        await _subscription?.cancel();
        _subscription = eventsRepository.events.listen(
          (QuerySnapshot _snapshot) => add(
            _CurrentEventsLoaded(_snapshot.eventsFromSnapshot),
          ),
        );
      } catch (error) {
        yield CurrentEventsError(message: error.toString());
      }
    }

    if (event is _CurrentEventsLoaded) {
      yield CurrentEventsLoaded(events: event.events);
    }

    if (event is DeleteCurrentEvent) {
      yield CurrentEventsLoading();
      try {
        final deleted = await eventsRepository.deleteCurrentEvent(
            eventId: event.eventToBeDeleted.id);
        if (deleted) {
          await _subscription?.cancel();
          _subscription = eventsRepository.events.listen(
            (QuerySnapshot _snapshot) => add(
              _CurrentEventsLoaded(_snapshot.eventsFromSnapshot),
            ),
          );
        }
      } catch (error) {
        yield CurrentEventsError(message: error.toString());
      }
    }

    if (event is CurrentEventDetailRequested) {
      yield CurrentEventsLoading();
      try {
        yield CurrentEventDetail(sensors: event.sensors, event: event.event);
      } catch (error) {
        yield CurrentEventsError(message: error.toString());
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
