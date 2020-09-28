import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SensorsRepository {
  final FirebaseFirestore _firestore;

  SensorsRepository({
    FirebaseFirestore firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> get sensors {
    return _firestore.collection(FirebaseConst.sensorsCollection).snapshots();
  }

  Future<List<Sensor>> getAllSensors() async {
    final QuerySnapshot _snapshot =
        await _firestore.collection(FirebaseConst.sensorsCollection).get();
    return Future.value(
        _snapshot.docs.map((data) => Sensor.fromJson(data.data())).toList());
  }

  Future<bool> deleteSensor({
    @required String sensorDbId,
  }) async {
    return await _firestore
        .collection(FirebaseConst.sensorsCollection)
        .doc(sensorDbId)
        .delete()
        .catchError((_) => Future.value(false))
        .then((_) => Future.value(true));
  }

  Future<bool> addSensor({
    @required String id,
    @required double latitude,
    @required double longitude,
  }) async {
    if (id != null && latitude != null && longitude != null) {
      final DocumentReference newDoc =
          _firestore.collection(FirebaseConst.sensorsCollection).doc();
      final Sensor newSensor = Sensor(
        dbId: newDoc.id,
        id: id,
        latitude: latitude,
        longitude: longitude,
      );

      return await newDoc
          .set(newSensor.toJson())
          .catchError((_) => Future.value(false))
          .then((_) => Future.value(true));
    }
    return Future.value(false);
  }

  Future<bool> updateSensor({
    @required Sensor oldSensor,
    String id,
    double latitude,
    double longitude,
  }) async {
    final DocumentReference docRef = _firestore
        .collection(FirebaseConst.sensorsCollection)
        .doc(oldSensor.dbId);

    id ??= oldSensor.id;
    latitude ??= oldSensor.latitude;
    longitude ??= oldSensor.longitude;

    if (oldSensor.id != id ||
        oldSensor.latitude != latitude ||
        oldSensor.longitude != longitude) {
      final Sensor updatedSensor = Sensor(
        dbId: oldSensor.dbId,
        id: id,
        latitude: latitude,
        longitude: longitude,
      );

      _firestore
          .runTransaction((transaction) => transaction
              .get(docRef)
              .then((_) => transaction.update(docRef, updatedSensor.toJson())))
          .catchError((_) => Future.value(false))
          .then((_) => Future.value(true));
    }
    return Future.value(true);
  }
}
