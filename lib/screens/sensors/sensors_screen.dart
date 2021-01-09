import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/sensors/add_edit_screen.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/sensors/sensors_list.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:acoustic_event_detector/widgets/map_widget.dart';

class SensorsScreen extends StatefulWidget {
  final int _userRights;
  final Function _setMap;

  const SensorsScreen({
    Key key,
    @required int userRights,
    @required Function setMap,
  })  : this._userRights = userRights,
        this._setMap = setMap,
        super(key: key);

  @override
  _SensorsScreenState createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  SensorsBloc _sensorsBloc;

  @override
  void initState() {
    super.initState();
    _sensorsBloc = BlocProvider.of<SensorsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SensorsBloc, SensorsState>(
      builder: (BuildContext context, SensorsState state) {
        if (state is SensorsLoading ||
            state is AddSensorInitial ||
            state is UpdateSensorInitial) {
          return Center(child: CustomCircularIndicator());
        }

        if (state is SensorsLoaded) {
          if (state.sensors.isNotEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: SensorsList(sensors: state.sensors),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: CustomFloatingButton(
                      onPressed: () {
                        widget._setMap();
                        _sensorsBloc.add(SensorsMapRequested());
                      },
                      icon: Icon(
                        Icons.map_outlined,
                        color: ColorHelper.white,
                      ),
                      label: S.current.show_on_map,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text('No sensor'),
          );
        }

        if (state is SensorsMapLoaded) {
          if (state.sensors.isNotEmpty) {
            List<Marker> markers = state.sensors
                .map(
                  (Sensor sensor) => Marker(
                    width: 25.0,
                    height: 25.0,
                    point: LatLng(sensor.latitude, sensor.longitude),
                    builder: (ctx) => Container(
                      decoration: BoxDecoration(
                        color: ColorHelper.white,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: ColorHelper.darkBlue),
                      ),
                      child: GestureDetector(
                        onTap: () => _sensorsBloc.add(
                          UpdateSensorRequested(
                            sensorToBeUpdated: sensor,
                            isMap: true,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            sensor.id.toString(),
                            textAlign: TextAlign.center,
                            style: Styles.darkBlueRegular12,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList();
            return Stack(
              children: [
                MapWidget(markers: markers),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: CustomFloatingButton(
                    onPressed: () {
                      widget._setMap();
                      _sensorsBloc.add(SensorsRequested());
                    },
                    icon: Icon(
                      Icons.list_outlined,
                      color: ColorHelper.white,
                    ),
                    label: S.current.show_list,
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text('No sensor'),
          );
        }

        return Column(
          children: [
            Text(state.toString()),
            Center(
              child: RaisedButton.icon(
                onPressed: () => _sensorsBloc.add(SensorsRequested()),
                icon: Icon(Icons.refresh_outlined),
                label: Text('Refresh'),
              ),
            ),
          ],
        );
      },
      listener: (BuildContext context, SensorsState state) {
        if (state is SensorsError) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: S.current.register_error_default,
              message: Text(
                state.message,
                style: Styles.defaultGreyRegular14,
              ),
            ),
          );
        }

        if (state is AddSensorInitial) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: _sensorsBloc,
                child: AddEditScreen(
                  isEdit: false,
                  canDelete: widget._userRights == 1,
                ),
              ),
            ),
          );
        }
        if (state is UpdateSensorInitial) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: _sensorsBloc,
                child: AddEditScreen(
                  isEdit: true,
                  canDelete: widget._userRights == 1,
                  sensor: state.sensorToBeUpdated,
                  isMap: state.isMap,
                ),
              ),
            ),
          );
        }
        if (state is SensorAdded) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: 'Success',
              message: Text(
                'Sensor id: ${state.addedSensor.id}\nlatitude: ${state.addedSensor.latitude}\nlongitude: ${state.addedSensor.longitude}',
              ),
            ),
          );
        }
        if (state is SensorUpdated) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: 'Success',
              message: Text(
                'Sensor id: ${state.updatedSensor.id}\nlatitude: ${state.updatedSensor.latitude}\nlongitude: ${state.updatedSensor.longitude}',
              ),
            ),
          );
        }

        if (state is SensorDeleted) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: 'Success',
              message: Text('Sensor deleted'),
            ),
          );
        }
      },
    );
  }
}
