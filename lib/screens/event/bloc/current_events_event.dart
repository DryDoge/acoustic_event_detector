part of 'current_events_bloc.dart';

abstract class CurrentEventsEvent extends Equatable {
  const CurrentEventsEvent();

  @override
  List<Object> get props => [];
}

class CurrentEventsRequested extends CurrentEventsEvent {
  const CurrentEventsRequested();
}

class _CurrentEventsLoaded extends CurrentEventsEvent {
  final List<Event> events;

  _CurrentEventsLoaded(this.events);

  @override
  List<Object> get props => [events];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _CurrentEventsLoaded && listEquals(o.events, events);
  }

  @override
  int get hashCode => events.hashCode;
}

class DeleteCurrentEvent extends CurrentEventsEvent {
  final Event eventToBeDeleted;

  const DeleteCurrentEvent({this.eventToBeDeleted});

  @override
  List<Object> get props => [eventToBeDeleted];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DeleteCurrentEvent && o.eventToBeDeleted == eventToBeDeleted;
  }

  @override
  int get hashCode => eventToBeDeleted.hashCode;
}

class CurrentEventDetailRequested extends CurrentEventsEvent {
  final Event event;
  final List<EventSensor> sensors;

  CurrentEventDetailRequested({this.event, this.sensors});

  @override
  List<Object> get props => [event, sensors];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentEventDetailRequested &&
        o.event == event &&
        listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => event.hashCode ^ sensors.hashCode;
}
