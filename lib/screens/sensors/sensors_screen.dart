import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/data/repositories/sensors_repository.dart';
import 'package:acoustic_event_detector/widgets/sensors/sensors_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SensorsScreen extends StatelessWidget {
  final SensorsRepository _sensorsRepository = SensorsRepository();

  @override
  Widget build(BuildContext context) {
    return Provider<SensorsRepository>.value(
      value: _sensorsRepository,
      builder: (context, child) => StreamBuilder<QuerySnapshot>(
        stream: _sensorsRepository.sensors,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final List<Sensor> _sensors = snapshot.data.docs
                .map((data) => Sensor.fromJson(data.data()))
                .toList();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SensorsList(sensors: _sensors),
                FlatButton(
                  onPressed: () async {
                    await _sensorsRepository.addSensor(
                      id: '1',
                      latitude: 10.0,
                      longitude: 11.11,
                    );
                  },
                  child: Text('Add Sensor'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
