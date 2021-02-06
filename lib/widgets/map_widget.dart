import 'package:acoustic_event_detector/screens/sensors/picked_location_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';

class MapWidget extends StatefulWidget {
  final List<Marker> _markers;
  final List<CircleMarker> _circles;
  final LatLng _center;
  final MapController _mapController;
  final bool _onTap;
  final PickedLocationBloc _pickedLocationBloc;
  final List<Marker> _noClusterMarkers;

  MapWidget({
    Key key,
    List<Marker> markers,
    LatLng center,
    MapController mapController,
    List<CircleMarker> circles,
    bool onTap,
    PickedLocationBloc pickedLocationBloc,
    List<Marker> noClusterMarkers,
  })  : this._markers = markers ?? [],
        this._center = center,
        this._mapController = mapController ?? MapController(),
        this._circles = circles ?? [],
        this._onTap = onTap ?? false,
        this._pickedLocationBloc = pickedLocationBloc,
        this._noClusterMarkers = noClusterMarkers ?? [],
        super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = widget._markers;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget._mapController,
      options: MapOptions(
        onTap: widget._onTap
            ? (point) {
                widget._pickedLocationBloc.location = point;
                setState(() {
                  _markers = [
                    Marker(
                      width: 22.0,
                      height: 22.0,
                      point: point,
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
                    )
                  ];
                });
              }
            : (point) {},
        plugins: [
          MarkerClusterPlugin(),
        ],
        center: widget._center,
        zoom: 15.0,
        maxZoom: 19.0,
        minZoom: 3.0,
      ),
      layers: [
        TileLayerOptions(
          maxZoom: 20.0,
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          // For example purposes. It is recommended to use
          // TileProvider with a caching and retry strategy, like
          // NetworkTileProvider or CachedNetworkTileProvider
          tileProvider: CachedNetworkTileProvider(),
        ),
        CircleLayerOptions(circles: widget._circles),
        MarkerClusterLayerOptions(
          disableClusteringAtZoom: 17,
          showPolygon: false,
          maxClusterRadius: 30,
          size: Size(36.0, 36.0),
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: _markers,
          builder: (context, markers) {
            return FloatingActionButton(
              backgroundColor: ColorHelper.darkBlue,
              child: Text('${markers.length}'),
              onPressed: null,
            );
          },
        ),
        MarkerLayerOptions(markers: widget._noClusterMarkers),
      ],
    );
  }
}
