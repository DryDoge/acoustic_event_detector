import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/dimensions.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/sensors/sensors_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SensorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.max,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.9],
          colors: [
            ColorHelper.mediumBlue,
            ColorHelper.lightBlue,
            ColorHelper.mediumBlue,
          ],
        ),
      ),
      child: BlocBuilder<SensorsBloc, SensorsState>(
        builder: (BuildContext context, SensorsState state) {
          if (state is SensorsLoading) {
            return Center(child: CustomCircularIndicator());
          } else if (state is SensorsLoaded) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SensorsList(sensors: state.sensors),
              ],
            );
          } else if (state is SensorsError) {
            return Center(
              child: Column(
                children: [
                  RaisedButton.icon(
                    onPressed: () => BlocProvider.of<SensorsBloc>(context)
                        .add(SensorsRequested()),
                    icon: Icon(Icons.refresh_outlined),
                    label: Text('Refresh'),
                  )
                ],
              ),
            );
          }
          return Text('SHOULD NOT HAPPEN');
        },
      ),
    );
  }
}
