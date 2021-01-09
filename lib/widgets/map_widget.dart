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
  MapWidget({
    Key key,
    @required List<Marker> markers,
    LatLng center,
    MapController mapController,
    List<CircleMarker> circles,
  })  : this._markers = markers,
        this._center = center ?? markers.first.point,
        this._mapController = mapController ?? MapController(),
        this._circles = circles ?? [],
        super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget._mapController,
      options: MapOptions(
        plugins: [
          MarkerClusterPlugin(),
        ],
        center: widget._center,
        zoom: 15.0,
        maxZoom: 19.0,
        minZoom: 13.0,
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
          maxClusterRadius: 50,
          size: Size(36.0, 36.0),
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: widget._markers,
          builder: (context, markers) {
            return FloatingActionButton(
              backgroundColor: ColorHelper.darkBlue,
              child: Text('${markers.length}'),
              onPressed: null,
            );
          },
        ),
      ],
    );
  }
}
