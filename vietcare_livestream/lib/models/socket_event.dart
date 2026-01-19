enum SocketEventType { like, share, comment }

SocketEventType parseEventType(String type) {
  switch (type) {
    case 'LIKE':
      return SocketEventType.like;
    case 'SHARE':
      return SocketEventType.share;
    case 'COMMENT':
      return SocketEventType.comment;
    default:
      throw Exception('Unknown event type: $type');
  }
}
