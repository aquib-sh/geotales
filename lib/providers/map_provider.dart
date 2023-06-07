import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotales/widgets/marker_dialog.dart';
import 'package:latlong2/latlong.dart';

class MapProvider extends ChangeNotifier {
  // URL of our tile server and it's subdomain list to use
  String urlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  List<String> subdomains = ['a', 'b', 'c'];

  final MapController mapController = MapController();

  // Basic map settings
  LatLng currentLocation = LatLng(18.9932969, 72.8202488);
  final double zoom = 10.0;
  final double maxZoom = 18.0;
  final double minZoom = 1.0;

  void mapClickEvent({
    required BuildContext context,
    required TapPosition position,
    required LatLng coordinates,
  }) {
    // implement the logic here for map clicking
    showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return MarkerDialog(
              constraints: constraints,
            );
          },
        );
      },
    );
  }

  // Navigate to to the user's current location
  void navigateToCurrentLocation() {
    getLocation();
    mapController.move(currentLocation, maxZoom);
  }

  Future<void> getLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      // Handle the case where the GPS service is not enabled
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // The user did not grant the location permission
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // The location permission is permanently denied
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position != null) {
      currentLocation = LatLng(position.latitude, position.longitude);
    } else {
      currentLocation = LatLng(18.9932969, 72.8202488);
    }
  }
}
