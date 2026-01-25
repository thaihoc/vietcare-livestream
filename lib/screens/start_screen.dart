import 'package:flutter/material.dart';
import 'package:vietcare_livestream/services/config_service.dart';
import '../services/live_socket_service.dart';
import 'live_dashboard.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final config = ConfigService();
  final usernameController = TextEditingController(text: 'phuongdao.shop');
  final wsController = TextEditingController(text: 'ws://192.168.1.201:8899');
  final printerIPController = TextEditingController(text: '192.168.1.200');
  final printerPortController = TextEditingController(text: '9100');

  LiveSocketService? socket;

  Future<void> init() async {
    final ip = await config.getPrinterIp();
    final port = await config.getPrinterPort();
    final wsUrl = await config.getWsUrl();
    final tiktokUsername = await config.getTiktokUsername();

    setState(() {
      printerIPController.text = ip;
      printerPortController.text = port.toString();
      wsController.text = wsUrl;
      usernameController.text = tiktokUsername;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void startLive() {
    final tiktokUsername = usernameController.text.trim();
    final wsUrl = wsController.text.trim();
    final printerIP = printerIPController.text.trim();
    final printerPort = printerPortController.text.trim();

    config.savePrinterConfig(ip: printerIP, port: int.parse(printerPort));
    config.saveWsConfig(wsUrl);
    config.saveTiktokUsername(tiktokUsername);

    if (tiktokUsername.isEmpty || wsUrl.isEmpty) return;

    socket = LiveSocketService(wsUrl);

    socket!.startLive(tiktokUsername);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LiveDashboard(socket: socket!, 
          tiktokUsername: tiktokUsername, 
          printerIP: printerIP, 
          printerPort: int.parse(printerPort),
      ),
    ));
  }

  @override
  void dispose() {
    usernameController.dispose();
    wsController.dispose();
    printerIPController.dispose();
    printerPortController.dispose();
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
                hintText: 'ws://192.168.1.201:8899',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Printer IP
            TextField(
              controller: printerIPController,
              decoration: const InputDecoration(
                labelText: 'Printer IP Address',
                hintText: '192.168.1.200',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Printer IP
            TextField(
              controller: printerPortController,
              decoration: const InputDecoration(
                labelText: 'Printer Port',
                hintText: '9100',
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
            const SizedBox(height: 16),

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
