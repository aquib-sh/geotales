import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotales/providers/file_provider.dart';
import 'package:geotales/providers/map_provider.dart';
import 'package:geotales/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FileProvider, MapProvider>(
      builder: (context, files, map, child) => Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(title: const Text("Home")),
        body: FlutterMap(
          mapController: map.mapController,
          options: MapOptions(
              center: map.currentLocation,
              zoom: map.zoom,
              maxZoom: map.maxZoom,
              minZoom: map.minZoom,
              onTap: (tapPosition, point) {
                files.fetchImages();
                map.mapClickEvent(
                    context: context,
                    position: tapPosition,
                    coordinates: point);
              }),
          children: [
            TileLayer(
              urlTemplate: map.urlTemplate,
              subdomains: map.subdomains,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: map.navigateToCurrentLocation,
          child: const Icon(Icons.location_searching),
        ),
      ),
    );
  }
}
