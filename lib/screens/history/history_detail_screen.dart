import 'package:acoustic_event_detector/data/models/event.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_app_bar.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_safe_area.dart';
import 'package:acoustic_event_detector/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class HistoryDetailScreen extends StatefulWidget {
  final Event _event;
  final List<EventSensor> _sensors;
  final bool _canDelete;

  const HistoryDetailScreen({
    Key key,
    @required bool canDelete,
    @required Event event,
    @required List<EventSensor> sensors,
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
  Animation<Color> animationIcon;
  Animation<Color> animationContainer;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    animationContainer = ColorTween(
      begin: ColorHelper.darkBlue,
      end: ColorHelper.white,
    ).animate(rotationController)
      ..addListener(() {
        setState(() {});
      });

    animationIcon = ColorTween(
      begin: ColorHelper.white,
      end: ColorHelper.darkBlue,
    ).animate(rotationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        BlocProvider.of<HistoricalEventsBloc>(context, listen: false)
            .add(HistoricalEventsRequested());
        return true;
      },
      child: CustomSafeArea(
        child: Scaffold(
          floatingActionButton: Container(
            decoration: BoxDecoration(
              color: animationContainer.value,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.7).animate(rotationController),
                child: Icon(
                  Icons.my_location_rounded,
                  color: animationIcon.value,
                ),
              ),
              onPressed: () async {
                await rotationController.forward();
                _centerMap();
              },
            ),
          ),
          body: Stack(
            children: [
              MapWidget(
                markers: _setSensors(),
                circles: _setCircles(),
                noClusterMarkers: _setEventPosition(),
                center: LatLng(
                  widget._event.centerLatitude,
                  widget._event.centerLongitude,
                ),
                mapController: _mapController,
              ),
              Positioned(
                child: CustomAppBar(
                  actions: widget._canDelete
                      ? [
                          FlatButton.icon(
                            label: Text(
                              S.current.delete_event,
                              style: Styles.whiteRegular14,
                            ),
                            icon: Icon(
                              Icons.delete_forever_outlined,
                              color: ColorHelper.white,
                            ),
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
                                BlocProvider.of<HistoricalEventsBloc>(
                                  context,
                                  listen: false,
                                ).add(
                                  DeleteHistoricalEvent(
                                      eventToBeDeleted: widget._event),
                                );
                                Navigator.pop(context);
                              }
                            },
                          )
                        ]
                      : [],
                ),
                top: 0.0,
                left: 0.0,
                right: 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _centerMap() async {
    _mapController.onReady.then(
      (_) => _mapController.move(
        LatLng(widget._event.centerLatitude, widget._event.centerLongitude),
        15.0,
      ),
    );
    await rotationController.reverse();
  }

  List<CircleMarker> _setCircles() {
    return [
      CircleMarker(
        color: ColorHelper.red.withOpacity(0.5),
        point: LatLng(
          widget._event.centerLatitude,
          widget._event.centerLongitude,
        ),
        radius: 100,
        useRadiusInMeter: true,
      )
    ];
  }

  List<Marker> _setSensors() {
    return widget._sensors
        .map(
          (EventSensor sensor) => Marker(
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
        .toList();
  }

  List<Marker> _setEventPosition() {
    return [
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
    ];
  }
}
