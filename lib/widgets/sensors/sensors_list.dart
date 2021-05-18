import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/sensors/sensors_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
      itemCount: _sensors.length,
      itemBuilder: (context, index) => Provider.of<User>(context, listen: false)
                  .rights ==
              1
          ? Dismissible(
              child: SensorsListItem(sensor: _sensors[index]),
              key: ValueKey(_sensors[index].dbId ?? _sensors[index].id ?? ''),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.delete_forever_outlined,
                      color: ColorHelper.red,
                    ),
                    Text(
                      S.current.delete_sensor,
                      style: Styles.redRegular14,
                    ),
                  ],
                ),
              ),
              background: Container(),
              onDismissed: (direction) async {
                final action = await showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    oneOptionOnly: false,
                    onlySecondImportant: true,
                    title: S.current.delete_sensor,
                    message: Text(
                      S.current.delete_question,
                      style: Styles.defaultGreyRegular14,
                    ),
                  ),
                );

                if (action == CustomAction.First) {
                  BlocProvider.of<SensorsBloc>(context).add(
                    DeleteSensor(sensorToBeDeleted: _sensors[index]),
                  );
                }
                if (action == CustomAction.Second) {
                  BlocProvider.of<SensorsBloc>(context).add(SensorsRequested());
                }
              },
              direction: DismissDirection.endToStart,
            )
          : SensorsListItem(sensor: _sensors[index]),
    );
  }
}
