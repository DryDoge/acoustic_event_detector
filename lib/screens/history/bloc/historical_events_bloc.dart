import 'dart:async';

import 'package:acoustic_event_detector/data/models/historical_event.dart';
import 'package:acoustic_event_detector/data/repositories/history_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'historical_events_event.dart';
part 'historical_events_state.dart';

class HistoricalEventsBloc
    extends Bloc<HistoricalEventsEvent, HistoricalEventsState> {
  final HistoryRepository historyRepository;
  StreamSubscription _subscription;

  HistoricalEventsBloc({
    @required this.historyRepository,
  }) : super(HistoricalEventsLoading());

  @override
  Stream<HistoricalEventsState> mapEventToState(
    HistoricalEventsEvent event,
  ) async* {
    if (event is HistoricalEventsRequested) {
      yield HistoricalEventsLoading();
      try {
        await _subscription?.cancel();
        _subscription = historyRepository.oldEvents.listen(
          (QuerySnapshot _snapshot) => add(
            _HistoricalEventsLoaded(_snapshot.oldEventsFromSnapshot),
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
        final deleted = await historyRepository.deleteHistoricalEvent(
            eventId: event.eventToBeDeleted.id);
        if (deleted) {
          yield HistoricalEventsDeleted();
        }
      } catch (error) {
        yield HistoricalEventsError(message: error.toString());
      }
    }
  }
}
