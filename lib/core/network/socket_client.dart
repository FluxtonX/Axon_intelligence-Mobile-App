import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketClient {
  IO.Socket? _socket;
  final String _baseUrl;

  // The base URL from env usually includes /api, but socket.io attaches to the root server.
  SocketClient(String baseUrl) : _baseUrl = baseUrl.replaceAll(RegExp(r'/api/?$'), '');

  final Map<String, List<Function(dynamic)>> _listeners = {};

  void connect(String token) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(_baseUrl, IO.OptionBuilder()
        .setTransports(['websocket']) 
        .disableAutoConnect()
        .setAuth({'token': 'Bearer $token'})
        .build()
    );

    // Attach all pending listeners to the new socket
    _listeners.forEach((event, callbacks) {
      for (var callback in callbacks) {
        _socket!.on(event, callback);
      }
    });

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
    _listeners.clear();
  }

  void on(String event, Function(dynamic) callback) {
    if (!_listeners.containsKey(event)) {
      _listeners[event] = [];
    }
    _listeners[event]!.add(callback);
    _socket?.on(event, callback);
  }

  void off(String event) {
    _listeners.remove(event);
    _socket?.off(event);
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  bool get isConnected => _socket?.connected ?? false;
}
