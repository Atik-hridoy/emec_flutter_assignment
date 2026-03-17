import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/websocket_client.dart';
import '../../core/models/order.dart';
import '../../core/models/shift.dart';
import '../../core/providers/api_provider.dart';
import '../../core/repositories/shift_repository.dart';

final shiftProvider = FutureProvider<Shift>((ref) async {
  final repository = ref.watch(shiftRepositoryProvider);
  return repository.getShift();
});

final ordersProvider = FutureProvider<List<Order>>((ref) async {
  final shift = await ref.watch(shiftProvider.future);
  return shift.orders;
});

/// Manages real-time order updates via WebSocket
final orderListNotifierProvider =
    StateNotifierProvider<OrderListNotifier, AsyncValue<List<Order>>>((ref) {
  final wsClient = ref.watch(webSocketClientProvider);
  final shiftRepo = ref.watch(shiftRepositoryProvider);
  return OrderListNotifier(wsClient, shiftRepo);
});

class OrderListNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final WebSocketClient _wsClient;
  final ShiftRepository _shiftRepo;
  bool _initialized = false;

  OrderListNotifier(this._wsClient, this._shiftRepo)
      : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final shift = await _shiftRepo.getShift();
      state = AsyncValue.data(shift.orders);

      // Connect WebSocket and listen for updates
      await _wsClient.connect();
      _wsClient.messages.listen((message) {
        if (message.event == 'order_status_updated') {
          _handleOrderStatusUpdate(message.data);
        }
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _handleOrderStatusUpdate(Map<String, dynamic> data) {
    final orderId = data['order_id'] as String?;
    final statusStr = data['status'] as String?;

    if (orderId == null || statusStr == null) return;

    state.whenData((orders) {
      final updatedOrders = orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: OrderStatus.fromJson(statusStr));
        }
        return order;
      }).toList();

      state = AsyncValue.data(updatedOrders);
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final shift = await _shiftRepo.getShift();
      state = AsyncValue.data(shift.orders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _wsClient.dispose();
    super.dispose();
  }
}
