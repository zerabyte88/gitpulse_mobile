import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/contribution_stats.dart';
import '../models/github_repo.dart';
import '../models/github_user.dart';
import '../models/user_stats.dart';

class GitHubApiException implements Exception {
  final String message;
  GitHubApiException(this.message);

  @override
  String toString() => message;
}

class GitHubApiService {
  static const String _baseUrl = 'https://api.github.com';
  static const Duration _timeoutDuration = Duration(seconds: 15);
  final http.Client _client;
  String? personalAccessToken;

  GitHubApiService({http.Client? client, this.personalAccessToken})
      : _client = client ?? http.Client();

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'GitPulse-Mobile-App',
    };
    if (personalAccessToken != null && personalAccessToken!.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${personalAccessToken!.trim()}';
    }
    return headers;
  }

  Future<ContributionStats?> _fetchContributions(String username) async {
    try {
      final uri = Uri.parse('https://github-contributions-api.jogruber.de/v4/$username');
      final res = await _client.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return ContributionStats.fromContributionsApi(data);
      }
    } catch (_) {
      // Ignored: will fallback to event-based calculation
    }
    return null;
  }

  Future<UserStats> fetchUserStats(String username) async {
    final cleanUsername = username.trim();
    if (cleanUsername.isEmpty) {
      throw GitHubApiException('Username GitHub tidak boleh kosong.');
    }

    try {
      // Kick off contributions fetch in background early
      final contribFuture = _fetchContributions(cleanUsername);

      // 1. Fetch User Profile
      final userUri = Uri.parse('$_baseUrl/users/$cleanUsername');
      final userRes = await _client.get(userUri, headers: _headers).timeout(_timeoutDuration);

      if (userRes.statusCode == 404) {
        throw GitHubApiException('Pengguna "$cleanUsername" tidak ditemukan di GitHub.');
      } else if (userRes.statusCode == 403) {
        throw GitHubApiException(
            'Limit GitHub API tercapai (60 req/jam). Coba beberapa saat lagi atau masukkan GitHub Token.');
      } else if (userRes.statusCode != 200) {
        throw GitHubApiException(
            'Gagal memuat profil (${userRes.statusCode}): ${userRes.reasonPhrase}');
      }

      final userData = jsonDecode(userRes.body) as Map<String, dynamic>;
      final user = GitHubUser.fromJson(userData);

      // 2. Fetch Repositories (up to 100 recent)
      final reposUri = Uri.parse(
          '$_baseUrl/users/$cleanUsername/repos?per_page=100&sort=updated');
      final reposRes = await _client.get(reposUri, headers: _headers).timeout(_timeoutDuration);
      final List<GitHubRepo> repos = [];

      if (reposRes.statusCode == 200) {
        final List<dynamic> reposData = jsonDecode(reposRes.body) as List<dynamic>;
        for (final item in reposData) {
          if (item is Map<String, dynamic>) {
            repos.add(GitHubRepo.fromJson(item));
          }
        }
      }

      // Sort repos by stars descending
      repos.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));

      // 3. Fetch Public Events for activity analysis
      final eventsUri =
          Uri.parse('$_baseUrl/users/$cleanUsername/events/public?per_page=100');
      final eventsRes = await _client.get(eventsUri, headers: _headers).timeout(_timeoutDuration);
      final List<Map<String, dynamic>> events = [];

      if (eventsRes.statusCode == 200) {
        final List<dynamic> eventsData = jsonDecode(eventsRes.body) as List<dynamic>;
        for (final item in eventsData) {
          if (item is Map<String, dynamic>) {
            events.add(item);
          }
        }
      }

      // 4. Fetch Language breakdown from active repositories
      final nonForkRepos = repos.where((r) => !r.isFork).toList();
      final Map<String, int> aggregatedLanguages = {};

      if (nonForkRepos.isNotEmpty) {
        // Prioritize repositories by size so the most significant codebases are captured
        final prioritizedRepos = List<GitHubRepo>.from(nonForkRepos)
          ..sort((a, b) => b.size.compareTo(a.size));

        // Limit queries to avoid exhausting unauthenticated rate limits (max 8 unauthenticated, 25 authenticated)
        final maxRepoQueries = personalAccessToken != null ? 25 : 8;
        final targetRepos = prioritizedRepos.take(maxRepoQueries).toList();

        final futures = targetRepos.map((repo) async {
          try {
            final langUri = Uri.parse('$_baseUrl/repos/$cleanUsername/${repo.name}/languages');
            final langRes = await _client.get(langUri, headers: _headers).timeout(const Duration(seconds: 8));
            if (langRes.statusCode == 200) {
              final Map<String, dynamic> data = jsonDecode(langRes.body) as Map<String, dynamic>;
              return data.map((k, v) => MapEntry(k, (v as num).toInt()));
            }
          } catch (_) {
            // Silently ignore individual repo language fetch issues
          }
          return <String, int>{};
        });

        final results = await Future.wait(futures);
        for (final repoLangs in results) {
          repoLangs.forEach((lang, bytes) {
            aggregatedLanguages[lang] = (aggregatedLanguages[lang] ?? 0) + bytes;
          });
        }
      }

      // Await contribution stats or fallback to public events
      final fetchedContributions = await contribFuture;
      final contributionStats = fetchedContributions ?? ContributionStats.fromEvents(events);

      return UserStats.calculate(
        user: user,
        repos: repos,
        publicEvents: events,
        contributionStats: contributionStats,
        aggregatedLanguages: aggregatedLanguages,
      );
    } on SocketException catch (e) {
      if (e.osError?.errorCode == 13 || e.message.toLowerCase().contains('permission')) {
        throw GitHubApiException('Izin akses internet belum diaktifkan pada sistem aplikasi.');
      }
      throw GitHubApiException('Tidak ada koneksi internet. Periksa jaringan kamu.');
    } on TimeoutException {
      throw GitHubApiException('Koneksi timeout. Server GitHub tidak merespons tepat waktu.');
    } on http.ClientException {
      throw GitHubApiException('Gagal berkomunikasi dengan server GitHub.');
    } catch (e) {
      if (e is GitHubApiException) rethrow;
      throw GitHubApiException('Terjadi kesalahan tak terduga: $e');
    }
  }
}
