import 'package:acoustic_event_detector/data/models/event.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/event/bloc/current_events_bloc.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_app_bar.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_safe_area.dart';
import 'package:acoustic_event_detector/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class EventDetailScreen extends StatefulWidget {
  final Event _event;
  final List<EventSensor> _sensors;
  final bool _canDelete;
  final Function _goToHistory;

  const EventDetailScreen({
    Key key,
    @required bool canDelete,
    @required Event event,
    @required List<EventSensor> sensors,
    @required Function goToHistory,
  })  : this._canDelete = canDelete,
        this._event = event,
        this._sensors = sensors,
        this._goToHistory = goToHistory,
        super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  AnimationController rotationControllerEvent;
  AnimationController animationControllerUser;

  MapController _mapController;
  Animation<Color> animationIcon;
  Animation<Color> animationContainer;
  Animation<Color> animationIcon2;
  Animation<Color> animationContainer2;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    rotationControllerEvent = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationControllerUser = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    animationContainer = ColorTween(
      begin: ColorHelper.darkBlue,
      end: ColorHelper.white,
    ).animate(animationControllerUser)
      ..addListener(() {
        setState(() {});
      });

    animationIcon = ColorTween(
      begin: ColorHelper.white,
      end: ColorHelper.darkBlue,
    ).animate(animationControllerUser)
      ..addListener(() {
        setState(() {});
      });

    animationContainer2 = ColorTween(
      begin: ColorHelper.darkBlue,
      end: ColorHelper.white,
    ).animate(rotationControllerEvent)
      ..addListener(() {
        setState(() {});
      });

    animationIcon2 = ColorTween(
      begin: ColorHelper.white,
      end: ColorHelper.darkBlue,
    ).animate(rotationControllerEvent)
      ..addListener(() {
        setState(() {});
      });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
        BlocProvider.of<CurrentEventsBloc>(context, listen: false)
            .add(CurrentEventsRequested());
        return true;
      },
      child: CustomSafeArea(
        child: Scaffold(
          body: StreamBuilder<Position>(
              stream: BlocProvider.of<CurrentEventsBloc>(
                context,
                listen: false,
              ).locationService.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      S.current.no_address_found,
                      style: Styles.defaultGreyRegular16,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (snapshot.hasData) {
                  LatLng userPosition = LatLng(
                    snapshot.data.latitude,
                    snapshot.data.longitude,
                  );
                  return Stack(
                    children: [
                      MapWidget(
                        noClusterMarkers: _setNoClusterMarkers(userPosition),
                        markers: _setSensors(),
                        circles: _setCircles(userPosition),
                        center: LatLng(
                          widget._event.centerLatitude,
                          widget._event.centerLongitude,
                        ),
                        mapController: _mapController,
                      ),
                      Positioned(
                        bottom: 24.0,
                        left: 10.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: animationContainer.value,
                              shape: BoxShape.circle),
                          child: IconButton(
                            icon: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5)
                                  .animate(animationControllerUser),
                              child: Icon(
                                Icons.person,
                                color: animationIcon.value,
                              ),
                            ),
                            onPressed: () async {
                              await animationControllerUser.forward();
                              _centerUser(
                                LatLng(
                                  snapshot.data.latitude,
                                  snapshot.data.longitude,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24.0,
                        right: 10.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: animationContainer2.value,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.7)
                                  .animate(rotationControllerEvent),
                              child: Icon(
                                Icons.my_location_rounded,
                                color: animationIcon2.value,
                              ),
                            ),
                            onPressed: () async {
                              await rotationControllerEvent.forward();
                              _centerMap();
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        child: CustomAppBar(
                          actions: widget._canDelete
                              ? [
                                  FlatButton.icon(
                                    label: Text(
                                      S.current.event_resolve,
                                      style: Styles.whiteRegular14,
                                    ),
                                    icon: Icon(
                                      Icons.done_all,
                                      color: ColorHelper.white,
                                    ),
                                    onPressed: () async {
                                      final action = await showDialog(
                                        context: context,
                                        builder: (context) => CustomAlertDialog(
                                          oneOptionOnly: false,
                                          title: S.current.event_resolve,
                                          message: Text(
                                            S.current.close_event_question,
                                            style: Styles.defaultGreyRegular14,
                                          ),
                                        ),
                                      );

                                      if (action == CustomAction.First) {
                                        BlocProvider.of<HistoricalEventsBloc>(
                                          context,
                                          listen: false,
                                        ).add(
                                          HistoricalEventAdd(
                                            event: widget._event,
                                            sensors: widget._sensors,
                                          ),
                                        );
                                        BlocProvider.of<CurrentEventsBloc>(
                                          context,
                                          listen: false,
                                        ).add(
                                          DeleteCurrentEvent(
                                              eventToBeDeleted: widget._event),
                                        );
                                        Navigator.pop(context);
                                        widget._goToHistory();
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
                  );
                }
                return Center(child: CustomCircularIndicator());
              }),
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
    await rotationControllerEvent.reverse();
  }

  void _centerUser(LatLng userPosition) async {
    _mapController.onReady.then(
      (_) => _mapController.move(
        userPosition,
        18.5,
      ),
    );
    await animationControllerUser.reverse();
  }

  List<CircleMarker> _setCircles(LatLng userPosition) {
    return [
      CircleMarker(
        color: ColorHelper.red.withOpacity(0.5),
        point: LatLng(
          widget._event.centerLatitude,
          widget._event.centerLongitude,
        ),
        radius: 100,
        useRadiusInMeter: true,
      ),
      CircleMarker(
        color: ColorHelper.darkBlue.withOpacity(0.5),
        point: userPosition,
        radius: 10,
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

  List<Marker> _setNoClusterMarkers(LatLng userPosition) {
    return [
      Marker(
        width: 22.0,
        height: 22.0,
        point: userPosition,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: ColorHelper.white,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: ColorHelper.darkBlue),
          ),
          child: Icon(
            Icons.person,
            color: ColorHelper.darkBlue,
            size: 16.0,
          ),
        ),
      ),
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
