import 'package:acoustic_event_detector/data/models/custom_exception.dart';
import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SensorsRepository {
  final FirebaseFirestore _firestore;

  List<Sensor> _sensors;

  List<Sensor> get sensors {
    return [..._sensors];
  }

  void _setSensors(List<Sensor> sensors) {
    _sensors = sensors;
  }

  bool _canBeAdded({@required String id}) {
    return sensors.map((Sensor sensor) => sensor.id).toList().contains(id);
  }

  SensorsRepository({
    FirebaseFirestore firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Sensor> findSensorById({@required String id}) async {
    return Future.value(sensors.firstWhere(
      (Sensor sensor) => sensor.id == id,
      orElse: null,
    ));
  }

  Future<List<Sensor>> getAllSensors() async {
    final QuerySnapshot _snapshot =
        await _firestore.collection(FirebaseConst.sensorsCollection).get();

    final List<Sensor> _sensors =
        _snapshot.docs.map((data) => Sensor.fromJson(data.data())).toList();

    _setSensors(_sensors);
    return Future.value(sensors);
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
    if (_canBeAdded(id: id)) {
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
    throw CustomException(S.current.sensor_already_exists_id);
  }

  Future<bool> updateSensor({
    @required Sensor oldSensor,
    @required String id,
    @required double latitude,
    @required double longitude,
  }) async {
    final DocumentReference docRef = _firestore
        .collection(FirebaseConst.sensorsCollection)
        .doc(oldSensor.dbId);

    if (oldSensor.id != id && !_canBeAdded(id: id)) {
      throw CustomException(S.current.sensor_already_exists_id);
    }

    if (oldSensor.latitude != latitude || oldSensor.longitude != longitude) {
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
