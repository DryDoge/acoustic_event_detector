import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SensorsListItem extends StatelessWidget {
  final Sensor _sensor;

  const SensorsListItem({
    Key key,
    @required Sensor sensor,
  })  : this._sensor = sensor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey<String>(_sensor?.dbId ?? _sensor?.id ?? ''),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: Card(
          child: ListTile(
            leading: Text(_sensor?.id.toString() ?? ''),
            title: Column(
              children: [
                Text(_sensor?.latitude?.toString() ?? ''),
                Text(_sensor?.longitude?.toString() ?? ''),
              ],
            ),
            trailing: Text('ha'),
            onLongPress: () async {
              final action = await showDialog(
                context: context,
                builder: (context) => CustomPlatformAlertDialog(
                  oneOptionOnly: false,
                  title: 'NAOZAJ ZMAZAT?',
                ),
              );

              if (action == CustomAction.First) {
                BlocProvider.of<SensorsBloc>(context).add(
                  DeleteSensor(sensorToBeDeleted: _sensor),
                );
              }
            },
            onTap: () {
              BlocProvider.of<SensorsBloc>(context).add(
                UpdateSensorRequested(sensorToBeUpdated: _sensor),
              );
            },
          ),
        ),
      ),
    );
  }
}
