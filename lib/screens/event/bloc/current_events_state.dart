part of 'current_events_bloc.dart';

abstract class CurrentEventsState extends Equatable {
  const CurrentEventsState();

  @override
  List<Object> get props => [];
}

class CurrentEventsLoading extends CurrentEventsState {
  const CurrentEventsLoading();
}

class CurrentEventsLoaded extends CurrentEventsState {
  final List<Event> events;

  const CurrentEventsLoaded({@required this.events});

  @override
  List<Object> get props => [events];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentEventsLoaded && listEquals(o.events, events);
  }

  @override
  int get hashCode => events.hashCode;
}

class CurrentEventsError extends CurrentEventsState {
  final String message;

  const CurrentEventsError({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentEventsError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class CurrentEventsDeleted extends CurrentEventsState {
  const CurrentEventsDeleted();
}

class CurrentEventDetail extends CurrentEventsState {
  final Event event;
  final List<EventSensor> sensors;

  CurrentEventDetail({this.event, this.sensors});

  @override
  List<Object> get props => [event, sensors];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CurrentEventDetail &&
        o.event == event &&
        listEquals(o.sensors, sensors);
  }

  @override
  int get hashCode => event.hashCode ^ sensors.hashCode;
}
