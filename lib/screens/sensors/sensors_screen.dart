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

class SensorsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<SensorsBloc, SensorsState>(
      builder: (BuildContext context, SensorsState state) {
        if (state is SensorsLoading ||
            state is AddSensorInitial ||
            state is UpdateSensorInitial) {
          return Center(child: CustomCircularIndicator());
        }

        if (state is SensorsLoaded) {
          if (state.sensors.isNotEmpty) {
            return Stack(
              children: [
                Positioned(
                  height: size.height * 0.78,
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: SensorsList(sensors: state.sensors),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  child: CustomFloatingButton(
                    onPressed: () {
                      _setMap();
                      BlocProvider.of<SensorsBloc>(context, listen: false)
                          .add(SensorsMapRequested());
                    },
                    icon: Icon(
                      Icons.map_outlined,
                      color: ColorHelper.white,
                    ),
                    label: S.current.show_on_map,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 16.0,
                  child: _userRights == 1
                      ? CustomFloatingButton(
                          onPressed: () => BlocProvider.of<SensorsBloc>(
                            context,
                            listen: false,
                          ).add(AddSensorRequested()),
                          icon: Icon(
                            Icons.leak_add_rounded,
                            color: ColorHelper.white,
                          ),
                          label: S.current.add_sensor,
                        )
                      : SizedBox.shrink(),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              S.current.no_sensor,
              style: Styles.darkBlueRegular16,
            ),
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
                        onTap: () =>
                            BlocProvider.of<SensorsBloc>(context, listen: false)
                                .add(
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
                Positioned(
                  height: size.height * 0.78,
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: MapWidget(
                    markers: markers,
                    center: markers.first.point,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 240.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorHelper.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        '${S.current.sensors_count}: ${state.sensors.length}',
                        style: Styles.darkBlueBold14,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  child: CustomFloatingButton(
                    onPressed: () {
                      _setMap();
                      BlocProvider.of<SensorsBloc>(context, listen: false)
                          .add(SensorsRequested());
                    },
                    icon: Icon(
                      Icons.list_outlined,
                      color: ColorHelper.white,
                    ),
                    label: S.current.show_list,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 16.0,
                  child: _userRights == 1
                      ? CustomFloatingButton(
                          onPressed: () => BlocProvider.of<SensorsBloc>(
                            context,
                            listen: false,
                          ).add(AddSensorRequested()),
                          icon: Icon(
                            Icons.leak_add_rounded,
                            color: ColorHelper.white,
                          ),
                          label: S.current.add_sensor,
                        )
                      : SizedBox.shrink(),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              S.current.no_sensor,
              style: Styles.darkBlueRegular16,
            ),
          );
        }

        return Column(
          children: [
            Text(state.toString()),
            Center(
              child: RaisedButton.icon(
                onPressed: () =>
                    BlocProvider.of<SensorsBloc>(context, listen: false)
                        .add(SensorsRequested()),
                icon: Icon(Icons.refresh_outlined),
                label: Text(
                  '${S.current.error_default}\n${S.current.try_refresh}',
                  style: Styles.darkBlueRegular16,
                ),
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
              title: S.current.error_default,
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
              builder: (context) => AddEditScreen(
                isEdit: false,
                canDelete: _userRights == 1,
              ),
            ),
          );
        }
        if (state is UpdateSensorInitial) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditScreen(
                isEdit: true,
                canDelete: _userRights == 1,
                sensor: state.sensorToBeUpdated,
                isMap: state.isMap,
              ),
            ),
          );
        }
        if (state is SensorAdded) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: S.current.sensor_added,
              message: Text(
                'Sensor id: ${state.addedSensor.id}\nlatitude: ${state.addedSensor.latitude.toStringAsFixed(6)}\nlongitude: ${state.addedSensor.longitude.toStringAsFixed(6)}',
              ),
            ),
          );
        }
        if (state is SensorUpdated) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: S.current.sensor_edited,
              message: Text(
                'Sensor id: ${state.updatedSensor.id}\nlatitude: ${state.updatedSensor.latitude.toStringAsFixed(6)}\nlongitude: ${state.updatedSensor.longitude.toStringAsFixed(6)}',
              ),
            ),
          );
        }

        if (state is SensorDeleted) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: S.current.done,
              message: Text(
                S.current.sensor_was_deleted,
                style: Styles.darkBlueBold16,
              ),
            ),
          );
        }
      },
    );
  }
}
