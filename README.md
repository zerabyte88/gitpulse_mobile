# GitPulse Mobile

<div align="center">

<p align="center">
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Flutter-Dark.svg" height="52" alt="Flutter" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Dart-Dark.svg" height="52" alt="Dart" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Github-Dark.svg" height="52" alt="GitHub" />
</p>

### Enterprise-Grade Developer Telemetry & Productivity Analytics

[![Release](https://img.shields.io/badge/Release-v1.0.1-blue?style=flat-square)](https://github.com/zerabyte88/gitpulse_mobile/releases)
[![Build](https://img.shields.io/badge/Build-2-brightgreen?style=flat-square)](pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.24.0-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.5.0-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-10B981?style=flat-square&logo=android&logoColor=white)](https://developer.android.com)
[![CI/CD Status](https://img.shields.io/badge/CI%2FCD-Passing-brightgreen?style=flat-square&logo=githubactions&logoColor=white)](.github/workflows/main.yml)
[![Tests](https://img.shields.io/badge/Tests-Passing%20(20%2F20)-success?style=flat-square)](test/widget_test.dart)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Layered-orange?style=flat-square)](#system-architecture--data-flow)
[![License](https://img.shields.io/badge/License-MIT-8B5CF6?style=flat-square)](LICENSE)

<p align="center">
  <b>GitPulse Mobile</b> is an open-source developer telemetry and productivity analytics mobile application built with Flutter. It transforms raw GitHub REST API v3 payloads into 24-hour work rhythm visualizations, cumulative portfolio impact metrics, and deterministic developer persona classifications—processed entirely on-device without third-party intermediary servers.
</p>

<p align="center">
  <a href="#problem-statement--core-value">Problem Statement</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#system-architecture--data-flow">Architecture & Data Flow</a> •
  <a href="#theme-system--secret-easter-egg">Themes & Easter Egg</a> •
  <a href="#in-app-updater-ota-pipeline">In-App Updater (OTA)</a> •
  <a href="#developer-persona-classification-matrix">Persona Matrix</a> •
  <a href="#commit-activity-tier-matrix">Tier Animations</a> •
  <a href="#security--privacy-governance">Security</a> •
  <a href="#technology-stack">Tech Stack</a> •
  <a href="#installation--getting-started">Installation</a> •
  <a href="#strategic-roadmap">Roadmap</a>
</p>

</div>

---

## Problem Statement & Core Value

The standard GitHub contribution graph ("green squares") displays daily activity frequency, but suffers from fundamental limitations:
- **Absence of Temporal Context**: It does not distinguish whether commits occur at midnight, early dawn, or during core business hours.
- **Fragmented Portfolio Impact**: Users must manually calculate aggregate stargazers and forks scattered across dozens of repositories.
- **Lack of Qualitative Profiling**: It fails to capture an engineer's architectural habits (e.g., deep focus within a single ecosystem vs. polyglot versatility).
- **Update Friction on Mobile**: Open-source APK users typically endure cumbersome manual uninstall and reinstall cycles to update their apps.

**GitPulse Mobile** solves these gaps by aggregating public repository metadata, user profiles, and event streams into a unified, privacy-first, on-device intelligence dashboard with built-in in-app OTA update capabilities and zero bloat.

---

## Key Features

<table>
  <thead>
    <tr>
      <th width="35%">Feature</th>
      <th width="65%">Technical Specification</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <b>In-App OTA Updater</b><br/>
        <i>Seamless In-Place Upgrades</i>
      </td>
      <td>
        Queries GitHub Releases API for new semantic version tags. Downloads APK assets in the background with live percentage streaming (<code>ota_update</code>) and triggers Android Package Installer directly without requiring uninstall/reinstall. User tokens, bookmarks, and settings are fully preserved. Includes a dedicated browser fallback button.
      </td>
    </tr>
    <tr>
      <td>
        <b>Automatic Post-Install APK Deletion</b><br/>
        <i>Zero Storage Waste</i>
      </td>
      <td>
        Automatically purges leftover APK binaries from internal storage (<code>/files/ota_update/gitpulse-latest.apk</code>) upon app launch or installation completion, preventing downloaded update packages from consuming device storage.
      </td>
    </tr>
    <tr>
      <td>
        <b>Adaptive 4-Theme Engine + Secret Easter Egg</b><br/>
        <i>OLED, Dark, Light & Japanese Cyberpunk</i>
      </td>
      <td>
        Features <b>Gelap Biasa</b> (GitHub Dark #0D1117), <b>Gelap AMOLED</b> (True Pitch Black #000000 for OLED battery savings), and <b>Terang</b> (GitHub Light #F6F8FA). Includes an exclusive secret <b>Gelap AMOLED Jejepangan</b> mode (Mystic Obsidian #040207, Neo Sakura Pink, Kyoto Wisteria, and Torii Crimson) unlocked by tapping the AMOLED option 10 times in Settings.
      </td>
    </tr>
    <tr>
      <td>
        <b>Dynamic Tier Badges & Full Name Display</b><br/>
        <i>Zero Truncation Geometry</i>
      </td>
      <td>
        Places commit tier badges (<code>AnimatedTierTitle</code>) adjacent to the user's display name using a responsive <code>Wrap</code> layout. Long developer names (e.g., <i>Adrian Gunawan</i>) render completely without truncation or ellipsis dots.
      </td>
    </tr>
    <tr>
      <td>
        <b>Tier-Tailored Animation Engine</b><br/>
        <i>Level-Specific Particle & Shimmer FX</i>
      </td>
      <td>
        - <b>Tier 1 (Code Titan):</b> Floating flame particle physics with glowing gradient sweep.<br/>
        - <b>Tier 2 (Relentless Committer):</b> High-voltage electric plasma arc with lightning crackle.<br/>
        - <b>Tier 3 (Consistent Builder):</b> Emerald cyber matrix sweep with digital scanlines.<br/>
        - <b>Tier 4 (Weekend Warrior):</b> Solar amber sunburst shimmer with rotating angular gleam.<br/>
        - <b>Tier 5 (Dormant Explorer):</b> Cosmic starlight nebula drift with gentle pulsing star dust.<br/>
        - <b>Tier 6 (Fresh Sprout):</b> Spring dewdrop bloom pulse with organic respiratory scale.
      </td>
    </tr>
    <tr>
      <td>
        <b>GitHub Trending & Curated Tech News</b><br/>
        <i>Ecosystem & Trending Repositories</i>
      </td>
      <td>
        Fetches top trending open-source GitHub repositories via GitHub Search API alongside curated engineering articles from dev.to. Supports category filter chips (<b>Trending</b>, <b>Semua</b>, <b>GitHub</b>, <b>Web Dev</b>) with offline fallback data and external browser navigation.
      </td>
    </tr>
    <tr>
      <td>
        <b>Developer Attribution & Live Avatar CDN</b><br/>
        <i>Auto-Updating Profile Picture</i>
      </td>
      <td>
        Interactive developer credits in the About section and settings footer (<code>Made with ❤️ by zerabyte88</code>). Leverages GitHub's live CDN (<code>https://github.com/zerabyte88.png</code>) with circular clipping and subtle borders to automatically reflect avatar updates without app updates.
      </td>
    </tr>
    <tr>
      <td>
        <b>Multi-Language Localization (i18n)</b><br/>
        <i>6 International Languages</i>
      </td>
      <td>
        Full native translation coverage across 6 languages: <b>Bahasa Indonesia</b>, <b>English</b>, <b>日本語 (Japanese)</b>, <b>한국어 (Korean)</b>, <b>中文 (Chinese)</b>, and <b>Español (Spanish)</b>, switchable on-the-fly without restarting the app.
      </td>
    </tr>
    <tr>
      <td>
        <b>24-Hour Productivity Rhythm</b><br/>
        <i>Peak Coding Hours Detection</i>
      </td>
      <td>
        Maps public event streams into an interactive 24-bar histogram using <code>fl_chart</code>. Automatically converts UTC timestamps to local device time (00:00–23:00) to pinpoint when an engineer is most active in commits, PRs, and reviews.
      </td>
    </tr>
    <tr>
      <td>
        <b>Deterministic Developer Persona Engine</b><br/>
        <i>Rule-Based Qualitative Profiling</i>
      </td>
      <td>
        Evaluates quantitative telemetry against a deterministic heuristic matrix to classify developers into specialized professional personas (e.g., Star Magnet, Midnight Owl, Polyglot Architect).
      </td>
    </tr>
    <tr>
      <td>
        <b>Language Footprint Distribution</b><br/>
        <i>Interactive Multi-Language Donut Chart</i>
      </td>
      <td>
        Renders a donut chart illustrating primary programming languages across non-forked public repositories, weighted by repository size or codebase volume using authentic ecosystem colors.
      </td>
    </tr>
    <tr>
      <td>
        <b>Consolidated Portfolio Aggregator</b><br/>
        <i>Cross-Repository Impact Metrics</i>
      </td>
      <td>
        Aggregates cumulative stargazers, total forks, public repository counts (original vs. forked), and follower ratios without external database dependencies.
      </td>
    </tr>
    <tr>
      <td>
        <b>Offline-First Local Cache & Bookmarks</b><br/>
        <i>Persistent State Management</i>
      </td>
      <td>
        Enables one-tap bookmarking of developer profiles into localized <code>shared_preferences</code> storage for instantaneous offline access without network latency.
      </td>
    </tr>
    <tr>
      <td>
        <b>Adaptive Dual Rate-Limiting Strategy</b><br/>
        <i>Anonymous vs. Authenticated Execution</i>
      </td>
      <td>
        Seamlessly alternates between anonymous requests (60 req/hr) and authenticated execution via GitHub Personal Access Tokens (5,000 req/hr), stored securely inside the application sandbox.
      </td>
    </tr>
    <tr>
      <td>
        <b>Lean APK & Zero Bloat Optimization</b><br/>
        <i>Clean Binary Footprint</i>
      </td>
      <td>
        Unused packages and font assets (`cupertino_icons`) have been completely eliminated. The release pipeline compiles exclusively for 64-bit ARM (`arm64-v8a`), cutting APK size in half and accelerating cold startup.
      </td>
    </tr>
  </tbody>
</table>

---

## System Architecture & Data Flow

GitPulse Mobile follows **Clean Layered Architecture** principles to separate concerns, enforce testability, and isolate business logic from presentation and transport protocols:

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                   PRESENTATION LAYER                                   │
│       (Flutter 3 • 4-Mode Reactive Theme • 6-Language i18n • Inter Google Fonts)       │
│                                                                                        │
│   ┌───────────────────────────┐                     ┌──────────────────────────────┐   │
│   │        HomeScreen         │                     │      StatsDetailScreen       │   │
│   ├───────────────────────────┤                     ├──────────────────────────────┤   │
│   │ • Search Input Field      │                     │ • Full Name & Tier Title Wrap│   │
│   │ • Bookmarked Profiles     │                     │ • 24h Activity Histogram     │   │
│   │ • GitHub Token Modal      │                     │ • Language Distribution Donut│   │
│   │ • 4-Theme Selection Card  │                     │ • Top Repositories Grid      │   │
│   │ • In-App OTA Updater Card │                     │ • Persona Badge & Telemetry  │   │
│   │ • GitHub Trending Feeds   │                     │ • Clean Habit Summary Banner │   │
│   │ • Live Avatar Settings    │                     │ • Stargazer & Fork Metrics   │   │
│   └─────────────┬─────────────┘                     └──────────────▲───────────────┘   │
└─────────────────┼──────────────────────────────────────────────────┼───────────────────┘
                  │ 1. Search Query / Theme / Update Event           │ 5. Aggregated UI State
                  ▼                                                  │
┌────────────────────────────────────────────────────────────────────┴───────────────────┐
│                                   DOMAIN & LOGIC LAYER                                 │
│                                                                                        │
│   ┌────────────────────────────────────────────────────────────────────────────────┐   │
│   │                              UserStats Calculation Engine                      │   │
│   │  • Metric Aggregator (Total Stars, Forks, Repo Volume, Primary Languages)      │   │
│   │  • 24-Hour Event Binner (Converts ISO-8601 UTC to Local Time 00:00–23:00)      │   │
│   │  • Deterministic Persona Classifier (Star Magnet, Midnight Owl, Polyglot, etc.)│   │
│   ├────────────────────────────────────────────────────────────────────────────────┤   │
│   │                              UpdateService & OTA Engine                        │   │
│   │  • Semantic Version Comparator (e.g., v1.0.2 > v1.0.1)                         │   │
│   │  • Android PackageInstaller Stream Handler & Auto-Cleanup Routine              │   │
│   ├────────────────────────────────────────────────────────────────────────────────┤   │
│   │                              AppLanguageService & AppThemeService              │   │
│   │  • 6-Language Reactive Notifier & 4-Mode Theme State Machine                   │   │
│   │  • 10x Tap Secret Easter Egg Evaluator & Persistence Controller                │   │
│   └────────────────────────────────────────▲───────────────────────────────────────┘   │
└────────────────────────────────────────────┼───────────────────────────────────────────┘
                                             │ 4. Deserialized Models (User, Repos, Events)
┌────────────────────────────────────────────┴───────────────────────────────────────────┐
│                                  DATA & PERSISTENCE LAYER                              │
│                                                                                        │
│   ┌───────────────────────────────────┐            ┌───────────────────────────────┐   │
│   │    GitHubApiService & TechNews    │            │        StorageService         │   │
│   ├───────────────────────────────────┤            ├───────────────────────────────┤   │
│   │ • GET /users/{username}           │            │ • SharedPreferences Engine    │   │
│   │ • GET /users/{username}/repos     │            │ • Persistent Bookmark Cache   │   │
│   │ • GET /users/{username}/events    │            │ • Sandboxed GitHub PAT Secret │   │
│   │ • GET /repos/.../releases/latest  │            │ • Theme Preference Persistence│   │
│   │ • Trending Repositories API       │            │ • Japanese Theme Secret State │   │
│   │ • Dual Rate Limit (60 vs 5,000/hr)│            │ • Selected Language Code (i18n│   │
│   └─────────────────┬─────────────────┘            └───────────────▲───────────────┘   │
└─────────────────────┼──────────────────────────────────────────────┼───────────────────┘
                      │ 2. HTTPS / TLS 1.3 Requests                  │ 3. Read / Write Cache
                      ▼                                              ▼
┌───────────────────────────────────────────┐  ┌─────────────────────────────────────────┐
│          GitHub REST API v3               │  │           Device Local Storage          │
│       (api.github.com Endpoints)          │  │        (Android Sandbox / Files)        │
└───────────────────────────────────────────┘  └─────────────────────────────────────────┘
```

---

## Theme System & Secret Easter Egg

GitPulse Mobile features a centralized `AppThemeService` paired with dynamic color tokens in `AppTheme`, allowing instantaneous runtime switching without requiring an app restart:

1. **Gelap Biasa (`dark`)**: Classic GitHub Dark palette (`#0D1117` background, `#161B22` surface, `#30363D` borders, GitHub Blue `#58A6FF` accents).
2. **Gelap AMOLED (`amoled`)**: True pitch black (`#000000` background, `#0A0A0A` surface) engineered for OLED/AMOLED power savings and ultra-high contrast.
3. **Terang (`light`)**: High-contrast GitHub Light palette (`#F6F8FA` background, `#FFFFFF` cards, GitHub Light Blue `#0969DA`).
4. **Gelap AMOLED Jejepangan (`amoledJapanese`)**: Exclusive Japanese cyberpunk aesthetic (`#040207` background, Neo Sakura Pink `#FF6B9D`, Kyoto Wisteria `#B57EDC`, and Torii Crimson `#FF3366`).

### 🌸 How to Unlock the Japanese AMOLED Secret:
1. Open **Settings** (gear icon in the top-right corner).
2. Locate the **Tema Aplikasi** (Theme) section.
3. Tap the **Gelap AMOLED** option rapidly **10 times**.
4. Upon the 10th tap:
   - A heavy haptic vibration triggers.
   - A celebratory toast announces: *"🎉 Selamat! Anda membuka tema rahasia: Gelap AMOLED Jejepangan 🌸"*.
   - The theme switches immediately and is permanently saved to device storage.

---

## In-App Updater (OTA) Pipeline

```text
[Settings: "Periksa Pembaruan" or Auto-Check]
                    │
                    ▼
       1. GitHub Releases API Query
   (api.github.com/repos/zerabyte88/gitpulse_mobile/releases/latest)
                    │
                    ▼
       2. Semantic Version Comparator
         (Compares Tag e.g. v1.0.2 vs Installed v1.0.1)
                    │
       ┌────────────┴────────────┐
       ▼                         ▼
Already Up-to-Date       New Version Available!
 "Sudah versi terbaru"           │
                                 ▼
                         3. Extract APK Asset URL
                         (e.g., GitPulse-v1.0.2-arm64-v8a.apk)
                                 │
                                 ▼
                         4. Background OTA Download Stream
                            (Live Progress: 0% ──► 100%)
                                 │
                 ┌───────────────┴───────────────┐
                 ▼                               ▼
       [Native PackageInstaller]         [Fallback: Browser]
       Directly overwrites APK           Opens release asset in
       in-place (data preserved)         external browser
                 │
                 ▼
       [Auto-Cleanup Routine]
       Automatically deletes downloaded
       gitpulse-latest.apk on launch / finish
```

- **In-Place Upgrade**: Upgrades the APK without requiring users to uninstall, preserving tokens, bookmarks, and preferences.
- **Auto-Cleanup**: Automatically cleans up `gitpulse-latest.apk` from internal cache (`/data/user/0/com.gitpulse.gitpulse_mobile/files/ota_update/`) upon app launch or completion, keeping device storage lean.
- **Browser Fallback**: If OEM permission restrictions block native installation, a dedicated button opens the release asset directly in the system browser.

---

## Developer Persona Classification Matrix

| Persona | Evaluation Criteria | Characteristic Profile |
| :--- | :--- | :--- |
| **Star Magnet** | `Total Stars >= 100` | Exceptional community impact with widely acknowledged open-source repositories. |
| **Polyglot Architect** | `Unique Languages >= 4` | Broad technological breadth across distinct ecosystems, languages, and paradigms. |
| **Midnight Owl Coder** | `Night Events (22:00–04:59) > Morning & Afternoon` | Highest engineering focus and productivity occur during late-night hours. |
| **Early Bird Developer** | `Morning Events (05:00–11:59) > Afternoon & Night` | Consistent early-morning execution rhythm with high-clarity morning commits. |
| **Prolific Builder** | `Total Public Repositories > 20` | High-output builder continuously creating, prototyping, and shipping code. |
| **Dedicated Craftsman** | *Default Fallback Condition* | Consistent, methodical contributor dedicated to quality software craftsmanship. |

---

## Commit Activity Tier Matrix

Each developer profile is assigned an activity tier based on public commit volume over recent event history, with tailored particle physics and shader effects:

| Tier Level | Title Badge | Commits | Visual Animation FX | Motif |
| :--- | :--- | :--- | :--- | :--- |
| **Tier 1** | **Code Titan** | 100+ | Autonomous floating flame particle physics (`CustomPainter`) with radiant gradient sweep | 🔥 Blazing Fire & Magma |
| **Tier 2** | **Relentless Committer** | 50–99 | High-voltage electric plasma arc with lightning shockwave crackle & micro-sparkles | ⚡ Electric Plasma Arc |
| **Tier 3** | **Consistent Builder** | 25–49 | Emerald cyber matrix sweep with digital scanline data stream | 💻 Emerald Cyber Matrix |
| **Tier 4** | **Weekend Warrior** | 10–24 | Solar amber sunburst shimmer with rotating angular gleam | ☀️ Solar Amber Gleam |
| **Tier 5** | **Dormant Explorer** | 1–9 | Cosmic starlight nebula drift with gentle pulsing star dust | ✨ Starlight Nebula |
| **Tier 6** | **Fresh Sprout** | 0 | Spring dewdrop bloom pulse with gentle organic scale respiration | 🌱 Spring Dewdrop |

> [!NOTE]
> The tier badge is rendered alongside the developer's full display name (e.g., *Adrian Gunawan*) within a flexible `Wrap` layout, ensuring zero text truncation (`...`) across all screen densities.

---

## Security & Privacy Governance

GitPulse Mobile is engineered around a **Privacy-First** ethos:

1. **Direct Client-to-API Communication**: All HTTPS transactions occur directly between the user's device and official GitHub endpoints (`api.github.com`) using TLS 1.3. No third-party proxy or intermediary server is involved.
2. **Sandboxed Personal Access Token (PAT)**: Optional GitHub tokens are stored solely in the application's internal sandboxed storage (`shared_preferences`). Tokens are never sent to external telemetry servers.
3. **Least Privilege Enforcement**: The application operates exclusively with read permissions on public data. No write scopes or private repository permissions are requested.
4. **Zero Third-Party Telemetry**: Contains no third-party tracking scripts, advertising SDKs, or invasive user analytics.
5. **Safe In-App Updates**: APKs are fetched directly from GitHub Releases (`api.github.com`) over secure TLS connections and verified against Android package signatures.

---

## Technology Stack

| Category | Technology | Version | Architectural Purpose |
| :--- | :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | `>=3.24.0` | High-performance Ahead-Of-Time (AOT) cross-platform compilation for Android and Web |
| **Language** | [Dart](https://dart.dev) | `>=3.5.0` | Sound null-safety, pattern matching, and structured concurrency |
| **In-App Updater** | [ota_update](https://pub.dev/packages/ota_update) | `^7.1.0` | Background native Android PackageInstaller OTA update streaming |
| **Visualization** | [fl_chart](https://pub.dev/packages/fl_chart) | `^1.2.0` | Hardware-accelerated vector charting engine with touch interactions |
| **Networking** | [http](https://pub.dev/packages/http) | `^1.6.0` | Robust composable HTTP client for RESTful API communication |
| **Typography** | [google_fonts](https://pub.dev/packages/google_fonts) | `^8.2.1` | Professional, high-legibility Inter font family |
| **Persistence** | [shared_preferences](https://pub.dev/packages/shared_preferences) | `^2.5.5` | Platform-native encrypted key-value storage abstraction |
| **Formatting** | [intl](https://pub.dev/packages/intl) | `^0.20.3` | ISO 8601 timezone manipulation and localized number formatting |
| **Deep Linking** | [url_launcher](https://pub.dev/packages/url_launcher) | `^6.3.2` | External browser navigation for repository links and articles |
| **Code Quality** | [flutter_lints](https://pub.dev/packages/flutter_lints) | `^6.0.0` | Official Flutter linter ruleset for idiomatic Dart standards |

---

## Project Directory Structure

```text
gitpulse_mobile/
├── .github/
│   └── workflows/
│       └── main.yml                 # Unified CI/CD (Test, 64-bit APK Build & Release)
├── android/                         # Android platform host files (Gradle, Manifests)
├── lib/
│   ├── main.dart                    # Application entrypoint & auto-cleanup initialization
│   ├── localization/                # Multi-language internationalization support
│   │   ├── app_language.dart        # Supported language enums & locales (6 languages)
│   │   └── app_localizations.dart   # Comprehensive translation dictionaries
│   ├── models/                      # Domain entities & analytical computation engines
│   │   ├── bookmarked_user.dart     # Bookmarked profile serialization model
│   │   ├── contribution_stats.dart  # Event activity & commit habit tier models
│   │   ├── github_rate_limit.dart   # API rate-limit state tracking model
│   │   ├── github_repo.dart         # Repository schema deserializer
│   │   ├── github_user.dart         # User profile schema deserializer
│   │   ├── tech_news.dart           # Tech news & GitHub trending item model
│   │   └── user_stats.dart          # Core telemetry calculation & persona engine
│   ├── screens/                     # UI screens & controllers
│   │   ├── home_screen.dart         # Search, bookmarks, trending news & version badge
│   │   └── stats_detail_screen.dart # Interactive analytics dashboard & charts
│   ├── services/                    # Networking & persistent storage layer
│   │   ├── app_language_service.dart# Language preference manager (6 languages)
│   │   ├── app_theme_service.dart   # Reactive 4-mode theme notifier & easter egg unlocker
│   │   ├── github_api_service.dart  # GitHub REST API v3 client with error handling
│   │   ├── storage_service.dart     # SharedPreferences persistence wrapper
│   │   ├── tech_news_service.dart   # Curated tech news & GitHub trending fetcher
│   │   └── update_service.dart      # Semantic version check, OTA download & auto-cleanup
│   ├── theme/                       # Design system tokens & application metadata
│   │   └── app_theme.dart           # 4-theme color definitions, typography & AppConfig
│   └── widgets/                     # Modular reusable UI components
│       ├── activity_chart.dart      # 24-hour activity bar chart (fl_chart)
│       ├── animated_tier_title.dart # Level-tailored animated status badge (Tiers 1-6)
│       ├── language_chart.dart      # Language distribution donut chart (fl_chart)
│       ├── repo_tile.dart           # GitHub native repository card
│       ├── settings_sheet.dart      # Modal sheet for theme, updates, PAT, & About
│       ├── stat_card.dart           # Summary metric card
│       └── tech_news_card.dart      # Engineering digest & trending card widget
├── test/
│   └── widget_test.dart             # Complete unit, model, and OTA update test suite (20 tests)
├── web/                             # Web/PWA deployment entrypoint
└── pubspec.yaml                     # Dependency manifest & version metadata (v1.0.1+2)
```

---

## Installation & Getting Started

### Prerequisites
- **Flutter SDK**: Version `3.24.0` or higher
- **Dart SDK**: Version `3.5.0` or higher
- **Java Development Kit (JDK)**: OpenJDK 17
- **Target Device**: Physical Android device with USB debugging enabled, Android Emulator (API 28+), or Google Chrome

### Step-by-Step Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/zerabyte88/gitpulse_mobile.git
   cd gitpulse_mobile
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Static Analysis & Unit Tests**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the Application**:
   - For Google Chrome (Web):
     ```bash
     flutter run -d chrome
     ```
   - For Android Device / Emulator:
     ```bash
     flutter run -d android
     ```

5. **Build Release APK (64-bit ARM Only)**:
   ```bash
   flutter build apk --release --target-platform android-arm64
   # Compiled binary output: build/app/outputs/flutter-apk/app-release.apk
   ```

---

## CI/CD Pipeline & GitHub Releases

This repository utilizes a unified GitHub Actions pipeline (`.github/workflows/main.yml`):

1. **Automated Quality Gate & Binary Compilation**:
   - Triggers on every push and pull request to `main` and `master`.
   - Runs `flutter pub get`, `flutter analyze` (zero lint warnings), and `flutter test` (**20/20 tests passing**).
   - Compiles **strictly 64-bit ARM APK** (`--target-platform android-arm64`, with `arm64-v8a` ABI filter).
   - Generates SHA-256 checksums (`.sha256`) and attaches artifacts directly to the workflow run summary for immediate download.

2. **Automated & Manual Release Publishing**:
   - Triggered either **manually via `workflow_dispatch`** or automatically when pushing release tags (`v*`).
   - Packages and publishes the release bundle directly to **GitHub Releases**, ready for instant consumption by the In-App OTA Updater.

---

## Strategic Roadmap

- [x] Comprehensive cross-repo metric aggregation (Stars, Forks, Repos).
- [x] 24-hour developer productivity rhythm histogram.
- [x] Rule-based deterministic developer persona classification engine.
- [x] Top repository showcase sorted by star and fork volume.
- [x] Persistent local bookmarking & sandboxed Personal Access Token support.
- [x] **In-App OTA Updater**: GitHub Releases API check, background download & PackageInstaller integration.
- [x] **Auto-Cleanup Routine**: Automatically deletes downloaded update APK on startup to free storage.
- [x] **4-Theme System & Secret Easter Egg**: Dark, AMOLED, Light, and 10x-tap Japanese AMOLED mode.
- [x] **Responsive Name & Tier Title**: Dynamic `Wrap` geometry and full un-truncated user names.
- [x] **Upgraded Title Animations**: Level-specific particle & lightning effects for Tiers 1 through 6.
- [x] **GitHub Trending Feed**: Real-time trending open-source repositories with category filtering.
- [x] **Creator Attribution**: Live auto-updating GitHub avatar CDN integration (`zerabyte88.png`).
- [x] **6-Language Internationalization (i18n)**: Indonesian, English, Japanese, Korean, Chinese, Spanish.
- [x] **Lean APK Optimization**: Pruned unused dependencies (`cupertino_icons`) and dead font assets.
- [ ] **Visual Card Export**: Generate high-resolution PNG/SVG summary cards for social platforms.
- [ ] **Head-to-Head Compare**: Side-by-side productivity and language comparison between two developers.
- [ ] **Yearly Wrapped Recap**: Annual retrospective report summarizing annual coding habits.
- [ ] **Android Home Screen Widget**: Quick glance at productivity metrics via a native desktop widget.

---

## License

This project is open-source software licensed under the [MIT License](LICENSE).

<div align="center">
  <br/>
  <a href="https://github.com/zerabyte88">
    <img src="https://github.com/zerabyte88.png" width="48" height="48" style="border-radius: 50%;" alt="zerabyte88" />
  </a>
  <br/>
  <sub>Developed with ❤️ by <a href="https://github.com/zerabyte88">zerabyte88</a> (Creator & Maintainer)</sub>
</div>
