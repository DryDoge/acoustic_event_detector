import 'package:acoustic_event_detector/data/models/historical_event.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/utils/string_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/history/info_history_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

class HistoryListItem extends StatelessWidget {
  final HistoricalEvent _event;

  const HistoryListItem({
    Key key,
    @required HistoricalEvent event,
  })  : this._event = event,
        super(key: key);

  Future<Placemark> _getPlacemark(HistoricalEvent event) async {
    if (event.centerLatitude != null && event.centerLongitude != null) {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
          event.centerLatitude, event.centerLongitude);

      return placemarks.first;
    }
    return null;
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
                Text('Error'),
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
            onTap: () async {
              final List<HistoricalEventSensor> sensors =
                  await BlocProvider.of<HistoricalEventsBloc>(context)
                      .historyRepository
                      .getHistoricalEventSensors(eventId: _event.id);

              BlocProvider.of<HistoricalEventsBloc>(context).add(
                HistoricalEventDetailRequested(
                  event: _event,
                  sensors: sensors,
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoHistoryRow(
                      title:
                          '${StringHelper.getDate(_event.happened)} - ${StringHelper.getTime(_event.happened)}',
                      subtitle: '${S.current.date} & ${S.current.time}: ',
                    ),
                    InfoHistoryRow(
                      title: _event.centerLatitude.toStringAsFixed(5),
                      subtitle: '${S.current.latitude}: ',
                    ),
                    InfoHistoryRow(
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
