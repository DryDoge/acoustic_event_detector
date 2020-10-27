import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/history/history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
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
                    child: HistoryList(historicalEvents: state.events),
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
                onPressed: () => BlocProvider.of<HistoricalEventsBloc>(context)
                    .add(HistoricalEventsRequested()),
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
