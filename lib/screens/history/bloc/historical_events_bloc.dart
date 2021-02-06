import 'dart:async';

import 'package:acoustic_event_detector/data/models/event.dart';
import 'package:acoustic_event_detector/data/repositories/events_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'historical_events_event.dart';

part 'historical_events_state.dart';

class HistoricalEventsBloc
    extends Bloc<HistoricalEventsEvent, HistoricalEventsState> {
  final EventsRepository eventsRepository;
  StreamSubscription _subscription;

  HistoricalEventsBloc({
    @required this.eventsRepository,
  }) : super(HistoricalEventsLoading());

  @override
  Stream<HistoricalEventsState> mapEventToState(
    HistoricalEventsEvent event,
  ) async* {
    if (event is HistoricalEventsRequested) {
      yield HistoricalEventsLoading();
      try {
        await _subscription?.cancel();
        _subscription = eventsRepository.oldEvents.listen(
          (QuerySnapshot _snapshot) => add(
            _HistoricalEventsLoaded(_snapshot.eventsFromSnapshot),
          ),
        );
      } catch (error) {
        yield HistoricalEventsError(message: error.toString());
      }
    }

    if (event is _HistoricalEventsLoaded) {
      yield HistoricalEventsLoaded(events: event.events);
    }

    if (event is DeleteHistoricalEvent) {
      yield HistoricalEventsLoading();
      try {
        final deleted = await eventsRepository.deleteHistoricalEvent(
            eventId: event.eventToBeDeleted.id);
        if (deleted) {
          yield HistoricalEventsDeleted();
          await _subscription?.cancel();
          _subscription = eventsRepository.oldEvents.listen(
            (QuerySnapshot _snapshot) => add(
              _HistoricalEventsLoaded(_snapshot.eventsFromSnapshot),
            ),
          );
        }
      } catch (error) {
        yield HistoricalEventsError(message: error.toString());
      }
    }

    if (event is HistoricalEventAdd) {
      try {
        final added = await eventsRepository.addHistoricalEvent(
          id: event.event.id,
          centerLatitude: event.event.centerLatitude,
          centerLongitude: event.event.centerLongitude,
          sensors: event.sensors,
        );
        if (added) {
          await _subscription?.cancel();
          _subscription = eventsRepository.oldEvents.listen(
            (QuerySnapshot _snapshot) => add(
              _HistoricalEventsLoaded(_snapshot.eventsFromSnapshot),
            ),
          );
        }
      } catch (error) {
        yield HistoricalEventsError(message: error.toString());
      }
    }
    if (event is HistoricalEventDetailRequested) {
      yield HistoricalEventsLoading();
      try {
        yield HistoricalEventDetail(sensors: event.sensors, event: event.event);
      } catch (error) {
        yield HistoricalEventsError(message: error.toString());
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
