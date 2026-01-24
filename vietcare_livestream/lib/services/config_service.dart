import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const _printerIP = 'printer_ip';
  static const _printerPort = 'printer_port';
  static const _wsUrl = 'ws_url';
  static const _tiktokUsername = 'tiktok_username';

  Future<void> savePrinterConfig({required String ip, required int port}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_printerIP, ip);
    await prefs.setInt(_printerPort, port);
  }

  Future<void> saveWsConfig(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_wsUrl, url);
  }

  Future<void> saveTiktokUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tiktokUsername, username);
  }


  Future<String> getPrinterIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_printerIP) ?? '192.168.1.200';
  }

  Future<int> getPrinterPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_printerPort) ?? 9100;
  }

  Future<String> getWsUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_wsUrl) ?? "ws://192.168.1.201:8899";
  }

  Future<String> getTiktokUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tiktokUsername) ?? "phuongdao.shop";
  }
}
