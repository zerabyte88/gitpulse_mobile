import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_language.dart';

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static AppLocalizations? _current;

  static AppLocalizations get current {
    _current ??= AppLocalizations(AppLanguage.indonesian);
    return _current!;
  }

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return localizations ?? current;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Helper string map lookup
  String _str(Map<AppLanguage, String> map) => map[language] ?? map[AppLanguage.indonesian] ?? '';

  // App & General
  String get appTitle => 'GitPulse';
  String get appSubtitle => _str({
    AppLanguage.indonesian: 'Lacak Aktivitas & Statistik GitHub',
    AppLanguage.english: 'Track GitHub Activity & Statistics',
    AppLanguage.japanese: 'GitHubのアクティビティと統計を追跡',
    AppLanguage.chineseSimplified: '追踪 GitHub 活动与统计数据',
    AppLanguage.chineseTraditional: '追蹤 GitHub 活動與統計數據',
    AppLanguage.korean: 'GitHub 활동 및 통계 추적',
  });

  String get close => _str({
    AppLanguage.indonesian: 'Tutup',
    AppLanguage.english: 'Close',
    AppLanguage.japanese: '閉じる',
    AppLanguage.chineseSimplified: '关闭',
    AppLanguage.chineseTraditional: '關閉',
    AppLanguage.korean: '닫기',
  });

  String get cancel => _str({
    AppLanguage.indonesian: 'Batal',
    AppLanguage.english: 'Cancel',
    AppLanguage.japanese: 'キャンセル',
    AppLanguage.chineseSimplified: '取消',
    AppLanguage.chineseTraditional: '取消',
    AppLanguage.korean: '취소',
  });

  String get save => _str({
    AppLanguage.indonesian: 'Simpan',
    AppLanguage.english: 'Save',
    AppLanguage.japanese: '保存',
    AppLanguage.chineseSimplified: '保存',
    AppLanguage.chineseTraditional: '儲存',
    AppLanguage.korean: '저장',
  });

  String get refresh => _str({
    AppLanguage.indonesian: 'Refresh',
    AppLanguage.english: 'Refresh',
    AppLanguage.japanese: '更新',
    AppLanguage.chineseSimplified: '刷新',
    AppLanguage.chineseTraditional: '重新整理',
    AppLanguage.korean: '새로고침',
  });

  String get retry => _str({
    AppLanguage.indonesian: 'Coba Lagi',
    AppLanguage.english: 'Try Again',
    AppLanguage.japanese: '再試行',
    AppLanguage.chineseSimplified: '重试',
    AppLanguage.chineseTraditional: '重試',
    AppLanguage.korean: '다시 시도',
  });

  String get openInGithub => _str({
    AppLanguage.indonesian: 'Buka di GitHub',
    AppLanguage.english: 'Open in GitHub',
    AppLanguage.japanese: 'GitHubで開く',
    AppLanguage.chineseSimplified: '在 GitHub 打开',
    AppLanguage.chineseTraditional: '在 GitHub 開啟',
    AppLanguage.korean: 'GitHub에서 열기',
  });

  // App Version & About Info
  String get aboutApp => _str({
    AppLanguage.indonesian: 'Tentang GitPulse',
    AppLanguage.english: 'About GitPulse',
    AppLanguage.japanese: 'GitPulseについて',
    AppLanguage.chineseSimplified: '关于 GitPulse',
    AppLanguage.chineseTraditional: '關於 GitPulse',
    AppLanguage.korean: 'GitPulse 정보',
  });

  String get appVersionLabel => _str({
    AppLanguage.indonesian: 'Versi Aplikasi',
    AppLanguage.english: 'App Version',
    AppLanguage.japanese: 'アプリバージョン',
    AppLanguage.chineseSimplified: '应用版本',
    AppLanguage.chineseTraditional: '應用版本',
    AppLanguage.korean: '앱 버전',
  });

  String get buildNumberLabel => _str({
    AppLanguage.indonesian: 'Build',
    AppLanguage.english: 'Build',
    AppLanguage.japanese: 'ビルド',
    AppLanguage.chineseSimplified: '构建号',
    AppLanguage.chineseTraditional: '構建號',
    AppLanguage.korean: '빌드',
  });

  String get appDescriptionLabel => _str({
    AppLanguage.indonesian: 'Telemetri & Analitik Produktivitas Pengembang',
    AppLanguage.english: 'Developer Telemetry & Productivity Analytics',
    AppLanguage.japanese: '開発者テレメトリと生産性分析',
    AppLanguage.chineseSimplified: '开发者遥测与生产力分析',
    AppLanguage.chineseTraditional: '開發者遙測與生產力分析',
    AppLanguage.korean: '개발자 텔레메트리 및 생산성 분석',
  });

  String get viewOnGitHub => _str({
    AppLanguage.indonesian: 'Lihat Repositori di GitHub',
    AppLanguage.english: 'View Repository on GitHub',
    AppLanguage.japanese: 'GitHubでリポジトリを表示',
    AppLanguage.chineseSimplified: '在 GitHub 查看代码仓库',
    AppLanguage.chineseTraditional: '在 GitHub 查看代碼倉庫',
    AppLanguage.korean: 'GitHub에서 저장소 보기',
  });

  // Search & Home
  String get searchHint => _str({
    AppLanguage.indonesian: 'Cari username GitHub... (contoh: torvalds)',
    AppLanguage.english: 'Search GitHub username... (e.g. torvalds)',
    AppLanguage.japanese: 'GitHubユーザー名を検索... (例: torvalds)',
    AppLanguage.chineseSimplified: '搜索 GitHub 用户名... (例如: torvalds)',
    AppLanguage.chineseTraditional: '搜尋 GitHub 使用者名稱... (例如: torvalds)',
    AppLanguage.korean: 'GitHub 사용자 이름 검색... (예: torvalds)',
  });

  String get recentSearches => _str({
    AppLanguage.indonesian: 'Pencarian Terakhir',
    AppLanguage.english: 'Recent Searches',
    AppLanguage.japanese: '最近の検索',
    AppLanguage.chineseSimplified: '最近搜索',
    AppLanguage.chineseTraditional: '最近搜尋',
    AppLanguage.korean: '최근 검색',
  });

  String get clearAll => _str({
    AppLanguage.indonesian: 'Hapus Semua',
    AppLanguage.english: 'Clear All',
    AppLanguage.japanese: 'すべて削除',
    AppLanguage.chineseSimplified: '清除全部',
    AppLanguage.chineseTraditional: '清除全部',
    AppLanguage.korean: '모두 지우기',
  });

  String get noRecentSearches => _str({
    AppLanguage.indonesian: 'Belum ada riwayat pencarian',
    AppLanguage.english: 'No recent searches',
    AppLanguage.japanese: '検索履歴がありません',
    AppLanguage.chineseSimplified: '暂无搜索历史',
    AppLanguage.chineseTraditional: '暫無搜尋紀錄',
    AppLanguage.korean: '최근 검색 기록이 없습니다',
  });

  String get favoriteProfiles => _str({
    AppLanguage.indonesian: 'Profil Favorit',
    AppLanguage.english: 'Favorite Profiles',
    AppLanguage.japanese: 'お気に入りプロフィール',
    AppLanguage.chineseSimplified: '收藏个人资料',
    AppLanguage.chineseTraditional: '收藏個人檔案',
    AppLanguage.korean: '즐겨찾는 프로필',
  });

  String get saved => _str({
    AppLanguage.indonesian: 'Disimpan',
    AppLanguage.english: 'Saved',
    AppLanguage.japanese: '保存済み',
    AppLanguage.chineseSimplified: '已保存',
    AppLanguage.chineseTraditional: '已儲存',
    AppLanguage.korean: '저장됨',
  });

  String get emptyBookmarks => _str({
    AppLanguage.indonesian: 'Belum ada profil yang disimpan. Cari user dan tekan ikon bookmark untuk menyimpannya di sini!',
    AppLanguage.english: 'No saved profiles yet. Search for a user and tap the bookmark icon to save them here!',
    AppLanguage.japanese: '保存されたプロフィールはありません。ユーザーを検索し、ブックマークアイコンをタップして保存してください！',
    AppLanguage.chineseSimplified: '暂无保存的个人资料。搜索用户并点击书签图标以保存到此处！',
    AppLanguage.chineseTraditional: '暫無儲存的個人檔案。搜尋使用者並點擊書籤圖示即可儲存於此！',
    AppLanguage.korean: '저장된 프로필이 없습니다. 사용자를 검색하고 북마크 아이콘을 눌러 저장해 보세요!',
  });

  String get userNotFound => _str({
    AppLanguage.indonesian: 'User tidak ditemukan',
    AppLanguage.english: 'User not found',
    AppLanguage.japanese: 'ユーザーが見つかりません',
    AppLanguage.chineseSimplified: '未找到该用户',
    AppLanguage.chineseTraditional: '找不到該使用者',
    AppLanguage.korean: '사용자를 찾을 수 없습니다',
  });

  String get networkError => _str({
    AppLanguage.indonesian: 'Gagal memuat data. Periksa koneksi internet Anda.',
    AppLanguage.english: 'Failed to load data. Please check your internet connection.',
    AppLanguage.japanese: 'データを読み込めませんでした。インターネット接続を確認してください。',
    AppLanguage.chineseSimplified: '加载数据失败，请检查网络连接。',
    AppLanguage.chineseTraditional: '載入資料失敗，請檢查網路連線。',
    AppLanguage.korean: '데이터를 불러오지 못했습니다. 인터넷 연결을 확인해 주세요.',
  });

  String get rateLimitExceeded => _str({
    AppLanguage.indonesian: 'Rate limit terlampaui. Tambahkan token GitHub di pengaturan.',
    AppLanguage.english: 'Rate limit exceeded. Add a GitHub token in settings.',
    AppLanguage.japanese: 'レート制限を超過しました。設定でGitHubトークンを追加してください。',
    AppLanguage.chineseSimplified: '超出请求速率限制。请在设置中添加 GitHub Token。',
    AppLanguage.chineseTraditional: '超出請求速率限制。請在設定中新增 GitHub Token。',
    AppLanguage.korean: 'API 요청 한도를 초과했습니다. 설정에서 GitHub 토큰을 추가해 주세요.',
  });

  // Tech News
  String get techNewsTitle => _str({
    AppLanguage.indonesian: 'Berita AI & Teknologi',
    AppLanguage.english: 'AI & Tech News',
    AppLanguage.japanese: 'AI＆テクノロジーニュース',
    AppLanguage.chineseSimplified: 'AI 与科技资讯',
    AppLanguage.chineseTraditional: 'AI 與科技資訊',
    AppLanguage.korean: 'AI 및 기술 뉴스',
  });

  String get techNewsSubtitle => _str({
    AppLanguage.indonesian: 'Update tren teknologi global terkini',
    AppLanguage.english: 'Latest global technology trend updates',
    AppLanguage.japanese: '最新のグローバル技術トレンド情報',
    AppLanguage.chineseSimplified: '全球最新技术趋势动态',
    AppLanguage.chineseTraditional: '全球最新技術趨勢動態',
    AppLanguage.korean: '최신 글로벌 기술 트렌드 업데이트',
  });

  String get categoryAi => _str({
    AppLanguage.indonesian: 'AI & Machine Learning',
    AppLanguage.english: 'AI & Machine Learning',
    AppLanguage.japanese: 'AI＆機械学習',
    AppLanguage.chineseSimplified: '人工智能与机器学习',
    AppLanguage.chineseTraditional: '人工智能與機器學習',
    AppLanguage.korean: 'AI 및 머신러닝',
  });

  String get categoryTech => _str({
    AppLanguage.indonesian: 'Teknologi & IT',
    AppLanguage.english: 'Technology & IT',
    AppLanguage.japanese: 'テクノロジー＆IT',
    AppLanguage.chineseSimplified: '科技与IT',
    AppLanguage.chineseTraditional: '科技與IT',
    AppLanguage.korean: '기술 및 IT',
  });

  String get categoryOpenSource => _str({
    AppLanguage.indonesian: 'Open Source',
    AppLanguage.english: 'Open Source',
    AppLanguage.japanese: 'オープンソース',
    AppLanguage.chineseSimplified: '开源社区',
    AppLanguage.chineseTraditional: '開源社群',
    AppLanguage.korean: '오픈소스',
  });

  String get loadingNews => _str({
    AppLanguage.indonesian: 'Memuat berita terbaru...',
    AppLanguage.english: 'Loading latest news...',
    AppLanguage.japanese: '最新ニュースを読み込み中...',
    AppLanguage.chineseSimplified: '正在加载最新资讯...',
    AppLanguage.chineseTraditional: '正在載入最新資訊...',
    AppLanguage.korean: '최신 뉴스를 불러오는 중...',
  });

  String get noNewsFound => _str({
    AppLanguage.indonesian: 'Tidak ada berita ditemukan',
    AppLanguage.english: 'No news found',
    AppLanguage.japanese: 'ニュースが見つかりませんでした',
    AppLanguage.chineseSimplified: '未找到相关资讯',
    AppLanguage.chineseTraditional: '未找到相關資訊',
    AppLanguage.korean: '뉴스를 찾을 수 없습니다',
  });

  String get readMore => _str({
    AppLanguage.indonesian: 'Baca Selengkapnya',
    AppLanguage.english: 'Read More',
    AppLanguage.japanese: '続きを読む',
    AppLanguage.chineseSimplified: '阅读全文',
    AppLanguage.chineseTraditional: '閱讀全文',
    AppLanguage.korean: '자세히 보기',
  });

  String get minRead => _str({
    AppLanguage.indonesian: 'mnt baca',
    AppLanguage.english: 'min read',
    AppLanguage.japanese: '分で読める',
    AppLanguage.chineseSimplified: '分钟阅读',
    AppLanguage.chineseTraditional: '分鐘閱讀',
    AppLanguage.korean: '분 분량',
  });

  // Settings & Language
  String get settingsTitle => _str({
    AppLanguage.indonesian: 'Pengaturan & Kuota API',
    AppLanguage.english: 'Settings & API Quota',
    AppLanguage.japanese: '設定＆APIクォータ',
    AppLanguage.chineseSimplified: '设置与 API 配额',
    AppLanguage.chineseTraditional: '設定與 API 配額',
    AppLanguage.korean: '설정 및 API 할당량',
  });

  String get settingsSubtitle => _str({
    AppLanguage.indonesian: 'Kelola bahasa, kuota API & token',
    AppLanguage.english: 'Manage language, API quota & token',
    AppLanguage.japanese: '言語、APIクォータ、トークンを管理',
    AppLanguage.chineseSimplified: '管理语言、API 配额与 Token',
    AppLanguage.chineseTraditional: '管理語言、API 配額與 Token',
    AppLanguage.korean: '언어, API 할당량 및 토큰 관리',
  });

  String get languageSectionTitle => _str({
    AppLanguage.indonesian: 'Bahasa Aplikasi',
    AppLanguage.english: 'App Language',
    AppLanguage.japanese: 'アプリの言語',
    AppLanguage.chineseSimplified: '应用语言',
    AppLanguage.chineseTraditional: '應用程式語言',
    AppLanguage.korean: '앱 언어',
  });

  String get languageSectionSubtitle => _str({
    AppLanguage.indonesian: 'Pilih bahasa tampilan (aktif langsung tanpa restart)',
    AppLanguage.english: 'Select display language (applies instantly without restart)',
    AppLanguage.japanese: '表示言語を選択（再起動不要で即時適用）',
    AppLanguage.chineseSimplified: '选择显示语言（立即生效，无需重启）',
    AppLanguage.chineseTraditional: '選擇顯示語言（立即生效，無需重啟）',
    AppLanguage.korean: '표시 언어 선택 (앱 재시작 없이 즉시 적용)',
  });

  String get languageChangedToast => _str({
    AppLanguage.indonesian: 'Bahasa berhasil diubah ke',
    AppLanguage.english: 'Language changed to',
    AppLanguage.japanese: '言語を変更しました: ',
    AppLanguage.chineseSimplified: '语言已切换为: ',
    AppLanguage.chineseTraditional: '語言已切換為: ',
    AppLanguage.korean: '언어가 다음으로 변경되었습니다: ',
  });

  // API Rate Limit
  String get rateLimitStatus => _str({
    AppLanguage.indonesian: 'Status Kuota API GitHub',
    AppLanguage.english: 'GitHub API Quota Status',
    AppLanguage.japanese: 'GitHub API クォータ状態',
    AppLanguage.chineseSimplified: 'GitHub API 配额状态',
    AppLanguage.chineseTraditional: 'GitHub API 配額狀態',
    AppLanguage.korean: 'GitHub API 할당량 상태',
  });

  String get personalTokenActive => _str({
    AppLanguage.indonesian: 'Personal Token Aktif (Maks 5.000 req/jam)',
    AppLanguage.english: 'Personal Token Active (Max 5,000 req/hr)',
    AppLanguage.japanese: '個人トークン有効 (最大 5,000 req/時)',
    AppLanguage.chineseSimplified: 'Personal Token 已激活 (最高 5,000 请求/小时)',
    AppLanguage.chineseTraditional: 'Personal Token 已啟用 (最高 5,000 請求/小時)',
    AppLanguage.korean: '개인 토큰 활성화 (최대 5,000회/시간)',
  });

  String get standardMode => _str({
    AppLanguage.indonesian: 'Mode Standar (Maks 60 req/jam)',
    AppLanguage.english: 'Standard Mode (Max 60 req/hr)',
    AppLanguage.japanese: '標準モード (最大 60 req/時)',
    AppLanguage.chineseSimplified: '标准模式 (最高 60 请求/小时)',
    AppLanguage.chineseTraditional: '標準模式 (最高 60 請求/小時)',
    AppLanguage.korean: '표준 모드 (최대 60회/시간)',
  });

  String get requestsUsed => _str({
    AppLanguage.indonesian: 'Request Digunakan',
    AppLanguage.english: 'Requests Used',
    AppLanguage.japanese: '使用済みリクエスト',
    AppLanguage.chineseSimplified: '已使用请求',
    AppLanguage.chineseTraditional: '已使用請求',
    AppLanguage.korean: '사용된 요청',
  });

  String get remainingQuota => _str({
    AppLanguage.indonesian: 'Sisa Kuota',
    AppLanguage.english: 'Remaining Quota',
    AppLanguage.japanese: '残りクォータ',
    AppLanguage.chineseSimplified: '剩余配额',
    AppLanguage.chineseTraditional: '剩餘配額',
    AppLanguage.korean: '남은 할당량',
  });

  String get resetIn => _str({
    AppLanguage.indonesian: 'Reset dalam',
    AppLanguage.english: 'Resets in',
    AppLanguage.japanese: 'リセットまで',
    AppLanguage.chineseSimplified: '重置倒计时',
    AppLanguage.chineseTraditional: '重設倒數',
    AppLanguage.korean: '재설정까지',
  });

  String get resetting => _str({
    AppLanguage.indonesian: 'Sedang mereset...',
    AppLanguage.english: 'Resetting...',
    AppLanguage.japanese: 'リセット中...',
    AppLanguage.chineseSimplified: '正在重置...',
    AppLanguage.chineseTraditional: '正在重設...',
    AppLanguage.korean: '재설정 중...',
  });

  // Token Section
  String get githubTokenTitle => 'GitHub Personal Token';
  String get optionalBadge => _str({
    AppLanguage.indonesian: 'Opsional',
    AppLanguage.english: 'Optional',
    AppLanguage.japanese: '任意',
    AppLanguage.chineseSimplified: '可选',
    AppLanguage.chineseTraditional: '可選',
    AppLanguage.korean: '선택',
  });

  String get tokenDescription => _str({
    AppLanguage.indonesian: 'Tambahkan token GitHub untuk menaikkan kuota dari 60 menjadi 5.000 request per jam.',
    AppLanguage.english: 'Add a GitHub token to increase your quota from 60 to 5,000 requests per hour.',
    AppLanguage.japanese: 'GitHubトークンを追加すると、クォータが毎時60件から5,000件に増加します。',
    AppLanguage.chineseSimplified: '添加 GitHub Token 可将每小时请求配额从 60 次提升至 5,000 次。',
    AppLanguage.chineseTraditional: '新增 GitHub Token 可將每小時請求配額從 60 次提升至 5,000 次。',
    AppLanguage.korean: 'GitHub 토큰을 추가하면 시간당 요청 한도가 60회에서 5,000회로 늘어납니다.',
  });

  String get tokenHint => 'ghp_xxxxxxxxxxxx / github_pat_...';

  String get howToCreateToken => _str({
    AppLanguage.indonesian: 'Cara membuat GitHub Token',
    AppLanguage.english: 'How to create a GitHub Token',
    AppLanguage.japanese: 'GitHubトークンの作成方法',
    AppLanguage.chineseSimplified: '如何生成 GitHub Token',
    AppLanguage.chineseTraditional: '如何建立 GitHub Token',
    AppLanguage.korean: 'GitHub 토큰 생성 방법',
  });

  String get tokenGuideContent => _str({
    AppLanguage.indonesian:
        '1. Buka github.com > Profil > Settings.\n'
        '2. Gulir ke bawah ke Developer Settings.\n'
        '3. Pilih Personal Access Tokens (Classic).\n'
        '4. Generate new token (tanpa perlu centang izin khusus).\n'
        '5. Salin token lalu tempelkan di atas.',
    AppLanguage.english:
        '1. Open github.com > Profile > Settings.\n'
        '2. Scroll down to Developer Settings.\n'
        '3. Select Personal Access Tokens (Classic).\n'
        '4. Generate new token (no special permissions required).\n'
        '5. Copy token and paste it above.',
    AppLanguage.japanese:
        '1. github.com を開く > プロフィール > Settings。\n'
        '2. ページ下部の Developer Settings へ移動。\n'
        '3. Personal Access Tokens (Classic) を選択。\n'
        '4. Generate new token（特別な権限は不要です）。\n'
        '5. トークンをコピーして上記に入力。',
    AppLanguage.chineseSimplified:
        '1. 打开 github.com > 个人资料 > Settings。\n'
        '2. 向下滚动至 Developer Settings。\n'
        '3. 选择 Personal Access Tokens (Classic)。\n'
        '4. Generate new token（无需勾选任何特殊权限）。\n'
        '5. 复制 Token 并粘贴至上方输入框。',
    AppLanguage.chineseTraditional:
        '1. 開啟 github.com > 個人檔案 > Settings。\n'
        '2. 向下捲動至 Developer Settings。\n'
        '3. 選擇 Personal Access Tokens (Classic)。\n'
        '4. Generate new token（無需勾選任何特殊權限）。\n'
        '5. 複製 Token 並貼在上方輸入框。',
    AppLanguage.korean:
        '1. github.com 접속 > 프로필 > Settings.\n'
        '2. 아래로 스크롤하여 Developer Settings 선택.\n'
        '3. Personal Access Tokens (Classic) 선택.\n'
        '4. Generate new token 생성 (특수 권한 체크 불필요).\n'
        '5. 생성된 토큰을 복사하여 위에 붙여넣기.',
  });

  String get deleteToken => _str({
    AppLanguage.indonesian: 'Hapus Token',
    AppLanguage.english: 'Delete Token',
    AppLanguage.japanese: 'トークン削除',
    AppLanguage.chineseSimplified: '删除 Token',
    AppLanguage.chineseTraditional: '刪除 Token',
    AppLanguage.korean: '토큰 삭제',
  });

  String get saveToken => _str({
    AppLanguage.indonesian: 'Simpan Token',
    AppLanguage.english: 'Save Token',
    AppLanguage.japanese: 'トークン保存',
    AppLanguage.chineseSimplified: '保存 Token',
    AppLanguage.chineseTraditional: '儲存 Token',
    AppLanguage.korean: '토큰 저장',
  });

  String get tokenSavedToast => _str({
    AppLanguage.indonesian: 'Token disimpan! Kuota berhasil ditingkatkan ke 5.000 req/jam.',
    AppLanguage.english: 'Token saved! Quota increased to 5,000 req/hr.',
    AppLanguage.japanese: 'トークンを保存しました！クォータが 5,000 req/時に増量されました。',
    AppLanguage.chineseSimplified: 'Token 已保存！配额已提升至 5,000 请求/小时。',
    AppLanguage.chineseTraditional: 'Token 已儲存！配額已提升至 5,000 請求/小時。',
    AppLanguage.korean: '토큰이 저장되었습니다! 할당량이 시간당 5,000회로 증가했습니다.',
  });

  String get tokenDeletedToast => _str({
    AppLanguage.indonesian: 'Token dihapus. Kembali ke kuota standar 60 req/jam.',
    AppLanguage.english: 'Token removed. Returned to standard 60 req/hr quota.',
    AppLanguage.japanese: 'トークンを削除しました。標準の 60 req/時に戻りました。',
    AppLanguage.chineseSimplified: 'Token 已删除，恢复为标准 60 请求/小时配额。',
    AppLanguage.chineseTraditional: 'Token 已刪除，恢復為標準 60 請求/小時配額。',
    AppLanguage.korean: '토큰이 삭제되었습니다. 표준 60회/시간으로 복원되었습니다.',
  });

  // Stats Detail Screen
  String get statsDetailTitle => _str({
    AppLanguage.indonesian: 'Statistik GitHub',
    AppLanguage.english: 'GitHub Statistics',
    AppLanguage.japanese: 'GitHub 統計',
    AppLanguage.chineseSimplified: 'GitHub 统计',
    AppLanguage.chineseTraditional: 'GitHub 統計',
    AppLanguage.korean: 'GitHub 통계',
  });

  String get joinedSince => _str({
    AppLanguage.indonesian: 'Bergabung sejak',
    AppLanguage.english: 'Joined',
    AppLanguage.japanese: '登録日',
    AppLanguage.chineseSimplified: '注册于',
    AppLanguage.chineseTraditional: '註冊於',
    AppLanguage.korean: '가입일',
  });

  String get noBio => _str({
    AppLanguage.indonesian: 'Bio tidak tersedia.',
    AppLanguage.english: 'Bio not available.',
    AppLanguage.japanese: 'バイオグラフィはありません。',
    AppLanguage.chineseSimplified: '暂无个人简介。',
    AppLanguage.chineseTraditional: '暫無個人簡介。',
    AppLanguage.korean: '소개가 없습니다.',
  });

  String get noLocation => _str({
    AppLanguage.indonesian: 'Lokasi tidak dicantumkan',
    AppLanguage.english: 'Location not specified',
    AppLanguage.japanese: '場所未設定',
    AppLanguage.chineseSimplified: '未提供位置',
    AppLanguage.chineseTraditional: '未提供位置',
    AppLanguage.korean: '위치 미지정',
  });

  String get totalRepos => _str({
    AppLanguage.indonesian: 'Total Repositori',
    AppLanguage.english: 'Total Repositories',
    AppLanguage.japanese: '総リポジトリ数',
    AppLanguage.chineseSimplified: '仓库总数',
    AppLanguage.chineseTraditional: '倉庫總數',
    AppLanguage.korean: '총 리포지토리',
  });

  String get publicRepos => _str({
    AppLanguage.indonesian: 'Repo Publik',
    AppLanguage.english: 'Public Repos',
    AppLanguage.japanese: '公開リポジトリ',
    AppLanguage.chineseSimplified: '公开仓库',
    AppLanguage.chineseTraditional: '公開倉庫',
    AppLanguage.korean: '공개 리포지토리',
  });

  String get totalStars => _str({
    AppLanguage.indonesian: 'Total Bintang',
    AppLanguage.english: 'Total Stars',
    AppLanguage.japanese: '総スター数',
    AppLanguage.chineseSimplified: '获得的 Star',
    AppLanguage.chineseTraditional: '獲取的 Star',
    AppLanguage.korean: '총 스타',
  });

  String get starsEarned => _str({
    AppLanguage.indonesian: 'Bintang yang Didapat',
    AppLanguage.english: 'Stars Earned',
    AppLanguage.japanese: '獲得したスター',
    AppLanguage.chineseSimplified: '获得的 Star 数',
    AppLanguage.chineseTraditional: '獲得的 Star 數',
    AppLanguage.korean: '획득한 스타',
  });

  String get totalForks => _str({
    AppLanguage.indonesian: 'Total Fork',
    AppLanguage.english: 'Total Forks',
    AppLanguage.japanese: '総フォーク数',
    AppLanguage.chineseSimplified: 'Fork 总数',
    AppLanguage.chineseTraditional: 'Fork 總數',
    AppLanguage.korean: '총 포크',
  });

  String get forksInRepos => _str({
    AppLanguage.indonesian: 'Fork di Repositori',
    AppLanguage.english: 'Forks across Repos',
    AppLanguage.japanese: 'リポジトリのフォーク',
    AppLanguage.chineseSimplified: '仓库被 Fork 数',
    AppLanguage.chineseTraditional: '倉庫被 Fork 數',
    AppLanguage.korean: '리포지토리 포크',
  });

  String get followers => _str({
    AppLanguage.indonesian: 'Pengikut',
    AppLanguage.english: 'Followers',
    AppLanguage.japanese: 'フォロワー',
    AppLanguage.chineseSimplified: '关注者',
    AppLanguage.chineseTraditional: '粉絲',
    AppLanguage.korean: '팔로워',
  });

  String get following => _str({
    AppLanguage.indonesian: 'Mengikuti',
    AppLanguage.english: 'Following',
    AppLanguage.japanese: 'フォロー中',
    AppLanguage.chineseSimplified: '正在关注',
    AppLanguage.chineseTraditional: '追蹤中',
    AppLanguage.korean: '팔로잉',
  });

  String get commitHabitTitle => _str({
    AppLanguage.indonesian: 'Tingkat Aktivitas Commit',
    AppLanguage.english: 'Commit Habit Activity Tier',
    AppLanguage.japanese: 'コミット活動レベル',
    AppLanguage.chineseSimplified: '提交活跃度等级',
    AppLanguage.chineseTraditional: '提交活躍度等級',
    AppLanguage.korean: '커밋 활동 등급',
  });

  String get streakStatsTitle => _str({
    AppLanguage.indonesian: 'Statistik Kontribusi & Streak',
    AppLanguage.english: 'Contribution & Streak Statistics',
    AppLanguage.japanese: '貢献＆ストリーク統計',
    AppLanguage.chineseSimplified: '贡献与连胜统计',
    AppLanguage.chineseTraditional: '貢獻與連續統計',
    AppLanguage.korean: '기여 및 스트릭 통계',
  });

  String get currentStreak => _str({
    AppLanguage.indonesian: 'Streak Saat Ini',
    AppLanguage.english: 'Current Streak',
    AppLanguage.japanese: '現在のストリーク',
    AppLanguage.chineseSimplified: '当前连续提交',
    AppLanguage.chineseTraditional: '目前連續提交',
    AppLanguage.korean: '현재 연속 커밋',
  });

  String get longestStreak => _str({
    AppLanguage.indonesian: 'Streak Terpanjang',
    AppLanguage.english: 'Longest Streak',
    AppLanguage.japanese: '最長ストリーク',
    AppLanguage.chineseSimplified: '最长连续提交',
    AppLanguage.chineseTraditional: '最長連續提交',
    AppLanguage.korean: '최장 연속 커밋',
  });

  String get thisYearContributions => _str({
    AppLanguage.indonesian: 'Kontribusi Tahun Ini',
    AppLanguage.english: 'This Year Contributions',
    AppLanguage.japanese: '今年の貢献数',
    AppLanguage.chineseSimplified: '今年贡献次数',
    AppLanguage.chineseTraditional: '今年貢獻次數',
    AppLanguage.korean: '올해 기여',
  });

  String get totalContributions => _str({
    AppLanguage.indonesian: 'Total Kontribusi',
    AppLanguage.english: 'Total Contributions',
    AppLanguage.japanese: '総貢献数',
    AppLanguage.chineseSimplified: '总贡献次数',
    AppLanguage.chineseTraditional: '總貢獻次數',
    AppLanguage.korean: '총 기여',
  });

  String get allYearsContributions => _str({
    AppLanguage.indonesian: 'Total Kontribusi (Semua Tahun)',
    AppLanguage.english: 'Total Contributions (All Years)',
    AppLanguage.japanese: '総貢献数 (全期間)',
    AppLanguage.chineseSimplified: '总贡献次数 (所有年份)',
    AppLanguage.chineseTraditional: '總貢獻次數 (所有年份)',
    AppLanguage.korean: '총 기여 (전체 연도)',
  });

  String get daysUnit => _str({
    AppLanguage.indonesian: 'hari',
    AppLanguage.english: 'days',
    AppLanguage.japanese: '日',
    AppLanguage.chineseSimplified: '天',
    AppLanguage.chineseTraditional: '天',
    AppLanguage.korean: '일',
  });

  String get contributionsUnit => _str({
    AppLanguage.indonesian: 'kontribusi',
    AppLanguage.english: 'contributions',
    AppLanguage.japanese: '回貢献',
    AppLanguage.chineseSimplified: '次贡献',
    AppLanguage.chineseTraditional: '次貢獻',
    AppLanguage.korean: '회 기여',
  });

  String get topLanguagesTitle => _str({
    AppLanguage.indonesian: 'Bahasa Pemrograman Terbanyak',
    AppLanguage.english: 'Top Programming Languages',
    AppLanguage.japanese: '主要プログラミング言語',
    AppLanguage.chineseSimplified: '主要编程语言',
    AppLanguage.chineseTraditional: '主要程式語言',
    AppLanguage.korean: '주요 프로그래밍 언어',
  });

  String get topLanguagesSubtitle => _str({
    AppLanguage.indonesian: 'Persentase bahasa berdasarkan ukuran kode repositori',
    AppLanguage.english: 'Language percentage based on repository code size',
    AppLanguage.japanese: 'コード容量に基づく言語比率',
    AppLanguage.chineseSimplified: '基于代码大小的语言占比',
    AppLanguage.chineseTraditional: '基於程式碼大小的語言佔比',
    AppLanguage.korean: '코드 용량 기반 언어 비율',
  });

  String get languageDistribution => _str({
    AppLanguage.indonesian: 'Distribusi Bahasa Pemrograman',
    AppLanguage.english: 'Language Distribution',
    AppLanguage.japanese: 'プログラミング言語の分布',
    AppLanguage.chineseSimplified: '编程语言分布',
    AppLanguage.chineseTraditional: '程式語言分佈',
    AppLanguage.korean: '프로그래밍 언어 분포',
  });

  String get otherLanguages => _str({
    AppLanguage.indonesian: 'Lainnya',
    AppLanguage.english: 'Others',
    AppLanguage.japanese: 'その他',
    AppLanguage.chineseSimplified: '其他',
    AppLanguage.chineseTraditional: '其他',
    AppLanguage.korean: '기타',
  });

  String get noLanguageData => _str({
    AppLanguage.indonesian: 'Belum ada data bahasa pemrograman.',
    AppLanguage.english: 'No programming language data available.',
    AppLanguage.japanese: 'プログラミング言語データがありません。',
    AppLanguage.chineseSimplified: '暂无编程语言数据。',
    AppLanguage.chineseTraditional: '暫無程式語言數據。',
    AppLanguage.korean: '프로그래밍 언어 데이터가 없습니다.',
  });

  String get repositoriesTitle => _str({
    AppLanguage.indonesian: 'Repositori',
    AppLanguage.english: 'Repositories',
    AppLanguage.japanese: 'リポジトリ',
    AppLanguage.chineseSimplified: '代码仓库',
    AppLanguage.chineseTraditional: '代碼倉庫',
    AppLanguage.korean: '리포지토리',
  });

  String get totalCountBadge => _str({
    AppLanguage.indonesian: 'total',
    AppLanguage.english: 'total',
    AppLanguage.japanese: '合計',
    AppLanguage.chineseSimplified: '总计',
    AppLanguage.chineseTraditional: '總計',
    AppLanguage.korean: '총',
  });

  String get filterRepositories => _str({
    AppLanguage.indonesian: 'Filter Repositori',
    AppLanguage.english: 'Filter Repositories',
    AppLanguage.japanese: 'リポジトリ絞り込み',
    AppLanguage.chineseSimplified: '筛选仓库',
    AppLanguage.chineseTraditional: '篩選倉庫',
    AppLanguage.korean: '리포지토리 필터',
  });

  String get filterPopular => _str({
    AppLanguage.indonesian: 'Terpopuler',
    AppLanguage.english: 'Most Popular',
    AppLanguage.japanese: '人気順',
    AppLanguage.chineseSimplified: '最受欢迎',
    AppLanguage.chineseTraditional: '最受歡迎',
    AppLanguage.korean: '인기순',
  });

  String get filterPopularDesc => _str({
    AppLanguage.indonesian: 'Bintang & Fork terbanyak',
    AppLanguage.english: 'Most Stars & Forks',
    AppLanguage.japanese: '最多スター＆フォーク',
    AppLanguage.chineseSimplified: '最多 Star 与 Fork',
    AppLanguage.chineseTraditional: '最多 Star 與 Fork',
    AppLanguage.korean: '최다 스타 및 포크',
  });

  String get filterNewest => _str({
    AppLanguage.indonesian: 'Terbaru',
    AppLanguage.english: 'Newest',
    AppLanguage.japanese: '最新順',
    AppLanguage.chineseSimplified: '最新更新',
    AppLanguage.chineseTraditional: '最新更新',
    AppLanguage.korean: '최신순',
  });

  String get filterNewestDesc => _str({
    AppLanguage.indonesian: 'Commit & update paling baru',
    AppLanguage.english: 'Most recently committed & updated',
    AppLanguage.japanese: '最新のコミット＆更新',
    AppLanguage.chineseSimplified: '最新提交与更新',
    AppLanguage.chineseTraditional: '最新提交與更新',
    AppLanguage.korean: '최근 커밋 및 업데이트',
  });

  String get filterOldest => _str({
    AppLanguage.indonesian: 'Terlama',
    AppLanguage.english: 'Oldest',
    AppLanguage.japanese: '古い順',
    AppLanguage.chineseSimplified: '最早活跃',
    AppLanguage.chineseTraditional: '最早活躍',
    AppLanguage.korean: '오래된순',
  });

  String get filterOldestDesc => _str({
    AppLanguage.indonesian: 'Aktivitas commit terlama',
    AppLanguage.english: 'Oldest commit activity',
    AppLanguage.japanese: '最も古いコミット活動',
    AppLanguage.chineseSimplified: '最早提交活动',
    AppLanguage.chineseTraditional: '最早提交活動',
    AppLanguage.korean: '가장 오래된 커밋 활동',
  });

  String get noPublicRepos => _str({
    AppLanguage.indonesian: 'Tidak ada repositori publik.',
    AppLanguage.english: 'No public repositories.',
    AppLanguage.japanese: '公開リポジトリがありません。',
    AppLanguage.chineseSimplified: '没有公开代码仓库。',
    AppLanguage.chineseTraditional: '沒有公開程式碼倉庫。',
    AppLanguage.korean: '공개 리포지토리가 없습니다.',
  });

  String showAllReposCount(int count) => _str({
    AppLanguage.indonesian: 'Tampilkan Semua ($count Repositori)',
    AppLanguage.english: 'Show All ($count Repositories)',
    AppLanguage.japanese: 'すべて表示 ($count 件のリポジトリ)',
    AppLanguage.chineseSimplified: '显示全部 ($count 个仓库)',
    AppLanguage.chineseTraditional: '顯示全部 ($count 個倉庫)',
    AppLanguage.korean: '전체 보기 ($count개 리포지토리)',
  });

  String get showFewerRepos => _str({
    AppLanguage.indonesian: 'Tampilkan Lebih Sedikit',
    AppLanguage.english: 'Show Fewer',
    AppLanguage.japanese: '折りたたむ',
    AppLanguage.chineseSimplified: '收起部分',
    AppLanguage.chineseTraditional: '收起部分',
    AppLanguage.korean: '간략히 보기',
  });

  String get shareProfile => _str({
    AppLanguage.indonesian: 'Bagikan Profil',
    AppLanguage.english: 'Share Profile',
    AppLanguage.japanese: 'プロフィールを共有',
    AppLanguage.chineseSimplified: '分享个人主页',
    AppLanguage.chineseTraditional: '分享個人主頁',
    AppLanguage.korean: '프로필 공유',
  });

  String get saveFavorite => _str({
    AppLanguage.indonesian: 'Simpan ke Favorit',
    AppLanguage.english: 'Save to Favorites',
    AppLanguage.japanese: 'お気に入りに追加',
    AppLanguage.chineseSimplified: '收藏此用户',
    AppLanguage.chineseTraditional: '收藏此使用者',
    AppLanguage.korean: '즐겨찾기에 추가',
  });

  String get removeFavorite => _str({
    AppLanguage.indonesian: 'Hapus dari Favorit',
    AppLanguage.english: 'Remove from Favorites',
    AppLanguage.japanese: 'お気に入りから削除',
    AppLanguage.chineseSimplified: '取消收藏',
    AppLanguage.chineseTraditional: '取消收藏',
    AppLanguage.korean: '즐겨찾기에서 제거',
  });

  String get profileLinkCopied => _str({
    AppLanguage.indonesian: 'Link profil GitHub disalin ke clipboard!',
    AppLanguage.english: 'GitHub profile link copied to clipboard!',
    AppLanguage.japanese: 'プロフィールリンクをコピーしました！',
    AppLanguage.chineseSimplified: 'GitHub 主页链接已复制到剪贴板！',
    AppLanguage.chineseTraditional: 'GitHub 主頁連結已複製至剪貼簿！',
    AppLanguage.korean: 'GitHub 프로필 링크가 클립보드에 복사되었습니다!',
  });

  String profileSavedToFavorites(String username) => _str({
    AppLanguage.indonesian: 'Profil $username disimpan ke favorit!',
    AppLanguage.english: 'Profile $username saved to favorites!',
    AppLanguage.japanese: '$username のプロフィールをお気に入りに保存しました！',
    AppLanguage.chineseSimplified: '用户 $username 已保存至收藏！',
    AppLanguage.chineseTraditional: '使用者 $username 已儲存至收藏！',
    AppLanguage.korean: '$username 프로필이 즐겨찾기에 저장되었습니다!',
  });

  String get profileRemovedFromFavorites => _str({
    AppLanguage.indonesian: 'Dihapus dari favorit.',
    AppLanguage.english: 'Removed from favorites.',
    AppLanguage.japanese: 'お気に入りから削除しました。',
    AppLanguage.chineseSimplified: '已从收藏中移除。',
    AppLanguage.chineseTraditional: '已從收藏中移除。',
    AppLanguage.korean: '즐겨찾기에서 제거되었습니다.',
  });

  String get summaryCopiedToast => _str({
    AppLanguage.indonesian: 'Ringkasan statistik berhasil disalin ke clipboard!',
    AppLanguage.english: 'Stats summary copied to clipboard!',
    AppLanguage.japanese: '統計サマリーをクリップボードにコピーしました！',
    AppLanguage.chineseSimplified: '统计摘要已复制到剪贴板！',
    AppLanguage.chineseTraditional: '統計摘要已複製至剪貼簿！',
    AppLanguage.korean: '통계 요약이 클립보드에 복사되었습니다!',
  });

  String get activeNowBadge => _str({
    AppLanguage.indonesian: 'Sedang aktif',
    AppLanguage.english: 'Currently active',
    AppLanguage.japanese: '現在アクティブ',
    AppLanguage.chineseSimplified: '正在活跃',
    AppLanguage.chineseTraditional: '正在活躍',
    AppLanguage.korean: '현재 활동 중',
  });

  String get notActiveYetBadge => _str({
    AppLanguage.indonesian: 'Belum aktif',
    AppLanguage.english: 'Not active yet',
    AppLanguage.japanese: 'まだ未活動',
    AppLanguage.chineseSimplified: '尚未活跃',
    AppLanguage.chineseTraditional: '尚未活躍',
    AppLanguage.korean: '아직 비활동',
  });

  String get consistencyRecord => _str({
    AppLanguage.indonesian: 'Rekor konsistensi',
    AppLanguage.english: 'Consistency record',
    AppLanguage.japanese: '継続性の記録',
    AppLanguage.chineseSimplified: '坚持记录',
    AppLanguage.chineseTraditional: '堅持紀錄',
    AppLanguage.korean: '일관성 기록',
  });

  String get thisYearSubtitle => _str({
    AppLanguage.indonesian: 'Tahun ini',
    AppLanguage.english: 'This year',
    AppLanguage.japanese: '今年',
    AppLanguage.chineseSimplified: '今年',
    AppLanguage.chineseTraditional: '今年',
    AppLanguage.korean: '올해',
  });

  String get lastYearSubtitle => _str({
    AppLanguage.indonesian: 'Tahun lalu',
    AppLanguage.english: 'Last year',
    AppLanguage.japanese: '昨年',
    AppLanguage.chineseSimplified: '去年',
    AppLanguage.chineseTraditional: '去年',
    AppLanguage.korean: '작년',
  });

  String get allTimeSubtitle => _str({
    AppLanguage.indonesian: 'Sepanjang waktu',
    AppLanguage.english: 'All time',
    AppLanguage.japanese: '全期間',
    AppLanguage.chineseSimplified: '所有时间',
    AppLanguage.chineseTraditional: '所有時間',
    AppLanguage.korean: '전체 기간',
  });

  String get accountOverviewTitle => _str({
    AppLanguage.indonesian: 'Ikhtisar Akun',
    AppLanguage.english: 'Account Overview',
    AppLanguage.japanese: 'アカウント概要',
    AppLanguage.chineseSimplified: '账户概览',
    AppLanguage.chineseTraditional: '帳戶概覽',
    AppLanguage.korean: '계정 개요',
  });

  String get acrossAllRepos => _str({
    AppLanguage.indonesian: 'di semua repo',
    AppLanguage.english: 'across all repos',
    AppLanguage.japanese: '全リポジトリ合計',
    AppLanguage.chineseSimplified: '在所有仓库中',
    AppLanguage.chineseTraditional: '在所有倉庫中',
    AppLanguage.korean: '모든 리포지토리 대상',
  });

  String get registeredReposSubtitle => _str({
    AppLanguage.indonesian: 'terdaftar',
    AppLanguage.english: 'registered',
    AppLanguage.japanese: '公開中',
    AppLanguage.chineseSimplified: '已公开',
    AppLanguage.chineseTraditional: '已公開',
    AppLanguage.korean: '등록됨',
  });

  // Relative Time Ago
  String formatRelativeTime(DateTime? date) {
    if (date == null) {
      return _str({
        AppLanguage.indonesian: 'Tidak ada aktivitas',
        AppLanguage.english: 'No activity',
        AppLanguage.japanese: '活動なし',
        AppLanguage.chineseSimplified: '无活动',
        AppLanguage.chineseTraditional: '無活動',
        AppLanguage.korean: '활동 없음',
      });
    }

    final diff = DateTime.now().difference(date);
    if (diff.isNegative || diff.inMinutes < 1) {
      return _str({
        AppLanguage.indonesian: 'Baru saja',
        AppLanguage.english: 'Just now',
        AppLanguage.japanese: 'たった今',
        AppLanguage.chineseSimplified: '刚刚',
        AppLanguage.chineseTraditional: '剛剛',
        AppLanguage.korean: '방금 전',
      });
    } else if (diff.inHours < 1) {
      return _str({
        AppLanguage.indonesian: '${diff.inMinutes} mnt lalu',
        AppLanguage.english: '${diff.inMinutes}m ago',
        AppLanguage.japanese: '${diff.inMinutes}分前',
        AppLanguage.chineseSimplified: '${diff.inMinutes}分钟前',
        AppLanguage.chineseTraditional: '${diff.inMinutes}分鐘前',
        AppLanguage.korean: '${diff.inMinutes}분 전',
      });
    } else if (diff.inHours < 24) {
      return _str({
        AppLanguage.indonesian: '${diff.inHours} jam lalu',
        AppLanguage.english: '${diff.inHours}h ago',
        AppLanguage.japanese: '${diff.inHours}時間前',
        AppLanguage.chineseSimplified: '${diff.inHours}小时前',
        AppLanguage.chineseTraditional: '${diff.inHours}小時前',
        AppLanguage.korean: '${diff.inHours}시간 전',
      });
    } else if (diff.inDays < 30) {
      return _str({
        AppLanguage.indonesian: '${diff.inDays} hari lalu',
        AppLanguage.english: '${diff.inDays}d ago',
        AppLanguage.japanese: '${diff.inDays}日前',
        AppLanguage.chineseSimplified: '${diff.inDays}天前',
        AppLanguage.chineseTraditional: '${diff.inDays}天前',
        AppLanguage.korean: '${diff.inDays}일 전',
      });
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return _str({
        AppLanguage.indonesian: '$months bln lalu',
        AppLanguage.english: '${months}mo ago',
        AppLanguage.japanese: '$monthsヶ月前',
        AppLanguage.chineseSimplified: '$months个月前',
        AppLanguage.chineseTraditional: '$months個月前',
        AppLanguage.korean: '$months개월 전',
      });
    } else {
      final years = (diff.inDays / 365).floor();
      return _str({
        AppLanguage.indonesian: '$years thn lalu',
        AppLanguage.english: '${years}y ago',
        AppLanguage.japanese: '$years年前',
        AppLanguage.chineseSimplified: '$years年前',
        AppLanguage.chineseTraditional: '$years年前',
        AppLanguage.korean: '$years년 전',
      });
    }
  }

  String get updatedPrefix => _str({
    AppLanguage.indonesian: 'Diperbarui',
    AppLanguage.english: 'Updated',
    AppLanguage.japanese: '更新日',
    AppLanguage.chineseSimplified: '更新于',
    AppLanguage.chineseTraditional: '更新於',
    AppLanguage.korean: '업데이트',
  });

  // Localized Commit Tier Level Name
  String getCommitTierLevelName(int tier) {
    switch (tier) {
      case 1:
        return _str({
          AppLanguage.indonesian: 'Sangat Rajin (Master)',
          AppLanguage.english: 'Extremely Active (Master)',
          AppLanguage.japanese: '超活発 (マスター)',
          AppLanguage.chineseSimplified: '极其活跃 (大师)',
          AppLanguage.chineseTraditional: '極其活躍 (大師)',
          AppLanguage.korean: '초극도 활동 (마스터)',
        });
      case 2:
        return _str({
          AppLanguage.indonesian: 'Sangat Rajin',
          AppLanguage.english: 'Highly Active',
          AppLanguage.japanese: 'とても活発',
          AppLanguage.chineseSimplified: '非常活跃',
          AppLanguage.chineseTraditional: '非常活躍',
          AppLanguage.korean: '매우 활발',
        });
      case 3:
        return _str({
          AppLanguage.indonesian: 'Rajin & Stabil',
          AppLanguage.english: 'Active & Steady',
          AppLanguage.japanese: '安定して活発',
          AppLanguage.chineseSimplified: '稳健活跃',
          AppLanguage.chineseTraditional: '穩健活躍',
          AppLanguage.korean: '안정적 활동',
        });
      case 4:
        return _str({
          AppLanguage.indonesian: 'Commit Terkadang',
          AppLanguage.english: 'Casual Committer',
          AppLanguage.japanese: 'たまにコミット',
          AppLanguage.chineseSimplified: '偶尔提交',
          AppLanguage.chineseTraditional: '偶爾提交',
          AppLanguage.korean: '가끔 커밋',
        });
      case 5:
        return _str({
          AppLanguage.indonesian: 'Jarang Commit',
          AppLanguage.english: 'Low Activity',
          AppLanguage.japanese: 'コミット少なめ',
          AppLanguage.chineseSimplified: '低频提交',
          AppLanguage.chineseTraditional: '低頻提交',
          AppLanguage.korean: '낮은 활동',
        });
      case 6:
      default:
        return _str({
          AppLanguage.indonesian: 'Belum Aktif',
          AppLanguage.english: 'Not Active Yet',
          AppLanguage.japanese: 'まだ未活動',
          AppLanguage.chineseSimplified: '尚未活跃',
          AppLanguage.chineseTraditional: '尚未活躍',
          AppLanguage.korean: '아직 비활동',
        });
    }
  }

  // Localized Commit Tier Clean Title
  String getCommitTierCleanTitle(int tier) {
    switch (tier) {
      case 1:
        return _str({
          AppLanguage.indonesian: 'Code Titan',
          AppLanguage.english: 'Code Titan',
          AppLanguage.japanese: 'コードタイタン',
          AppLanguage.chineseSimplified: '代码泰坦',
          AppLanguage.chineseTraditional: '代碼泰坦',
          AppLanguage.korean: '코드 타이탄',
        });
      case 2:
        return _str({
          AppLanguage.indonesian: 'Relentless Committer',
          AppLanguage.english: 'Relentless Committer',
          AppLanguage.japanese: '執念のコミッター',
          AppLanguage.chineseSimplified: '不倦提交者',
          AppLanguage.chineseTraditional: '不倦提交者',
          AppLanguage.korean: '끈질긴 커미터',
        });
      case 3:
        return _str({
          AppLanguage.indonesian: 'Consistent Builder',
          AppLanguage.english: 'Consistent Builder',
          AppLanguage.japanese: '堅実なビルダー',
          AppLanguage.chineseSimplified: '稳健构建者',
          AppLanguage.chineseTraditional: '穩健構建者',
          AppLanguage.korean: '꾸준한 빌더',
        });
      case 4:
        return _str({
          AppLanguage.indonesian: 'Weekend Warrior',
          AppLanguage.english: 'Weekend Warrior',
          AppLanguage.japanese: '週末ウォリアー',
          AppLanguage.chineseSimplified: '周末战士',
          AppLanguage.chineseTraditional: '週末戰士',
          AppLanguage.korean: '주말 전사',
        });
      case 5:
        return _str({
          AppLanguage.indonesian: 'Dormant Explorer',
          AppLanguage.english: 'Dormant Explorer',
          AppLanguage.japanese: '休眠中の探検家',
          AppLanguage.chineseSimplified: '潜沉探索者',
          AppLanguage.chineseTraditional: '潛沉探索者',
          AppLanguage.korean: '휴면 탐험가',
        });
      case 6:
      default:
        return _str({
          AppLanguage.indonesian: 'Fresh Sprout',
          AppLanguage.english: 'Fresh Sprout',
          AppLanguage.japanese: 'フレッシュな若芽',
          AppLanguage.chineseSimplified: '崭新萌芽',
          AppLanguage.chineseTraditional: '嶄新萌芽',
          AppLanguage.korean: '새싹 개발자',
        });
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLanguage.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    final language = AppLanguage.fromCode(
      locale.scriptCode != null && locale.scriptCode!.isNotEmpty
          ? '${locale.languageCode}_${locale.scriptCode}'
          : locale.languageCode,
    );
    final localizations = AppLocalizations(language);
    AppLocalizations._current = localizations;
    return SynchronousFuture<AppLocalizations>(localizations);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
