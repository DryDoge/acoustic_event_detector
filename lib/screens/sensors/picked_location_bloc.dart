import 'package:latlong/latlong.dart';

class PickedLocationBloc {
  LatLng position;

  LatLng get location {
    return position;
  }

  set location(LatLng position) {
    this.position = position;
  }
}
