import 'package:acoustic_event_detector/data/models/historical_event.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoricalEventsBloc _historicalEventsBloc;

  @override
  void initState() {
    super.initState();
    _historicalEventsBloc = BlocProvider.of<HistoricalEventsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoricalEventsBloc, HistoricalEventsState>(
      builder: (BuildContext context, HistoricalEventsState state) {
        if (state is HistoricalEventsLoading) {
          return Center(child: CustomCircularIndicator());
        }

        if (state is HistoricalEventsLoaded) {
          if (state.events.isNotEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final HistoricalEvent a = state.events[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              onTap: () async {
                                final b = await _historicalEventsBloc
                                    .historyRepository
                                    .getHistoricalEventSensors(eventId: a.id);
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CustomPlatformAlertDialog(
                                    title: 'Pecka',
                                    message: Text('Mam ${b.length} sensorov'),
                                  ),
                                );
                              },
                              onLongPress: () => _historicalEventsBloc.add(
                                DeleteHistoricalEvent(eventToBeDeleted: a),
                              ),
                              subtitle: Text(
                                  a.happened?.toIso8601String() ?? 'nie je'),
                              title: Text(a.id ?? 'nie je'),
                              leading: CircleAvatar(
                                foregroundColor: ColorHelper.white,
                                backgroundColor: ColorHelper.darkBlue,
                                child: Text(
                                    a.sensorsCount?.toString() ?? 'nie je'),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      a.centerLatitude?.toString() ?? 'nie je'),
                                  Text(a.centerLongitude?.toString() ??
                                      'nie je'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.events.length,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text('Ziadny event v historii'),
          );
        }

        return Column(
          children: [
            Text(state.toString()),
            Center(
              child: RaisedButton.icon(
                onPressed: () =>
                    _historicalEventsBloc.add(HistoricalEventsRequested()),
                icon: Icon(Icons.refresh_outlined),
                label: Text('Refresh'),
              ),
            ),
          ],
        );
      },
      listener: (BuildContext context, HistoricalEventsState state) {
        if (state is HistoricalEventsError) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: S.current.register_error_default,
              message: Text(state.message),
            ),
          );
        }

        if (state is HistoricalEventsDeleted) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: 'Success',
              message: Text('Event zmazany'),
            ),
          );
        }
      },
    );
  }
}
