import 'dart:async';

import 'package:acoustic_event_detector/data/models/historical_event.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HistoryRepository {
  final FirebaseFirestore _firestore;

  HistoryRepository({
    FirebaseFirestore firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> get oldEvents {
    return _firestore.collection(FirebaseConst.historyCollection).snapshots();
  }

  Future<List<HistoricalEventSensor>> getHistoricalEventSensors(
      {@required String eventId}) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(FirebaseConst.historyCollection)
        .doc(eventId)
        .collection(FirebaseConst.sensorsCollection)
        .get();

    return _processEventSensorsData(snapshot);
  }

  Future<bool> deleteHistoricalEvent({
    @required String eventId,
  }) async {
    final docum =
        _firestore.collection(FirebaseConst.historyCollection).doc(eventId);

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
        .collection(FirebaseConst.historyCollection)
        .doc(eventId)
        .delete()
        .catchError((_) => false)
        .then((_) => true);

    return deleted;
  }

  Future<bool> addHistoricalEvent({
    @required int id,
    @required double centerLatitude,
    @required double centerLongitude,
    @required List<HistoricalEventSensor> sensors,
  }) async {
    final DocumentReference newDoc =
        _firestore.collection(FirebaseConst.historyCollection).doc();
    final HistoricalEvent newHistoricalEvent = HistoricalEvent(
      id: newDoc.id,
      happened: DateTime.now(),
      centerLatitude: centerLatitude,
      centerLongitude: centerLongitude,
    );

    sensors.forEach((element) {
      newDoc.collection(FirebaseConst.sensorsCollection).add(element.toJson());
    });

    final bool added = await newDoc
        .set(newHistoricalEvent.toJson())
        .catchError((_) => false)
        .then((_) => true);
    return added;
  }

  List<HistoricalEvent> _processEventData(QuerySnapshot snapshot) =>
      snapshot.docs
          .map((data) => HistoricalEvent.fromJson(data.data()))
          .toList();

  List<HistoricalEventSensor> _processEventSensorsData(
          QuerySnapshot snapshot) =>
      snapshot.docs
          .map((data) => HistoricalEventSensor.fromJson(data.data()))
          .toList();
}

extension getOldEvents on QuerySnapshot {
  List<HistoricalEvent> get oldEventsFromSnapshot {
    return HistoryRepository()._processEventData(this);
  }
}
