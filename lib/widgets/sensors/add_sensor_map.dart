import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';

class AddSensorMap extends StatefulWidget {
  final double _latitude;
  final double _longitude;
  final Function _refreshMap;

  const AddSensorMap({
    Key key,
    @required double latitude,
    @required double longitude,
    @required Function refreshMap,
  })  : this._latitude = latitude,
        this._longitude = longitude,
        this._refreshMap = refreshMap,
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

  Future<Placemark> _getPlacemark() async {
    if (widget._latitude != null && widget._longitude != null) {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(widget._latitude, widget._longitude);

      return placemarks.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 220.0,
        width: double.infinity,
        child: FutureBuilder<Placemark>(
          future: _getPlacemark(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CustomCircularIndicator());
            }

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                snapshot.data != null
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
                                width: 30.0,
                                height: 30.0,
                                point:
                                    LatLng(widget._latitude, widget._longitude),
                                builder: (ctx) => Container(
                                  child: FlutterLogo(
                                    key: ObjectKey(Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : Center(child: Icon(Icons.map, size: 100)),
                Positioned(
                  top: 3,
                  left: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorHelper.darkBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      snapshot.data == null
                          ? 'Pre zobrazenie na mape, zadajte polohu'
                          : '${snapshot.data.street} ${snapshot.data.subLocality}',
                      style: Styles.whiteRegular14,
                    ),
                  ),
                ),
                Positioned(
                  top: 3,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async {
                      rotationController.forward(from: 0.0);
                      widget._refreshMap();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: snapshot.data != null
                            ? ColorHelper.white
                            : ColorHelper.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0)
                            .animate(rotationController),
                        child: Icon(
                          Icons.refresh,
                          color: ColorHelper.darkBlue,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
