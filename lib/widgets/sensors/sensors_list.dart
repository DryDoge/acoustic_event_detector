import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/widgets/sensors/sensors_list_item.dart';
import 'package:flutter/material.dart';

class SensorsList extends StatelessWidget {
  final List<Sensor> _sensors;

  const SensorsList({
    Key key,
    @required List<Sensor> sensors,
  })  : this._sensors = sensors,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => SensorsListItem(sensor: _sensors[index]),
      itemCount: _sensors.length,
    );
  }
}
