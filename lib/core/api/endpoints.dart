/// Centralized API endpoints for the entire app
class ApiEndpoints {
  // Base URL - using 10.0.2.2 for Android emulator to reach host machine
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Shift endpoints
  static const String getShift = '/driver/shift';
  static const String getOrder = '/orders';
  static const String updateOrderStatus = '/orders';

  // WebSocket - using 10.0.2.2 for Android emulator
  static const String webSocketUrl = 'ws://10.0.2.2:3001';

  // Helper methods for dynamic endpoints
  static String getOrderById(String orderId) => '$getOrder/$orderId';
  static String updateOrderStatusById(String orderId) => '$updateOrderStatus/$orderId/status';
}
