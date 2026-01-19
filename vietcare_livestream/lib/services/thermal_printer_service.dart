import 'dart:convert';
import 'dart:io';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class ThermalPrinterService {
  final String ip;
  final int port;

  Socket? _socket;

  ThermalPrinterService({required this.ip, required this.port});

  Future<void> connect() async {
    _socket = await Socket.connect(
      ip,
      port,
      timeout: const Duration(seconds: 5),
    );
  }

  Future<void> testPrint() async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final result = await printer.connect(ip, port: port);
    if (result != PosPrintResult.success) {
      throw Exception('Connect failed: $result');
    }

    printer.text(
      'TEST PRINT',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size2,
      ),
    );

    printer.hr();
    printer.text('Printer: HPRT TP80N-M');
    printer.text('Status : OK');
    printer.hr();

    printer.feed(2);
    printer.cut();
    printer.disconnect();
  }

  void disconnect() {
    _socket?.destroy();
    _socket = null;
  }

  Future<void> printComment({
    required String userId,
    required String nickname,
    required DateTime time,
    String? content,
  }) async {
    if (_socket == null) {
      await connect();
    }

    final buffer = StringBuffer();

    buffer.writeln('-------------------------');
    buffer.writeln('👤 $nickname ($userId)');
    buffer.writeln('🕒 ${_formatTime(time)}');

    if (content != null) {
      buffer.writeln('💬 $content');
    }

    buffer.writeln('-------------------------\n\n');

    _socket!.add(utf8.encode(buffer.toString()));
    await _socket!.flush();
  }

  String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}';
  }
}
