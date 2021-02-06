import 'dart:async';

import 'package:acoustic_event_detector/data/models/custom_exception.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Stream<Position> positionStream = Geolocator.getPositionStream(
      // intervalDuration: Duration(seconds: 10),
      // distanceFilter: 10,
      );

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(CustomException(S.current.location_disabled));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        CustomException(S.current.location_denied_permanently),
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(CustomException(S.current.location_denied));
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<bool> controlPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return false;
    }
    return true;
  }
}
