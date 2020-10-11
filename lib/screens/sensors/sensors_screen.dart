import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/sensors/add_edit_screen.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/sensors/sensors_list.dart';

class SensorsScreen extends StatefulWidget {
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
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SensorsList(sensors: state.sensors),
                ],
              ),
            );
          }
          return Center(
            child: Text('Ziadny sensor'),
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
              message: Text(state.message),
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
                  )),
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
                  sensor: state.sensorToBeUpdated,
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
                  'Sensor id: ${state.addedSensor.id}\nlatitude: ${state.addedSensor.latitude}\nlongitude: ${state.addedSensor.longitude}'),
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
                  'Sensor id: ${state.updatedSensor.id}\nlatitude: ${state.updatedSensor.latitude}\nlongitude: ${state.updatedSensor.longitude}'),
            ),
          );
        }

        if (state is SensorDeleted) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: 'Success',
              message: Text('Sensor zmazany'),
            ),
          );
        }
      },
    );
  }
}
