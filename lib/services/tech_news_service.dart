import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tech_news.dart';

class TechNewsService {
  final http.Client _client;
  String? personalAccessToken;
  final Map<String, List<TechNews>> _cache = {};

  TechNewsService({http.Client? client, this.personalAccessToken})
      : _client = client ?? http.Client();

  void clearCache() => _cache.clear();

  Future<List<TechNews>> fetchNews({String tag = 'trending', bool forceRefresh = false}) async {
    if (!forceRefresh && _cache.containsKey(tag) && _cache[tag]!.isNotEmpty) {
      return _cache[tag]!;
    }

    if (tag == 'trending') {
      final repos = await fetchTrendingRepos();
      _cache['trending'] = repos;
      return repos;
    }

    try {
      final url = Uri.parse(
        'https://dev.to/api/articles?tag=${Uri.encodeComponent(tag)}&per_page=12',
      );
      final response = await _client.get(
        url,
        headers: {
          'User-Agent': 'GitPulseMobile/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final news = data
              .map((json) => TechNews.fromJson(json as Map<String, dynamic>))
              .toList();
          _cache[tag] = news;
          return news;
        }
      }
    } catch (_) {
      // Fallback to curated news if network fails or offline
    }

    final fallback = _getFallbackNews(tag);
    _cache[tag] = fallback;
    return fallback;
  }

  /// Fetches top trending active repositories from GitHub Search API
  Future<List<TechNews>> fetchTrendingRepos() async {
    try {
      final now = DateTime.now();
      final pastDate = now.subtract(const Duration(days: 30));
      final dateStr =
          '${pastDate.year}-${pastDate.month.toString().padLeft(2, '0')}-${pastDate.day.toString().padLeft(2, '0')}';
      final url = Uri.parse(
        'https://api.github.com/search/repositories?q=stars:>500+pushed:>$dateStr&sort=stars&order=desc&per_page=12',
      );
      final headers = <String, String>{
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'GitPulseMobile/1.0',
      };
      if (personalAccessToken != null && personalAccessToken!.trim().isNotEmpty) {
        headers['Authorization'] = 'Bearer ${personalAccessToken!.trim()}';
      }

      final response = await _client
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 9));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final items = data['items'] as List?;
        if (items != null && items.isNotEmpty) {
          return items.map((item) {
            final repo = item as Map<String, dynamic>;
            final owner = repo['owner'] as Map<String, dynamic>?;
            final stars = repo['stargazers_count'] ?? 0;
            final lang = repo['language']?.toString() ?? 'Code';
            final fullName = repo['full_name']?.toString() ?? 'Repo';
            return TechNews(
              id: (repo['id'] as num?)?.toInt() ?? 0,
              title: '⭐ $fullName ($stars stars)',
              description: repo['description']?.toString() ??
                  'Open-source repository trending on GitHub with active development.',
              url: repo['html_url']?.toString() ?? 'https://github.com',
              coverImage: null,
              authorName: owner?['login']?.toString() ?? 'github',
              authorAvatar: owner?['avatar_url']?.toString(),
              publishedDate: 'Trending $lang',
              readingTimeMinutes: 3,
              tags: ['trending', 'github', lang.toLowerCase()],
            );
          }).toList();
        }
      }
    } catch (_) {
      // Fallback
    }

    return _getFallbackNews('trending');
  }

  List<TechNews> _getFallbackNews(String tag) {
    if (tag == 'trending') {
      return [
        const TechNews(
          id: 501,
          title: '⭐ flutter/flutter (165,000+ stars)',
          description:
              'Framework open source revolusioner Google untuk membangun aplikasi multiplatform dari satu basis kode.',
          url: 'https://github.com/flutter/flutter',
          coverImage: null,
          authorName: 'flutter',
          authorAvatar: 'https://github.com/flutter.png',
          publishedDate: 'Trending Dart',
          readingTimeMinutes: 3,
          tags: ['trending', 'dart', 'flutter'],
        ),
        const TechNews(
          id: 502,
          title: '⭐ torvalds/linux (185,000+ stars)',
          description:
              'Kernel sistem operasi Linux yang mendasari komputasi modern, cloud, dan mobile di seluruh dunia.',
          url: 'https://github.com/torvalds/linux',
          coverImage: null,
          authorName: 'torvalds',
          authorAvatar: 'https://github.com/torvalds.png',
          publishedDate: 'Trending C',
          readingTimeMinutes: 4,
          tags: ['trending', 'c', 'linux'],
        ),
        const TechNews(
          id: 503,
          title: '⭐ vllm-project/vllm (32,000+ stars)',
          description:
              'Pustaka inferensi dan penyajian model LLM berkecepatan tinggi dengan alokasi memori PagedAttention.',
          url: 'https://github.com/vllm-project/vllm',
          coverImage: null,
          authorName: 'vllm-project',
          authorAvatar: 'https://github.com/vllm-project.png',
          publishedDate: 'Trending Python',
          readingTimeMinutes: 5,
          tags: ['trending', 'python', 'ai'],
        ),
      ];
    } else if (tag == 'github') {
      return [
        const TechNews(
          id: 401,
          title: 'Fitur Baru GitHub Copilot Workspace & AI Agents untuk Otomasi PR',
          description:
              'Lingkungan kerja berbasis AI terintegrasi untuk merencanakan perbaikan bug hingga implementasi kode otomatis.',
          url: 'https://github.blog',
          coverImage: null,
          authorName: 'GitHub Engineering',
          authorAvatar: 'https://github.com/github.png',
          publishedDate: 'Hari ini',
          readingTimeMinutes: 4,
          tags: ['github', 'copilot', 'devops'],
        ),
        const TechNews(
          id: 402,
          title: 'Panduan Praktis Optimasi CI/CD dengan GitHub Actions Matrix',
          description:
              'Trik mempercepat build pipeline dan menghemat runner minutes pada repositori skala besar.',
          url: 'https://github.blog',
          authorName: 'DevOps Pulse',
          coverImage: null,
          authorAvatar: null,
          publishedDate: 'Kemarin',
          readingTimeMinutes: 6,
          tags: ['github', 'actions', 'ci'],
        ),
      ];
    } else if (tag == 'webdev') {
      return [
        const TechNews(
          id: 601,
          title: 'Arsitektur Mobile Modern: Flutter 3 & Performa Rendah Latensi',
          description:
              'Bagaimana engine Impeller membawa rendering grafis 60/120 FPS bebas jank ke miliaran perangkat.',
          url: 'https://flutter.dev',
          coverImage: null,
          authorName: 'Mobile Architect',
          authorAvatar: null,
          publishedDate: 'Hari ini',
          readingTimeMinutes: 5,
          tags: ['webdev', 'mobile', 'flutter'],
        ),
        const TechNews(
          id: 602,
          title: 'Tren Frontend 2026: Kompilator Reaktif Tanpa Virtual DOM',
          description:
              'Eksplorasi efisiensi komputasi browser terkini dan optimasi bundle web berukuran mikro.',
          url: 'https://dev.to',
          coverImage: null,
          authorName: 'Web Digest',
          authorAvatar: null,
          publishedDate: 'Kemarin',
          readingTimeMinutes: 6,
          tags: ['webdev', 'frontend', 'javascript'],
        ),
      ];
    } else if (tag == 'opensource') {
      return [
        const TechNews(
          id: 101,
          title: 'Tren Open Source 2026: Proyek AI Mandiri Kian Mendominasi',
          description:
              'Komunitas pengembang global beralih ke model dan tooling open-source dengan dukungan komunitas yang kuat.',
          url: 'https://github.com/trending',
          coverImage: null,
          authorName: 'GitPulse Tech Digest',
          authorAvatar: null,
          publishedDate: 'Hari ini',
          readingTimeMinutes: 4,
          tags: ['opensource', 'github', 'tools'],
        ),
        const TechNews(
          id: 102,
          title: 'Framework Frontend & Mobile Generasi Baru yang Mengubah Industri',
          description:
              'Evolusi rendering engine mutakhir membawa efisiensi memori dan waktu load ke tingkat berikutnya.',
          url: 'https://flutter.dev',
          coverImage: null,
          authorName: 'Developer Hub',
          authorAvatar: null,
          publishedDate: 'Kemarin',
          readingTimeMinutes: 5,
          tags: ['opensource', 'mobile', 'flutter'],
        ),
      ];
    } else if (tag == 'technology') {
      return [
        const TechNews(
          id: 201,
          title: 'Arsitektur Komputasi Edge & Cloud: Menghadapi Kebutuhan AI Skala Besar',
          description:
              'Infrastruktur cloud modern beradaptasi dengan beban kerja inferensi model bahasa berkecepatan tinggi.',
          url: 'https://news.ycombinator.com',
          coverImage: null,
          authorName: 'Cloud Engineering',
          authorAvatar: null,
          publishedDate: 'Hari ini',
          readingTimeMinutes: 6,
          tags: ['technology', 'cloud', 'infrastructure'],
        ),
        const TechNews(
          id: 202,
          title: 'Praktik Terbaik Keamanan Siber untuk Developer Modern di Era AI',
          description:
              'Strategi mitigasi serangan rantai pasok software dan proteksi kredensial API sensitif.',
          url: 'https://news.ycombinator.com',
          coverImage: null,
          authorName: 'SecOps Daily',
          authorAvatar: null,
          publishedDate: 'Kemarin',
          readingTimeMinutes: 5,
          tags: ['technology', 'security', 'devops'],
        ),
      ];
    } else {
      // Default: AI
      return [
        const TechNews(
          id: 301,
          title: 'Revolusi Agentic AI: Bagaimana AI Mengotomasi Pengembangan Software',
          description:
              'AI kini tidak sekadar menulis kode baris per baris, melainkan mampu merencanakan, mendebug, dan menguji solusi end-to-end.',
          url: 'https://dev.to',
          coverImage: null,
          authorName: 'AI Research Team',
          authorAvatar: null,
          publishedDate: 'Hari ini',
          readingTimeMinutes: 5,
          tags: ['ai', 'agents', 'software'],
        ),
        const TechNews(
          id: 302,
          title: 'Model Bahasa Ringan (SLM) untuk Eksekusi Lokal di Perangkat Mobile',
          description:
              'Kini menjalankan inferensi AI langsung di smartphone tanpa bergantung pada server cloud telah menjadi kenyataan praktis.',
          url: 'https://dev.to',
          coverImage: null,
          authorName: 'Mobile AI Watch',
          authorAvatar: null,
          publishedDate: 'Kemarin',
          readingTimeMinutes: 6,
          tags: ['ai', 'mobile', 'slm'],
        ),
      ];
    }
  }
}
