import 'package:acoustic_event_detector/data/models/historical_event.dart';
import 'package:acoustic_event_detector/widgets/history/history_list_item.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<HistoricalEvent> _historicalEvents;

  const HistoryList({
    Key key,
    @required List<HistoricalEvent> historicalEvents,
  })  : this._historicalEvents = historicalEvents,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return HistoryListItem(event: _historicalEvents[index]);
      },
      itemCount: _historicalEvents.length,
      shrinkWrap: true,
    );
  }
}
