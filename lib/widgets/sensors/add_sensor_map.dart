import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class AddSensorMap extends StatefulWidget {
  final double _latitude;
  final double _longitude;
  final Function _refreshMap;
  final String _placemark;

  const AddSensorMap({
    Key key,
    @required double latitude,
    @required double longitude,
    @required Function refreshMap,
    @required String placemark,
  })  : this._latitude = latitude,
        this._longitude = longitude,
        this._refreshMap = refreshMap,
        this._placemark = placemark,
        super(key: key);

  @override
  _AddSensorMapState createState() => _AddSensorMapState();
}

class _AddSensorMapState extends State<AddSensorMap>
    with TickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          widget._placemark != null
              ? FlutterMap(
                  options: MapOptions(
                    center: LatLng(widget._latitude, widget._longitude),
                    zoom: 17.0,
                    interactive: false,
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
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 22.0,
                          height: 22.0,
                          point: LatLng(widget._latitude, widget._longitude),
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
                      ],
                    )
                  ],
                )
              : Center(child: Icon(Icons.map, size: 100.0)),
          Positioned(
            top: 3,
            left: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 6,
              ),
              decoration: BoxDecoration(
                color: widget._placemark != null
                    ? ColorHelper.white
                    : ColorHelper.transparent,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                widget._placemark == null
                    ? S.current.sensor_map_location
                    : widget._placemark,
                style: Styles.darkBlueBold14,
              ),
            ),
          ),
          Positioned(
            top: 3,
            right: 20,
            child: GestureDetector(
              onTap: () async {
                await rotationController.forward(from: 0.0);
                widget._refreshMap();
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: widget._placemark != null
                      ? ColorHelper.white
                      : ColorHelper.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(rotationController),
                  child: Icon(
                    Icons.refresh,
                    color: ColorHelper.darkBlue,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
