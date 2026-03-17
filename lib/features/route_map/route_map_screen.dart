import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../core/models/order.dart';
import 'route_map_provider.dart';
import 'widgets/driver_marker.dart';

class RouteMapScreen extends ConsumerStatefulWidget {
  const RouteMapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends ConsumerState<RouteMapScreen> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shiftAsync = ref.watch(shiftForMapProvider);
    final gpsAsync = ref.watch(gpsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map'),
        elevation: 0,
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: shiftAsync.when(
        data: (shift) {
          final orders = shift.orders;
          final routeCoords = shift.routeGeometry.coordinates
              .map((coord) => LatLng(coord[1], coord[0]))
              .toList();

          // Build markers for each order
          final markers = <Marker>[
            ...orders.asMap().entries.map((entry) {
              final index = entry.key;
              final order = entry.value;
              final isCompleted = order.status == OrderStatus.delivered;

              return Marker(
                point: LatLng(order.lat, order.lng),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _showOrderBottomSheet(context, order),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green : Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ];

          // Add driver position marker
          return gpsAsync.when(
            data: (position) {
              final driverLatLng = LatLng(position.latitude, position.longitude);
              markers.add(
                Marker(
                  point: driverLatLng,
                  width: 40,
                  height: 40,
                  child: const DriverMarker(),
                ),
              );

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: routeCoords.isNotEmpty
                      ? routeCoords.first
                      : const LatLng(23.8103, 90.4125),
                  initialZoom: 14,
                  onMapReady: () {
                    if (routeCoords.isNotEmpty) {
                      _fitBounds(routeCoords);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routeCoords,
                        color: Colors.blue.withOpacity(0.6),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
            loading: () => FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: routeCoords.isNotEmpty
                    ? routeCoords.first
                    : const LatLng(23.8103, 90.4125),
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routeCoords,
                      color: Colors.blue.withOpacity(0.6),
                      strokeWidth: 3,
                    ),
                  ],
                ),
                MarkerLayer(markers: markers),
              ],
            ),
            error: (error, st) => FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: routeCoords.isNotEmpty
                    ? routeCoords.first
                    : const LatLng(23.8103, 90.4125),
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routeCoords,
                      color: Colors.blue.withOpacity(0.6),
                      strokeWidth: 3,
                    ),
                  ],
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load route',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(shiftForMapProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fitBounds(List<LatLng> points) {
    if (points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat > point.latitude ? point.latitude : minLat;
      maxLat = maxLat < point.latitude ? point.latitude : maxLat;
      minLng = minLng > point.longitude ? point.longitude : minLng;
      maxLng = maxLng < point.longitude ? point.longitude : maxLng;
    }

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(
          LatLng(minLat, minLng),
          LatLng(maxLat, maxLng),
        ),
        padding: const EdgeInsets.all(100),
      ),
    );
  }

  void _showOrderBottomSheet(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.customerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              order.address,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                order.status.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to order detail
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.assigned => Colors.blue,
      OrderStatus.pickedUp => Colors.blue,
      OrderStatus.enRoute => Colors.amber,
      OrderStatus.delivered => Colors.green,
      OrderStatus.failed => Colors.red,
    };
  }
}
