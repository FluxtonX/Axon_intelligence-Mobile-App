import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketClient {
  IO.Socket? _socket;
  final String _baseUrl;

  // The base URL from env usually includes /api, but socket.io attaches to the root server.
  SocketClient(String baseUrl) : _baseUrl = baseUrl.replaceAll(RegExp(r'/api/?$'), '');

  void connect(String userId) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(_baseUrl, IO.OptionBuilder()
        .setTransports(['websocket']) 
        .disableAutoConnect()
        .build()
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint('Socket connected: ${_socket!.id}');
    });

    _socket!.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });

    _socket!.onError((error) {
      debugPrint('Socket Error: $error');
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  bool get isConnected => _socket?.connected ?? false;
}
