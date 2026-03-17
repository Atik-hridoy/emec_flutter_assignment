import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'endpoints.dart';

class WebSocketMessage {
  final String event;
  final Map<String, dynamic> data;

  WebSocketMessage({
    required this.event,
    required this.data,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      event: json['event'] as String,
      data: json,
    );
  }
}

class WebSocketClient {
  WebSocketChannel? _channel;
  late StreamController<WebSocketMessage> _messageController;
  final String _url;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  static const _reconnectDelay = Duration(seconds: 5);

  WebSocketClient({String? url})
      : _url = url ?? ApiEndpoints.webSocketUrl {
    _messageController = StreamController<WebSocketMessage>.broadcast();
  }

  Stream<WebSocketMessage> get messages => _messageController.stream;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      _isConnected = true;
      _reconnectTimer?.cancel();

      _channel!.stream.listen(
        (message) {
          try {
            final json = jsonDecode(message as String) as Map<String, dynamic>;
            final wsMessage = WebSocketMessage.fromJson(json);
            _messageController.add(wsMessage);
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isConnected = false;
          _scheduleReconnect();
        },
        onDone: () {
          print('WebSocket closed');
          _isConnected = false;
          _scheduleReconnect();
        },
      );
    } catch (e) {
      print('Failed to connect WebSocket: $e');
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      print('Attempting to reconnect WebSocket...');
      connect();
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _isConnected = false;
    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (e) {
        print('Error closing WebSocket: $e');
      }
    }
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
