import 'socket_event.dart';

class LiveEvent {
  final String userId;
  final String nickname;
  final SocketEventType type;
  final String? comment;
  final int? likeCount;
  final int? totalLikeCount;
  final DateTime time;

  LiveEvent({
    required this.userId,
    required this.nickname,
    required this.type,
    this.comment,
    this.likeCount,
    this.totalLikeCount,
    required this.time,
  });

  factory LiveEvent.fromJson(Map<String, dynamic> json) {
    final type = parseEventType(json['type']);

    return LiveEvent(
      userId: json['userId'],
      nickname: json['nickname'] ?? json['text'],
      type: type,
      comment: json['comment'],
      likeCount: json['likeCount'],
      totalLikeCount: json['totalLikeCount'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
    );
  }
}
