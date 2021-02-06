import 'package:acoustic_event_detector/data/models/event.dart';
import 'package:acoustic_event_detector/widgets/custom_list_item.dart';
import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  final List<Event> _events;
  final String _screenName;

  const CustomList({
    Key key,
    @required List<Event> events,
    @required String screenName,
  })  : this._events = events,
        this._screenName = screenName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return CustomListItem(event: _events[index], screenName: _screenName);
      },
      itemCount: _events.length,
      shrinkWrap: true,
    );
  }
}
