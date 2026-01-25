// print_content_widget.dart (hoặc đặt nó ở đâu đó phù hợp)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vietcare_livestream/widgets/dashed_line.dart'; // Để định dạng thời gian

class PrintContentWidget extends StatelessWidget {
  final String uniqueId;
  final String nickname;
  final DateTime time;
  final String? content;
  final double width; // Chiều rộng của "tờ giấy" ảo

  const PrintContentWidget({
    super.key,
    required this.uniqueId,
    required this.nickname,
    required this.time,
    this.content,
    this.width = 280, // Giá trị này sẽ cần điều chỉnh tùy theo máy in 80mm hay 58mm
  });

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm dd/MM/yyyy').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Đặt chiều rộng cố định cho nội dung in
      padding: const EdgeInsets.all(8.0), // Padding nhẹ
      color: Colors.white, // Nền trắng cho nội dung
      child: Column(
        mainAxisSize: MainAxisSize.min, // Giúp Column chỉ chiếm không gian cần thiết
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            uniqueId,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            nickname,
            style: const TextStyle(
              fontSize: 24, // Kích thước chữ lớn cho nickname
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(time),
            style: const TextStyle(fontSize: 12, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            content != null && content!.isNotEmpty ? content! : '[No Comment]',
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}