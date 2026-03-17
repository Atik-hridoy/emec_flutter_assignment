/// Centralized API endpoints for the entire app
class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://192.168.1.5:3000';

  // Shift endpoints
  static const String getShift = '/driver/shift';
  static const String getOrder = '/orders';
  static const String updateOrderStatus = '/orders';

  // WebSocket
  static const String webSocketUrl = 'ws://192.168.1.5:3001';

  // Helper methods for dynamic endpoints
  static String getOrderById(String orderId) => '$getOrder/$orderId';
  static String updateOrderStatusById(String orderId) => '$updateOrderStatus/$orderId/status';
}
