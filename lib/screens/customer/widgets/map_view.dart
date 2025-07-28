import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/magic_bag_model.dart';

class MapView extends StatefulWidget {
  final List<MagicBagModel> magicBags;

  const MapView({
    super.key,
    required this.magicBags,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = widget.magicBags.map((magicBag) {
      return Marker(
        markerId: MarkerId(magicBag.id),
        position: LatLng(magicBag.location.latitude, magicBag.location.longitude),
        infoWindow: InfoWindow(
          title: magicBag.vendorName,
          snippet: magicBag.title,
          onTap: () {
            // TODO: Navigate to Magic Bag details
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          magicBag.isAvailable ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.magicBags.isEmpty) {
      return const Center(
        child: Text('No Magic Bags found in this area'),
      );
    }

    // Calculate center position (average of all Magic Bags)
    double avgLat = widget.magicBags
        .map((bag) => bag.location.latitude)
        .reduce((a, b) => a + b) / widget.magicBags.length;
    double avgLng = widget.magicBags
        .map((bag) => bag.location.longitude)
        .reduce((a, b) => a + b) / widget.magicBags.length;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(avgLat, avgLng),
        zoom: 12.0,
      ),
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }
} 