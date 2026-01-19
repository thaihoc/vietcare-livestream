import 'package:flutter/material.dart';
import 'package:vietcare_livestream/screens/start_screen.dart';
import 'package:vietcare_livestream/services/printer_config_service.dart';
import 'package:vietcare_livestream/services/thermal_printer_service.dart';
import '../models/live_event.dart';
import '../models/user_stats.dart';
import '../models/socket_event.dart';
import '../services/live_socket_service.dart';

class LiveDashboard extends StatefulWidget {
  final LiveSocketService socket;
  final String username;

  const LiveDashboard({
    super.key,
    required this.socket,
    required this.username,
  });

  @override
  State<LiveDashboard> createState() => _LiveDashboardState();
}

class _LiveDashboardState extends State<LiveDashboard>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final config = PrinterConfigService();
  ThermalPrinterService? printerService;

  final List<LiveEvent> comments = [];
  final Map<String, UserStats> userStats = {};

  Future<void> initPrinter() async {
    final ip = await config.getIp();
    final port = await config.getPort();

    setState(() {
      printerService = ThermalPrinterService(ip: ip, port: port);
    });
  }

  @override
  void initState() {
    super.initState();
    initPrinter();
    tabController = TabController(length: 2, vsync: this);

    widget.socket.eventStream.listen(handleEvent);
  }

  void stopLive() {
    widget.socket.stopLive(widget.username);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StartScreen()),
    );
  }

  void printComment(LiveEvent event) async {
    if (printerService == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('⚠️ Chưa cấu hình máy in')));
      return;
    }

    try {
      await printerService!.printComment(
        userId: event.userId,
        nickname: event.nickname,
        time: event.time,
        content: event.comment,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('🖨️ In thành công')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Lỗi in: $e')));
    }
  }

  void handleEvent(LiveEvent event) {
    setState(() {
      userStats.putIfAbsent(
        event.userId,
        () => UserStats(userId: event.userId, nickname: event.nickname),
      );

      final stats = userStats[event.userId]!;

      switch (event.type) {
        case SocketEventType.comment:
          stats.commentCount++;
          comments.insert(0, event);
          break;
        case SocketEventType.share:
          stats.shareCount++;
          break;
        case SocketEventType.like:
          stats.likeCount += event.likeCount ?? 1;
          break;
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live: ${widget.username}'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Comments'),
            Tab(text: 'Ranking'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop_circle, color: Colors.red),
            tooltip: 'Stop Live',
            onPressed: stopLive,
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [buildCommentTab(), buildRankingTab()],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.day.toString().padLeft(2, '0')}/'
        '${time.month.toString().padLeft(2, '0')}/'
        '${time.year} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  Widget buildCommentTab() {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final c = comments[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(c.nickname),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.comment ?? ''),
                Text(
                  _formatTime(c.time),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                printerService!.printComment(
                  userId: c.userId,
                  nickname: c.nickname,
                  time: c.time,
                  content: c.comment,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildRankingTab() {
    final sortedUsers = userStats.values.toList()
      ..sort(
        (a, b) => (b.likeCount + b.shareCount * 2 + b.commentCount).compareTo(
          a.likeCount + a.shareCount * 2 + a.commentCount,
        ),
      );

    return ListView.builder(
      itemCount: sortedUsers.length,
      itemBuilder: (_, i) {
        final u = sortedUsers[i];
        return ListTile(
          leading: Text('#${i + 1}'),
          title: Text(u.nickname),
          subtitle: Text(
            '💬 ${u.commentCount}  🔁 ${u.shareCount}  ❤️ ${u.likeCount}',
          ),
        );
      },
    );
  }
}
