import 'package:shared_preferences/shared_preferences.dart';

class PrinterConfigService {
  static const _ipKey = 'printer_ip';
  static const _portKey = 'printer_port';

  Future<void> save({required String ip, required int port}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ip);
    await prefs.setInt(_portKey, port);
  }

  Future<String> getIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ipKey) ?? '192.168.119.200';
  }

  Future<int> getPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_portKey) ?? 9100;
  }
}
