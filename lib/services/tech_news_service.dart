import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tech_news.dart';

class TechNewsService {
  final http.Client _client;

  TechNewsService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<TechNews>> fetchNews({String tag = 'ai'}) async {
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
          return data.map((json) => TechNews.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {
      // Fallback to curated news if network fails or offline
    }

    return _getFallbackNews(tag);
  }

  List<TechNews> _getFallbackNews(String tag) {
    if (tag == 'opensource') {
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
        const TechNews(
          id: 303,
          title: 'Prompt Injection & Keamanan Model AI: Tantangan Baru Rekayasa Prompt',
          description:
              'Mengenal teknik pertahanan keamanan mutakhir untuk melindungi aplikasi berbasis LLM dari eksploitasi.',
          url: 'https://dev.to',
          coverImage: null,
          authorName: 'Cybersecurity AI',
          authorAvatar: null,
          publishedDate: '2 hari lalu',
          readingTimeMinutes: 7,
          tags: ['ai', 'security', 'llm'],
        ),
      ];
    }
  }
}
