import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'ID: ${_sensor.id}',
                  style: Styles.darkBlueBold16,
                ),
                Icon(
                  Icons.settings_input_antenna_outlined,
                  color: ColorHelper.darkBlue,
                  size: 24.0,
                ),
              ],
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sensor?.address ?? '',
                  style: Styles.darkBlueRegular16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${S.current.latitude}:',
                      style: Styles.defaultGreyRegular14,
                    ),
                    Text(
                      _sensor?.latitude?.toStringAsFixed(5) ?? '',
                      style: Styles.mediumBlueRegular14,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${S.current.longitude}:',
                      style: Styles.defaultGreyRegular14,
                    ),
                    Text(
                      _sensor?.longitude?.toStringAsFixed(5) ?? '',
                      style: Styles.mediumBlueRegular14,
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: ColorHelper.mediumBlue,
                size: 30.0,
              ),
              onPressed: () {
                BlocProvider.of<SensorsBloc>(context).add(
                  UpdateSensorRequested(
                    sensorToBeUpdated: _sensor,
                    isMap: false,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
