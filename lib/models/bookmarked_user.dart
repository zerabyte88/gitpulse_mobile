class BookmarkedUser {
  final String username;
  final String avatarUrl;

  const BookmarkedUser({
    required this.username,
    required this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'avatar_url': avatarUrl,
    };
  }

  factory BookmarkedUser.fromJson(Map<String, dynamic> json) {
    final username = json['username'] as String? ?? '';
    return BookmarkedUser(
      username: username,
      avatarUrl: json['avatar_url'] as String? ?? 'https://github.com/$username.png',
    );
  }
}
