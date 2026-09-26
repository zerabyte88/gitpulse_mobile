import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyBookmarks = 'gitpulse_bookmarks';
  static const String _keyHistory = 'gitpulse_recent_searches';
  static const String _keyToken = 'gitpulse_github_token';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Bookmarks
  List<String> getBookmarks() {
    return _prefs.getStringList(_keyBookmarks) ?? [];
  }

  Future<void> toggleBookmark(String username) async {
    final list = getBookmarks();
    final clean = username.trim().toLowerCase();
    if (list.contains(clean)) {
      list.remove(clean);
    } else {
      list.add(clean);
    }
    await _prefs.setStringList(_keyBookmarks, list);
  }

  bool isBookmarked(String username) {
    final list = getBookmarks();
    return list.contains(username.trim().toLowerCase());
  }

  // Recent History
  List<String> getRecentSearches() {
    return _prefs.getStringList(_keyHistory) ?? [];
  }

  Future<void> addRecentSearch(String username) async {
    final clean = username.trim();
    if (clean.isEmpty) return;

    final list = getRecentSearches();
    list.removeWhere((item) => item.toLowerCase() == clean.toLowerCase());
    list.insert(0, clean);

    // Keep max 10
    if (list.length > 10) {
      list.removeRange(10, list.length);
    }
    await _prefs.setStringList(_keyHistory, list);
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_keyHistory);
  }

  // Token
  String? getToken() {
    return _prefs.getString(_keyToken);
  }

  Future<void> setToken(String? token) async {
    if (token == null || token.trim().isEmpty) {
      await _prefs.remove(_keyToken);
    } else {
      await _prefs.setString(_keyToken, token.trim());
    }
  }
}
