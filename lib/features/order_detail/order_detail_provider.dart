import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/order.dart';
import '../../core/providers/api_provider.dart';
import '../../core/repositories/shift_repository.dart';

final orderDetailProvider =
    FutureProvider.family<Order, String>((ref, orderId) async {
  final repository = ref.watch(shiftRepositoryProvider);
  return repository.getOrder(orderId);
});

final orderStatusUpdateProvider =
    StateNotifierProvider.family<OrderStatusUpdateNotifier, AsyncValue<Order>,
        String>((ref, orderId) {
  final repository = ref.watch(shiftRepositoryProvider);
  return OrderStatusUpdateNotifier(repository, orderId);
});

class OrderStatusUpdateNotifier extends StateNotifier<AsyncValue<Order>> {
  final ShiftRepository _repository;
  final String _orderId;

  OrderStatusUpdateNotifier(this._repository, this._orderId)
      : super(const AsyncValue.loading()) {
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    try {
      final order = await _repository.getOrder(_orderId);
      state = AsyncValue.data(order);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStatus(OrderStatus newStatus) async {
    state = const AsyncValue.loading();
    try {
      final updatedOrder = await _repository.updateOrderStatus(_orderId, newStatus);
      state = AsyncValue.data(updatedOrder);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
