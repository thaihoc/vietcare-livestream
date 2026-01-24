import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/live_event.dart';

class LiveSocketService {
  final String url;

  WebSocketChannel? _channel;
  bool _connected = false;
  String? _username;

  final StreamController<LiveEvent> _eventController =
      StreamController<LiveEvent>.broadcast();

  LiveSocketService(this.url);

  /// Stream cho UI (an toàn, listen bao nhiêu cũng được)
  Stream<LiveEvent> get eventStream => _eventController.stream;

  void startLive(String username) {
    _username = username;
    _connect();
  }

  void _connect() {
    if (_connected) return;

    debugPrint('CONNECT WS: $url');
    _connected = true;

    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (raw) {
        final json = jsonDecode(raw);
        final event = LiveEvent.fromJson(json);
        _eventController.add(event);
      },
      onDone: () {
        debugPrint('WS CLOSED');
        _connected = false;
      },
      onError: (e) {
        debugPrint('WS ERROR: $e');
        _connected = false;
      },
    );

    _channel!.sink.add(jsonEncode({
      "action": "start",
      "username": _username,
    }));
  }

  Future<void> reconnect() async {
    if (_connected || _username == null) return;

    await Future.delayed(const Duration(seconds: 1));
    debugPrint('RECONNECT WS...');
    _connect();
  }

  void stopLive() {
    if (!_connected || _username == null) return;

    _channel?.sink.add(jsonEncode({
      "action": "stop",
      "username": _username,
    }));

    close();
  }

  void close() {
    try {
      _channel?.sink.close();
    } catch (_) {}

    _connected = false;
    _channel = null;
  }

  void dispose() {
    _eventController.close();
    close();
  }
}

