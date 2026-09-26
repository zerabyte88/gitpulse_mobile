class GitHubRepo {
  final String name;
  final String? description;
  final String htmlUrl;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final bool isFork;
  final DateTime? updatedAt;

  GitHubRepo({
    required this.name,
    this.description,
    required this.htmlUrl,
    this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.isFork,
    this.updatedAt,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'] as String? ?? 'Untitled',
      description: json['description'] as String?,
      htmlUrl: json['html_url'] as String? ?? '',
      language: json['language'] as String?,
      stargazersCount: json['stargazers_count'] as int? ?? 0,
      forksCount: json['forks_count'] as int? ?? 0,
      isFork: json['fork'] as bool? ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }
}
