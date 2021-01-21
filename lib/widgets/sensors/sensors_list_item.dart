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
    return GestureDetector(
      onTap: () {
        BlocProvider.of<SensorsBloc>(context).add(
          UpdateSensorRequested(
            sensorToBeUpdated: _sensor,
            isMap: false,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0),
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 60.0,
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 100.0),
                      child: Text(
                        '${S.current.id}: ${_sensor.id}',
                        style: Styles.darkBlueBold16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Icon(
                      Icons.settings_input_antenna_outlined,
                      color: ColorHelper.darkBlue,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 200.0),
                    child: Text(
                      _sensor?.address ?? '',
                      style: Styles.darkBlueRegular16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              IconButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
