part of 'historical_events_bloc.dart';

abstract class HistoricalEventsEvent extends Equatable {
  const HistoricalEventsEvent();

  @override
  List<Object> get props => [];
}

class HistoricalEventsRequested extends HistoricalEventsEvent {
  const HistoricalEventsRequested();
}

class _HistoricalEventsLoaded extends HistoricalEventsEvent {
  final List<Event> events;

  _HistoricalEventsLoaded(this.events);

  @override
  List<Object> get props => [events];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _HistoricalEventsLoaded && listEquals(o.events, events);
  }

  @override
  int get hashCode => events.hashCode;
}

class DeleteHistoricalEvent extends HistoricalEventsEvent {
  final Event eventToBeDeleted;

  const DeleteHistoricalEvent({this.eventToBeDeleted});

  @override
  List<Object> get props => [eventToBeDeleted];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DeleteHistoricalEvent && o.eventToBeDeleted == eventToBeDeleted;
  }

  @override
  int get hashCode => eventToBeDeleted.hashCode;
}

class HistoricalEventDetailRequested extends HistoricalEventsEvent {
  final Event event;
  final List<EventSensor> sensors;

  HistoricalEventDetailRequested({this.event, this.sensors});

  @override
  List<Object> get props => [event, sensors];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HistoricalEventDetailRequested &&
        o.event == event &&
        listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => event.hashCode ^ sensors.hashCode;
}

class HistoricalEventAdd extends HistoricalEventsEvent {
  final Event event;
  final List<EventSensor> sensors;

  HistoricalEventAdd({this.event, this.sensors});

  @override
  List<Object> get props => [event, sensors];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HistoricalEventAdd &&
        o.event == event &&
        listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => event.hashCode ^ sensors.hashCode;
}
