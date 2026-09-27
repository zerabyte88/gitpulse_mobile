import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmarked_user.dart';

class StorageService {
  static const String _keyBookmarks = 'gitpulse_bookmarks';
  static const String _keyBookmarkAvatars = 'gitpulse_bookmark_avatars';
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

  Map<String, String> _getAvatarMap() {
    final raw = _prefs.getString(_keyBookmarkAvatars);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key.toLowerCase(), value.toString()));
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveAvatarMap(Map<String, String> map) async {
    await _prefs.setString(_keyBookmarkAvatars, jsonEncode(map));
  }

  List<BookmarkedUser> getBookmarkedUsers() {
    final usernames = getBookmarks();
    final avatars = _getAvatarMap();
    return usernames.map((username) {
      final clean = username.trim().toLowerCase();
      final avatar = avatars[clean];
      return BookmarkedUser(
        username: username,
        avatarUrl: (avatar != null && avatar.isNotEmpty)
            ? avatar
            : 'https://github.com/$username.png',
      );
    }).toList();
  }

  Future<void> toggleBookmark(String username, {String? avatarUrl}) async {
    final list = getBookmarks();
    final clean = username.trim().toLowerCase();
    final avatars = _getAvatarMap();

    if (list.contains(clean)) {
      list.remove(clean);
      avatars.remove(clean);
    } else {
      list.add(clean);
      final finalAvatar = (avatarUrl != null && avatarUrl.isNotEmpty)
          ? avatarUrl
          : 'https://github.com/$clean.png';
      avatars[clean] = finalAvatar;
    }

    await _prefs.setStringList(_keyBookmarks, list);
    await _saveAvatarMap(avatars);
  }

  Future<void> removeBookmark(String username) async {
    final list = getBookmarks();
    final clean = username.trim().toLowerCase();
    final avatars = _getAvatarMap();

    list.remove(clean);
    avatars.remove(clean);

    await _prefs.setStringList(_keyBookmarks, list);
    await _saveAvatarMap(avatars);
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

  Future<void> removeRecentSearch(String username) async {
    final clean = username.trim();
    final list = getRecentSearches();
    list.removeWhere((item) => item.toLowerCase() == clean.toLowerCase());
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
