import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<void> getLocationOfUser() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      print("permissin enabled");
    } else {
      print("permission disabled");
    }
  }

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle accordingly
      openAppSettings();
      return Future.error('Location services are disabled');
    }

    // Request permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Permission to access location is denied, ask for permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission to access location is denied by the user, handle accordingly
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle accordingly
      return Future.error('Location permissions are permanently denied');
    }

    // Fetch the user's current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    // print(position);
    return position;
  }
}