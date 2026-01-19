import 'package:flutter/material.dart';
import '../services/live_socket_service.dart';
import 'live_dashboard.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final usernameController = TextEditingController();
  final wsController = TextEditingController(text: 'ws://127.0.0.1:8899');

  LiveSocketService? socket;

  void startLive() {
    final username = usernameController.text.trim();
    final wsUrl = wsController.text.trim();

    if (username.isEmpty || wsUrl.isEmpty) return;

    socket = LiveSocketService(wsUrl);

    socket!.startLive(username);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LiveDashboard(socket: socket!, username: username),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    wsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Livestream')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // WebSocket Address
            TextField(
              controller: wsController,
              decoration: const InputDecoration(
                labelText: 'WebSocket Server',
                hintText: 'ws://127.0.0.1:8899',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // TikTok Username
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'TikTok Username',
                hintText: 'vd: phuongdao.shop',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: startLive,
                child: const Text('START'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
