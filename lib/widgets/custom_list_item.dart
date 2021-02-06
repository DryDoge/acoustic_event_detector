import 'package:acoustic_event_detector/data/models/event.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/event/bloc/current_events_bloc.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:acoustic_event_detector/utils/string_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

class CustomListItem extends StatelessWidget {
  final Event _event;
  final String _screenName;
  const CustomListItem({
    Key key,
    @required Event event,
    @required String screenName,
  })  : this._event = event,
        this._screenName = screenName,
        super(key: key);

  Future<Placemark> _getPlacemark(Event event) async {
    if (event.centerLatitude != null && event.centerLongitude != null) {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        event.centerLatitude,
        event.centerLongitude,
      );

      return placemarks.first;
    }
    return null;
  }

  void _onTap(BuildContext context, String screenName) async {
    if (screenName == FirebaseConst.eventsCollection) {
      final List<EventSensor> sensors =
          await BlocProvider.of<CurrentEventsBloc>(context)
              .eventsRepository
              .getCurrentEventSensors(eventId: _event.id);

      BlocProvider.of<CurrentEventsBloc>(context).add(
        CurrentEventDetailRequested(
          event: _event,
          sensors: sensors,
        ),
      );
    }

    if (screenName == FirebaseConst.historyCollection) {
      final List<EventSensor> sensors =
          await BlocProvider.of<HistoricalEventsBloc>(context)
              .eventsRepository
              .getHistoricalEventSensors(eventId: _event.id);

      BlocProvider.of<HistoricalEventsBloc>(context).add(
        HistoricalEventDetailRequested(
          event: _event,
          sensors: sensors,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPlacemark(_event),
      builder: (BuildContext context, AsyncSnapshot<Placemark> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Text(
                  '${S.current.error_default}\n${S.current.try_refresh}',
                  style: Styles.darkBlueRegular16,
                ),
                RaisedButton(onPressed: () => _getPlacemark(_event)),
              ],
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CustomCircularIndicator(),
          );
        }
        final Placemark _placemark = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => _onTap(context, _screenName),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInfoRow(
                      title:
                          '${StringHelper.getDate(_event.happened)} - ${StringHelper.getTime(_event.happened)}',
                      subtitle: '${S.current.date} & ${S.current.time}: ',
                    ),
                    CustomInfoRow(
                        title: '${_event.sensorsCount}',
                        subtitle: '${S.current.sensors_count}: '),
                    CustomInfoRow(
                      title: _event.centerLatitude.toStringAsFixed(5),
                      subtitle: '${S.current.latitude}: ',
                    ),
                    CustomInfoRow(
                      title: _event.centerLongitude.toStringAsFixed(5),
                      subtitle: '${S.current.longitude}: ',
                    ),
                    Text(
                      '${S.current.possible_address}: ',
                      style: Styles.mediumBlueRegular16,
                    ),
                    Wrap(
                      children: [
                        Text(
                          '${_placemark?.street}, ',
                          style: Styles.darkBlueBold18,
                        ),
                        Text(
                          '${_placemark.subLocality.length != 0 ? _placemark?.subLocality : _placemark?.locality}',
                          style: Styles.darkBlueBold18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
