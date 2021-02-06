import 'dart:async';

import 'package:acoustic_event_detector/data/models/event.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EventsRepository {
  final FirebaseFirestore _firestore;

  EventsRepository({
    FirebaseFirestore firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> get oldEvents {
    return _firestore.collection(FirebaseConst.historyCollection).snapshots();
  }

  Stream<QuerySnapshot> get events {
    return _firestore.collection(FirebaseConst.eventsCollection).snapshots();
  }

  Future<List<EventSensor>> getHistoricalEventSensors(
      {@required String eventId}) async {
    return await _getEventSensors(
      eventId: eventId,
      collection: FirebaseConst.historyCollection,
    );
  }

  Future<List<EventSensor>> getCurrentEventSensors(
      {@required String eventId}) async {
    return await _getEventSensors(
      eventId: eventId,
      collection: FirebaseConst.eventsCollection,
    );
  }

  Future<bool> addHistoricalEvent({
    @required String id,
    @required double centerLatitude,
    @required double centerLongitude,
    @required List<EventSensor> sensors,
  }) async {
    return await _addEvent(
      id: id,
      centerLatitude: centerLatitude,
      centerLongitude: centerLongitude,
      sensors: sensors,
      collection: FirebaseConst.historyCollection,
    );
  }

  Future<bool> deleteHistoricalEvent({
    @required String eventId,
  }) async {
    return await _deleteEvent(
        eventId: eventId, collection: FirebaseConst.historyCollection);
  }

  Future<bool> deleteCurrentEvent({
    @required String eventId,
  }) async {
    return await _deleteEvent(
        eventId: eventId, collection: FirebaseConst.eventsCollection);
  }

  Future<bool> _deleteEvent({
    @required String eventId,
    @required String collection,
  }) async {
    final docum = _firestore.collection(collection).doc(eventId);

    final QuerySnapshot sensorsFromEvent =
        await docum.collection(FirebaseConst.sensorsCollection).get();

    final bool sensorsDeleted = await Future.forEach(
      sensorsFromEvent.docs,
      (element) async => await docum
          .collection(FirebaseConst.sensorsCollection)
          .doc(element.id)
          .delete(),
    ).catchError((_) => false).then((_) => true);

    if (!sensorsDeleted) {
      return sensorsDeleted;
    }

    final deleted = await _firestore
        .collection(collection)
        .doc(eventId)
        .delete()
        .catchError((_) => false)
        .then((_) => true);

    return deleted;
  }

  Future<bool> _addEvent({
    @required String id,
    @required double centerLatitude,
    @required double centerLongitude,
    @required List<EventSensor> sensors,
    @required String collection,
  }) async {
    final DocumentReference newDoc = _firestore.collection(collection).doc(id);
    final Event newEvent = Event(
      id: id,
      happened: DateTime.now(),
      centerLatitude: centerLatitude,
      centerLongitude: centerLongitude,
      sensorsCount: sensors.length,
    );

    sensors.forEach((element) {
      newDoc.collection(FirebaseConst.sensorsCollection).add(element.toJson());
    });

    final bool added = await newDoc
        .set(newEvent.toJson())
        .catchError((_) => false)
        .then((_) => true);
    return added;
  }

  Future<List<EventSensor>> _getEventSensors({
    @required String eventId,
    @required String collection,
  }) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(collection)
        .doc(eventId)
        .collection(FirebaseConst.sensorsCollection)
        .get();

    return _processEventSensorsData(snapshot);
  }

  List<Event> _processEventData(QuerySnapshot snapshot) =>
      snapshot.docs.map((data) => Event.fromJson(data.data())).toList();

  List<EventSensor> _processEventSensorsData(QuerySnapshot snapshot) =>
      snapshot.docs.map((data) => EventSensor.fromJson(data.data())).toList();
}

extension getEvents on QuerySnapshot {
  List<Event> get eventsFromSnapshot {
    return EventsRepository()._processEventData(this);
  }
}
