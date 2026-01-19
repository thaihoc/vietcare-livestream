import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/live_event.dart';

class LiveSocketService {
  final WebSocketChannel channel;

  LiveSocketService(String url)
    : channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<LiveEvent> get eventStream {
    return channel.stream.where((e) => e != null).map((raw) {
      final json = jsonDecode(raw);
      return LiveEvent.fromJson(json);
    });
  }

  void startLive(String username) {
    final payload = {"action": "start", "username": username};

    channel.sink.add(jsonEncode(payload));
  }

  void stopLive(String username) {
    final payload = {"action": "stop", "username": username};

    channel.sink.add(jsonEncode(payload));
  }

  void dispose() {
    channel.sink.close();
  }
}
