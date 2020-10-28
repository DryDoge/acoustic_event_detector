import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/screens/history/history_detail_screen.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/history/history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatefulWidget {
  final int _userRights;

  const HistoryScreen({
    Key key,
    @required int userRights,
  })  : this._userRights = userRights,
        super(key: key);

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
        return Center(child: CustomCircularIndicator());
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

        if (state is HistoricalEventDetail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                child: HistoryDetailScreen(
                  canDelete: widget._userRights == 1,
                  event: state.event,
                  sensors: state.sensors,
                ),
                value: _historicalEventsBloc,
              ),
            ),
          );
        }
      },
    );
  }
}
