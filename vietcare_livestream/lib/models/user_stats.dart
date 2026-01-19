class UserStats {
  final String userId;
  final String nickname;
  int commentCount = 0;
  int shareCount = 0;
  int likeCount = 0;

  UserStats({required this.userId, required this.nickname});
}
