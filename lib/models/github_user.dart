class GitHubUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;
  final String? name;
  final String? company;
  final String? blog;
  final String? location;
  final String? bio;
  final String? twitterUsername;
  final int publicRepos;
  final int followers;
  final int following;
  final DateTime? createdAt;

  GitHubUser({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.bio,
    this.twitterUsername,
    required this.publicRepos,
    required this.followers,
    required this.following,
    this.createdAt,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      login: json['login'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      name: json['name'] as String?,
      company: json['company'] as String?,
      blog: json['blog'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      twitterUsername: json['twitter_username'] as String?,
      publicRepos: json['public_repos'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
      'name': name,
      'company': company,
      'blog': blog,
      'location': location,
      'bio': bio,
      'twitter_username': twitterUsername,
      'public_repos': publicRepos,
      'followers': followers,
      'following': following,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
