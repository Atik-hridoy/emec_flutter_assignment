import '../api/api_client.dart';
import '../api/endpoints.dart';
import '../models/order.dart';
import '../models/shift.dart';

class ShiftRepository {
  final ApiClient _apiClient;

  ShiftRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Shift> getShift() async {
    return _apiClient.get(
      ApiEndpoints.getShift,
      fromJson: (json) => Shift.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Order> getOrder(String orderId) async {
    return _apiClient.get(
      ApiEndpoints.getOrderById(orderId),
      fromJson: (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Order> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    return _apiClient.patch(
      ApiEndpoints.updateOrderStatusById(orderId),
      data: {'status': newStatus.toJson()},
      fromJson: (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }
}
