import 'package:acoustic_event_detector/data/models/custom_exception.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/screens/sensors/picked_location_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_app_bar.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_floating_button.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_safe_area.dart';
import 'package:acoustic_event_detector/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class PickLocationScreen extends StatefulWidget {
  static const routeName = '/pick-location';
  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  PickedLocationBloc _pickedLocationBloc = PickedLocationBloc();

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        body: FutureBuilder<Position>(
          future: BlocProvider.of<SensorsBloc>(context, listen: false)
              .locationService
              .determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              String message = S.current.error_default;
              if (snapshot.error is CustomException) {
                message = snapshot.error.toString();
              }
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: Styles.mediumBlueRegular16,
                    ),
                    CustomFloatingButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(child: CustomCircularIndicator()),
                              ],
                            ),
                          ),
                        );
                        final bool perm = await BlocProvider.of<SensorsBloc>(
                          context,
                          listen: false,
                        ).locationService.controlPermission();
                        if (perm) {
                          setState(() {});
                        }
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.place_outlined,
                        color: ColorHelper.white,
                      ),
                      label: S.current.allow_share_current_location,
                    )
                  ],
                ),
              );
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CustomCircularIndicator());
            }

            return Stack(
              children: [
                MapWidget(
                  center:
                      LatLng(snapshot.data.latitude, snapshot.data.longitude),
                  onTap: true,
                  pickedLocationBloc: _pickedLocationBloc,
                ),
                Positioned(
                  child: CustomAppBar(title: S.current.pick_position),
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                ),
                Positioned(
                  child: CustomFloatingButton(
                    onPressed: () async {
                      print(_pickedLocationBloc.location);

                      if (_pickedLocationBloc.location != null) {
                        Navigator.pop(context, _pickedLocationBloc.location);
                      } else {
                        CustomAction result = await showDialog(
                          context: context,
                          builder: (context) => CustomPlatformAlertDialog(
                            title: S.current.pick_sensor_title,
                            message: Text(
                              S.current.pick_sensor_message,
                              style: Styles.mediumBlueRegular16,
                            ),
                            onlySecondImportant: true,
                            oneOptionOnly: false,
                          ),
                        );

                        if (result == CustomAction.First) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    label: S.current.select,
                    icon: Icon(
                      Icons.done_rounded,
                      color: ColorHelper.white,
                    ),
                  ),
                  bottom: 16.0,
                  right: 8.0,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
