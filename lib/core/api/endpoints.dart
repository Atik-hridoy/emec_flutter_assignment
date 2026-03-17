
class ApiEndpoints {

  static const String baseUrl = 'https://emec-flutter-assignment.onrender.com';


  static const String getShift = '/driver/shift';
  static const String getOrder = '/orders';
  static const String updateOrderStatus = '/orders';

 
  static const String webSocketUrl = 'wss://emec-flutter-assignment.onrender.com';


  static String getOrderById(String orderId) => '$getOrder/$orderId';
  static String updateOrderStatusById(String orderId) => '$updateOrderStatus/$orderId/status';
}
