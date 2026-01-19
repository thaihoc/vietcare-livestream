import 'package:flutter/material.dart';
import '../services/printer_config_service.dart';
import '../services/thermal_printer_service.dart';

class PrinterConfigScreen extends StatefulWidget {
  const PrinterConfigScreen({super.key});

  @override
  State<PrinterConfigScreen> createState() => _PrinterConfigScreenState();
}

class _PrinterConfigScreenState extends State<PrinterConfigScreen> {
  final ipController = TextEditingController();
  final portController = TextEditingController(text: '9100');

  final configService = PrinterConfigService();

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  Future<void> loadConfig() async {
    ipController.text = await configService.getIp();
    portController.text = (await configService.getPort()).toString();
  }

  Future<void> saveConfig() async {
    await configService.save(
      ip: ipController.text.trim(),
      port: int.parse(portController.text),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('✅ Đã lưu cấu hình')));
  }

  Future<void> testPrint() async {
    try {
      final printer = ThermalPrinterService(
        ip: ipController.text.trim(),
        port: int.parse(portController.text),
      );

      await printer.testPrint();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('🖨️ In test thành công')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ In lỗi: $e')));
    }
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Printer Config')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'Printer IP',
                hintText: 'vd: 192.168.1.50',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: testPrint,
                    icon: const Icon(Icons.print),
                    label: const Text('TEST PRINT'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: saveConfig,
                    icon: const Icon(Icons.save),
                    label: const Text('SAVE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
