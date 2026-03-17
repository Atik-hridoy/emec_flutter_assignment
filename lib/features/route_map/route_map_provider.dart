import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../core/models/shift.dart';
import '../../core/providers/api_provider.dart';

final shiftForMapProvider = FutureProvider<Shift>((ref) async {
  final repository = ref.watch(shiftRepositoryProvider);
  return repository.getShift();
});

/// Current driver GPS position
final driverPositionProvider = StateProvider<LatLng?>((ref) => null);

/// Request location permission and start tracking
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    final result = await Geolocator.requestPermission();
    return result == LocationPermission.whileInUse ||
        result == LocationPermission.always;
  }
  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;
});

/// Stream of GPS position updates
final gpsStreamProvider = StreamProvider<Position>((ref) async* {
  final hasPermission = await ref.watch(locationPermissionProvider.future);
  if (!hasPermission) {
    throw Exception('Location permission denied');
  }

  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 10, // Update every 10 meters
  );

  await for (final position in Geolocator.getPositionStream(
    locationSettings: locationSettings,
  )) {
    yield position;
  }
});
