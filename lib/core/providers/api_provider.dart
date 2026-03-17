import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../api/websocket_client.dart';
import '../repositories/shift_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final webSocketClientProvider = Provider<WebSocketClient>((ref) {
  return WebSocketClient();
});

final shiftRepositoryProvider = Provider<ShiftRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ShiftRepository(apiClient: apiClient);
});
