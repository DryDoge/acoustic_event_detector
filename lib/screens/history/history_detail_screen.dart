import 'package:acoustic_event_detector/data/models/historical_event.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_floating_button.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class HistoryDetailScreen extends StatefulWidget {
  final HistoricalEvent _event;
  final List<HistoricalEventSensor> _sensors;
  final bool _canDelete;

  const HistoryDetailScreen({
    Key key,
    @required bool canDelete,
    @required HistoricalEvent event,
    @required List<HistoricalEventSensor> sensors,
  })  : this._canDelete = canDelete,
        this._event = event,
        this._sensors = sensors,
        super(key: key);

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen>
    with TickerProviderStateMixin {
  AnimationController rotationController;
  MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        BlocProvider.of<HistoricalEventsBloc>(context).add(
          HistoricalEventsRequested(),
        );
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(widget._event.centerLatitude,
                      widget._event.centerLongitude),
                  zoom: 15.0,
                  maxZoom: 18.0,
                  minZoom: 13.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                    tileProvider: CachedNetworkTileProvider(),
                  ),
                  CircleLayerOptions(
                    circles: [
                      CircleMarker(
                        color: ColorHelper.red.withOpacity(0.5),
                        point: LatLng(
                          widget._event.centerLatitude,
                          widget._event.centerLongitude,
                        ),
                        radius: 200,
                        useRadiusInMeter: true,
                      )
                    ],
                  ),
                  MarkerLayerOptions(
                    markers: _setSensors(),
                  ),
                ],
              ),
              Positioned(
                top: 4.0,
                left: 4.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorHelper.darkBlue, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorHelper.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      BlocProvider.of<HistoricalEventsBloc>(context).add(
                        HistoricalEventsRequested(),
                      );
                    },
                  ),
                ),
              ),
              if (widget._canDelete)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomFloatingButton(
                    onPressed: () async {
                      final action = await showDialog(
                        context: context,
                        builder: (context) => CustomPlatformAlertDialog(
                          oneOptionOnly: false,
                          onlySecondImportant: true,
                          title: S.current.delete_event,
                          message: Text(
                            S.current.delete_question,
                            style: Styles.defaultGreyRegular14,
                          ),
                        ),
                      );

                      if (action == CustomAction.First) {
                        BlocProvider.of<HistoricalEventsBloc>(context).add(
                          DeleteHistoricalEvent(
                              eventToBeDeleted: widget._event),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      color: ColorHelper.white,
                    ),
                    label: S.current.delete_event,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorHelper.darkBlue, shape: BoxShape.circle),
                    child: IconButton(
                      icon: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0)
                            .animate(rotationController),
                        child: Icon(
                          Icons.center_focus_weak,
                          color: ColorHelper.white,
                        ),
                      ),
                      onPressed: () async {
                        await rotationController.forward(from: 0.0);
                        _centerMap();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _centerMap() {
    _mapController.onReady.then(
      (_) => _mapController.move(
        LatLng(widget._event.centerLatitude, widget._event.centerLongitude),
        15.0,
      ),
    );
  }

  List<Marker> _setSensors() {
    return widget._sensors
        .map(
          (HistoricalEventSensor sensor) => Marker(
            width: 22.0,
            height: 22.0,
            point: LatLng(sensor.latitude, sensor.longitude),
            builder: (ctx) => Container(
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: ColorHelper.darkBlue),
              ),
              child: Icon(
                Icons.settings_input_antenna_rounded,
                color: ColorHelper.darkBlue,
                size: 16.0,
              ),
            ),
          ),
        )
        .toList()
          ..add(
            Marker(
              width: 22.0,
              height: 22.0,
              point: LatLng(
                widget._event.centerLatitude,
                widget._event.centerLongitude,
              ),
              builder: (ctx) => Container(
                decoration: BoxDecoration(
                  color: ColorHelper.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(
                  Icons.center_focus_strong_rounded,
                  color: ColorHelper.white,
                  size: 16.0,
                ),
              ),
            ),
          );
  }
}
