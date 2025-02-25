import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_loggin/models/usuari.dart';

class MapaPlants extends StatefulWidget {
  final Usuari usuari;

  const MapaPlants({Key? key, required this.usuari}) : super(key: key);

  @override
  _MapaPlantsState createState() => _MapaPlantsState();
}

class _MapaPlantsState extends State<MapaPlants> {
  GoogleMapController? _controller;
  final LatLng _center = LatLng(37.7749, -122.4194); // San Francisco como base
  final List<String> _imageAssets = [
    'assets/galeriaPlantes/1.png',
    'assets/galeriaPlantes/2.png',
    'assets/galeriaPlantes/3.png',
    'assets/galeriaPlantes/4.png',
  ];

  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _generateRandomMarkers();
  }

  void _generateRandomMarkers() async {
    final Random random = Random();
    Set<Marker> newMarkers = {
      Marker(
        markerId: MarkerId("center"),
        position: _center,
        infoWindow: InfoWindow(
          title: "Ubicación Central",
          snippet: widget.usuari.nom, // Mostrar el nombre del usuario
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };

    for (int i = 0; i < 5; i++) {
      double randomLat = _center.latitude + (random.nextDouble() - 0.5) * 0.02;
      double randomLng = _center.longitude + (random.nextDouble() - 0.5) * 0.02;
      String randomImage = _imageAssets[random.nextInt(_imageAssets.length)];
      
      final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)),
        randomImage,
      );

      newMarkers.add(
        Marker(
          markerId: MarkerId("marker_$i"),
          position: LatLng(randomLat, randomLng),
          icon: markerIcon,
        ),
      );
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa de Plantas")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _controller = controller;
              });
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
              tilt: 45.0, // Añadir tilt
            ),
            mapType: _currentMapType,
            markers: _markers,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _onMapTypeButtonPressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.green,
              child: const Icon(Icons.map, size: 36.0),
            ),
          ),
        ],
      ),
    );
  }
}
