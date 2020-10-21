part of 'historical_events_bloc.dart';

abstract class HistoricalEventsState extends Equatable {
  const HistoricalEventsState();

  @override
  List<Object> get props => [];
}

class HistoricalEventsLoading extends HistoricalEventsState {
  const HistoricalEventsLoading();
}

class HistoricalEventsLoaded extends HistoricalEventsState {
  final List<HistoricalEvent> events;

  const HistoricalEventsLoaded({@required this.events});

  @override
  List<Object> get props => [events];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HistoricalEventsLoaded && listEquals(o.events, events);
  }

  @override
  int get hashCode => events.hashCode;
}

class HistoricalEventsError extends HistoricalEventsState {
  final String message;

  const HistoricalEventsError({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HistoricalEventsError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class HistoricalEventsDeleted extends HistoricalEventsState {
  const HistoricalEventsDeleted();
}
