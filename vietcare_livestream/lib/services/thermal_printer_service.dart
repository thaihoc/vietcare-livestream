import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vietcare_livestream/widgets/print_content_widget.dart';
import 'package:image/image.dart' as img; // Đổi tên để tránh xung đột với thư viện Image của Flutter

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
    final ScreenshotController screenshotController = ScreenshotController();

    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final result = await printer.connect(ip, port: port);
    if (result != PosPrintResult.success) {
      throw Exception('Connect failed: $result');
    }

    try {
      final Uint8List imageBytes =
          await screenshotController.captureFromWidget(
        PrintContentWidget(
          userId: userId,
          nickname: nickname,
          time: time,
          content: content,
          width: 250,
        ),
        delay: const Duration(milliseconds: 150),
        pixelRatio: 2.0,
      );

      final img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception("Failed to decode image.");
      }

      printer.image(image, align: PosAlign.center);

      /// RESET MODE (THOÁT RASTER)
      printer.rawBytes(Uint8List.fromList([
        0x1B, 0x40, // ESC @
      ]));

      /// CUT CHUẨN HPRT
      printer.rawBytes(Uint8List.fromList([
        0x1D, 0x56, 0x41, 0x10, // GS V A 16
      ]));

      /// DELAY → cho firmware xử lý
      await Future.delayed(const Duration(milliseconds: 400));
    } finally {
      printer.disconnect();
    }
  }


}
