
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Obligatorio para manejar coordenadas LatLng

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 1. Instanciar el controlador para mover el mapa programáticamente
  final MapController _mapController = MapController();

  // 2. Definir la coordenada inicial (Estado dinámico)
  LatLng _coordenadaActual = const LatLng(-33.30486, -66.33618); // San Luis

  // 3. Función para actualizar la coordenada y mover la cámara
  void _actualizarUbicacion(LatLng nuevaCoordenada) {
    setState(() {
      _coordenadaActual = nuevaCoordenada;
    });
    // Mueve la cámara suavemente al nuevo punto con un zoom de 14.0
    _mapController.move(nuevaCoordenada, 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coordenadas Dinámicas')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _coordenadaActual,
          initialZoom: 13.0,
          // Cambia la coordenada dinámicamente al hacer clic en cualquier parte del mapa
          onTap: (tapPosition, point) => _actualizarUbicacion(point),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.sanluiscloud.preventa',
          ),
          // 4. Capa de marcadores vinculada a la variable de estado
          MarkerLayer(
            markers: [
              Marker(
                point: _coordenadaActual,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      // Botón flotante para simular un cambio de coordenadas externo (ej. GPS o API)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Nueva coordenada simulada (ej. Santiago de Chile)
          final nuevaPosicion = const LatLng(-33.4489, -70.6693);
          _actualizarUbicacion(nuevaPosicion);
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }
}




