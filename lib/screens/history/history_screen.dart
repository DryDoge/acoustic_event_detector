import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/screens/history/history_detail_screen.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  final int _userRights;

  const HistoryScreen({
    Key key,
    @required int userRights,
  })  : this._userRights = userRights,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoricalEventsBloc, HistoricalEventsState>(
      builder: (BuildContext context, HistoricalEventsState state) {
        if (state is HistoricalEventsLoaded) {
          if (state.events.isNotEmpty) {
            return Stack(
              children: [
                Positioned(
                  height: MediaQuery.of(context).size.height * 0.88,
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: CustomList(
                    events: state.events,
                    screenName: FirebaseConst.historyCollection,
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              S.current.no_history,
              style: Styles.darkBlueRegular16,
            ),
          );
        }
        return Center(child: CustomCircularIndicator());
      },
      listener: (BuildContext context, HistoricalEventsState state) {
        if (state is HistoricalEventsError) {
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

        if (state is HistoricalEventsDeleted) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: S.current.done,
              message: Text(
                S.current.event_was_deleted,
                style: Styles.darkBlueBold16,
              ),
            ),
          );
        }

        if (state is HistoricalEventDetail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryDetailScreen(
                canDelete: _userRights == 1,
                event: state.event,
                sensors: state.sensors,
              ),
            ),
          );
        }
      },
    );
  }
}
