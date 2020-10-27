import 'package:acoustic_event_detector/data/models/historical_event.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/string_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/history/Info_row.dart';
import 'package:flutter/material.dart';
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
      builder: (context, AsyncSnapshot<Placemark> snapshot) {
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

        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CustomCircularIndicator(),
          );
        }

        if (snapshot.hasData) {
          final Placemark _placemark = snapshot.data;
          print(_placemark?.subLocality);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoRow(
                          title: StringHelper.getDate(_event.happened),
                          subtitle: '${S.current.date}: ',
                        ),
                        InfoRow(
                          title: StringHelper.getTime(_event.happened),
                          subtitle: '${S.current.time}: ',
                        ),
                      ],
                    ),
                    InfoRow(
                      title:
                          '${_placemark?.street}, ${_placemark.subLocality.length > 2 ? _placemark?.subLocality : _placemark?.locality}',
                      subtitle: '${S.current.possible_address}: ',
                    ),
                    InfoRow(
                      title: _event.centerLatitude.toStringAsFixed(6),
                      subtitle: '${S.current.latitude}: ',
                    ),
                    InfoRow(
                      title: _event.centerLongitude.toStringAsFixed(6),
                      subtitle: '${S.current.longitude}: ',
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Column(
                    //       children: [
                    //         Text('${S.current.latitude}: ',
                    //             style: Styles.mediumBlueRegular16),
                    //         Text(_event.centerLatitude.toStringAsFixed(6),
                    //             style: Styles.darkBlueBold18)
                    //       ],
                    //     ),
                    //     Column(
                    //       children: [
                    //         Text('${S.current.longitude}: ',
                    //             style: Styles.mediumBlueRegular16),
                    //         Text(_event.centerLongitude.toStringAsFixed(6),
                    //             style: Styles.darkBlueBold18)
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
