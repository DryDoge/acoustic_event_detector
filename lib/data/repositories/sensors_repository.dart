import 'dart:async';

import 'package:acoustic_event_detector/data/models/custom_exception.dart';
import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SensorsRepository {
  final FirebaseFirestore _firestore;

  SensorsRepository({
    FirebaseFirestore firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> get sensors {
    return _firestore
        .collection(FirebaseConst.sensorsCollection)
        .orderBy(FirebaseConst.idField)
        .snapshots();
  }

  Future<Sensor> findSensorById({
    @required int id,
  }) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseConst.sensorsCollection)
        .where(FirebaseConst.idField, isEqualTo: id)
        .get();

    return querySnapshot.sensorsFromSnapshot.first;
  }

  Future<bool> deleteSensor({
    @required String sensorDbId,
  }) async {
    final deleted = await _firestore
        .collection(FirebaseConst.sensorsCollection)
        .doc(sensorDbId)
        .delete()
        .catchError((_) => false)
        .then((_) => true);

    return deleted;
  }

  Future<bool> addSensor({
    @required int id,
    @required double latitude,
    @required double longitude,
    @required String address,
  }) async {
    final bool _canAdd = await _canBeAdded(id: id);
    if (_canAdd) {
      final DocumentReference newDoc =
          _firestore.collection(FirebaseConst.sensorsCollection).doc();
      final Sensor newSensor = Sensor(
        dbId: newDoc.id,
        id: id,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      final bool added = await newDoc
          .set(newSensor.toJson())
          .catchError((_) => false)
          .then((_) => true);
      return added;
    }
    throw CustomException(S.current.sensor_already_exists_id);
  }

  Future<bool> updateSensor({
    @required Sensor oldSensor,
    @required int id,
    @required double latitude,
    @required double longitude,
    @required String address,
  }) async {
    final DocumentReference docRef = _firestore
        .collection(FirebaseConst.sensorsCollection)
        .doc(oldSensor.dbId);
    final bool _canAdd = await _canBeAdded(id: id);
    if (oldSensor.id != id && !_canAdd) {
      throw CustomException(S.current.sensor_already_exists_id);
    }

    if (oldSensor.id != id ||
        oldSensor.latitude != latitude ||
        oldSensor.longitude != longitude) {
      final Sensor updatedSensor = Sensor(
        dbId: oldSensor.dbId,
        id: id,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      final updated = await _firestore
          .runTransaction((transaction) => transaction
              .get(docRef)
              .then((_) => transaction.update(docRef, updatedSensor.toJson())))
          .catchError((_) => false)
          .then((_) => true);

      return updated;
    }
    return true;
  }

  List<Sensor> _processData(QuerySnapshot snapshot) =>
      snapshot.docs.map((data) => Sensor.fromJson(data.data())).toList();

  Future<bool> _canBeAdded({
    @required int id,
  }) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseConst.sensorsCollection)
        .where(FirebaseConst.idField, isEqualTo: id)
        .get();
    final isEmpty = querySnapshot.sensorsFromSnapshot.isEmpty;
    if (isEmpty) {
      return true;
    }
    return false;
  }
}

extension getSensors on QuerySnapshot {
  List<Sensor> get sensorsFromSnapshot {
    return SensorsRepository()._processData(this);
  }
}
