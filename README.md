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
[![CI/CD Status](https://img.shields.io/badge/CI%2FCD-Passing-brightgreen?style=flat-square&logo=githubactions&logoColor=white)](.github/workflows/ci.yml)
[![Tests](https://img.shields.io/badge/Tests-Passing%20(18%2F18)-success?style=flat-square)](test/widget_test.dart)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Layered-orange?style=flat-square)](#system-architecture--data-flow)
[![License](https://img.shields.io/badge/License-MIT-8B5CF6?style=flat-square)](LICENSE)

<p align="center">
  <b>GitPulse Mobile</b> is an open-source developer telemetry and productivity analytics mobile application built with Flutter. It transforms raw GitHub REST API v3 payloads into 24-hour work rhythm visualizations, cumulative portfolio impact metrics, and deterministic developer persona classifications—processed entirely on-device without third-party intermediary servers.
</p>

<p align="center">
  <a href="#whats-new-in-v101">What's New (v1.0.1)</a> •
  <a href="#problem-statement--core-value">Problem Statement</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#system-architecture--data-flow">Architecture & Data Flow</a> •
  <a href="#developer-persona-classification-matrix">Persona Matrix</a> •
  <a href="#security--privacy-governance">Security</a> •
  <a href="#technology-stack">Tech Stack</a> •
  <a href="#installation--getting-started">Installation</a> •
  <a href="#cicd-pipeline--apk-distribution">CI/CD APK</a> •
  <a href="#strategic-roadmap">Roadmap</a>
</p>

</div>

---

## What's New in v1.0.1

Version **v1.0.1 (Build 2)** delivers a comprehensive UI/UX overhaul engineered to replace artificial, generic AI-style aesthetics with an authentic, professional, and minimalist developer tool experience:

- **Minimalist Developer Design System**: Shifted from high-contrast pitch black and fluorescent neon cyberpunk gradients to a refined **GitHub Dark & Linear-inspired Slate Theme** (`#0D1117` canvas, `#161B22` cards, `#30363D` borders, and `#58A6FF` accent blue).
- **Inter Typography Standard**: Switched global typography to `GoogleFonts.inter` for maximum readability and information density suited for engineering telemetry.
- **Native Status & Tier Badges**: Eliminated gaudy pulsing rainbow shader masks in favor of crisp, understated developer badges (`AnimatedTierTitle`) with smooth ambient presence.
- **GitHub-Native Repository Cards**: Redesigned `RepoTile` to mirror native GitHub cards with authentic programming language color dots, clean star/fork indicators, and compact relative time pills.
- **Refined Rhythm & Language Charts**: Cleaned up `ActivityChart` and `LanguageChart` with semantic contribution colors (`#3FB950`), muted bar frames, and high-legibility legends.
- **In-App Build & Version Telemetry**: Integrated `AppConfig` and added an **About GitPulse** card inside the settings sheet alongside an app-bar version badge (`v1.0.1`), ensuring the APK version and build code are always visible and auditable.

---

## Problem Statement & Core Value

The standard GitHub contribution graph ("green squares") displays daily activity frequency, but suffers from fundamental limitations:
- **Absence of Temporal Context**: It does not distinguish whether commits occur at midnight, early dawn, or during core business hours.
- **Fragmented Portfolio Impact**: Users must manually calculate aggregate stargazers and forks scattered across dozens of repositories.
- **Lack of Qualitative Profiling**: It fails to capture an engineer's architectural habits (e.g., deep focus within a single ecosystem vs. polyglot versatility).

**GitPulse Mobile** solves these gaps by aggregating public repository metadata, user profiles, and event streams into a unified, privacy-first, on-device intelligence dashboard.

---

## Key Features

<table>
  <thead>
    <tr>
      <th width="40%">Feature</th>
      <th width="60%">Technical Specification</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <b>24-Hour Productivity Rhythm</b><br/>
        <i>Peak Coding Hours Detection</i>
      </td>
      <td>
        Maps public event streams into an interactive 24-bar histogram using <code>fl_chart</code>. Automatically converts UTC timestamps to local device time to pinpoint when an engineer is most active in commits, PRs, and reviews.
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
        <i>Interactive Multi-Language Breakdown</i>
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
        <b>Curated Tech News & Engineering Feeds</b><br/>
        <i>Real-Time Industry Intelligence</i>
      </td>
      <td>
        Integrates a live engineering news stream directly inside the home screen, allowing developers to monitor ecosystem trends alongside GitHub activity without visual clutter.
      </td>
    </tr>
    <tr>
      <td>
        <b>In-App Version & Build Telemetry</b><br/>
        <i>Auditable Release Details</i>
      </td>
      <td>
        Displays active release versions (<code>v1.0.1</code>) and build identifiers (<code>Build 2</code>) both in the home app bar and the comprehensive application information sheet.
      </td>
    </tr>
    <tr>
      <td>
        <b>One-Click Shareable Telemetry</b><br/>
        <i>Social Summary Generator</i>
      </td>
      <td>
        Formats high-impact developer metrics into structured markdown text optimized for quick sharing on LinkedIn, X/Twitter, or technical portfolios.
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
│                   (Flutter 3 • Minimalist GitHub Dark Slate • Inter)                   │
│                                                                                        │
│   ┌───────────────────────────┐                     ┌──────────────────────────────┐   │
│   │        HomeScreen         │                     │      StatsDetailScreen       │   │
│   ├───────────────────────────┤                     ├──────────────────────────────┤   │
│   │ • Search Input Field      │                     │ • 24h Activity Histogram     │   │
│   │ • Bookmarked Profiles     │                     │ • Language Distribution Donut│   │
│   │ • GitHub Token Modal      │                     │ • Top Repositories Grid      │   │
│   │ • About & Build Telemetry │                     │ • Persona Badge & Telemetry  │   │
│   │ • Engineering Feeds       │                     │ • Commit Habit Banner        │   │
│   └─────────────┬─────────────┘                     └──────────────▲───────────────┘   │
└─────────────────┼──────────────────────────────────────────────────┼───────────────────┘
                  │ 1. Search Query (username)                       │ 5. Aggregated UI State
                  ▼                                                  │
┌────────────────────────────────────────────────────────────────────┴───────────────────┐
│                                   DOMAIN & LOGIC LAYER                                 │
│                                                                                        │
│   ┌────────────────────────────────────────────────────────────────────────────────┐   │
│   │                              UserStats Calculation Engine                      │   │
│   │  • Metric Aggregator (Total Stars, Forks, Repo Volume, Primary Languages)      │   │
│   │  • 24-Hour Event Binner (Converts ISO-8601 UTC to Local Time 00:00–23:00)      │   │
│   │  • Deterministic Persona Classifier (Star Magnet, Midnight Owl, Polyglot, etc.)│   │
│   └────────────────────────────────────────▲───────────────────────────────────────┘   │
└────────────────────────────────────────────┼───────────────────────────────────────────┘
                                             │ 4. Deserialized Models (User, Repos, Events)
┌────────────────────────────────────────────┴───────────────────────────────────────────┐
│                                  DATA & PERSISTENCE LAYER                              │
│                                                                                        │
│   ┌───────────────────────────────────┐            ┌───────────────────────────────┐   │
│   │         GitHubApiService          │            │        StorageService         │   │
│   ├───────────────────────────────────┤            ├───────────────────────────────┤   │
│   │ • GET /users/{username}           │            │ • SharedPreferences Engine    │   │
│   │ • GET /users/{username}/repos     │            │ • Persistent Bookmark Cache   │   │
│   │ • GET /users/{username}/events    │            │ • Sandboxed GitHub PAT Secret │   │
│   │ • Dual Rate Limit (60 vs 5,000/hr)│            │ • Offline-First Read Fallback │   │
│   └─────────────────┬─────────────────┘            └───────────────▲───────────────┘   │
└─────────────────────┼──────────────────────────────────────────────┼───────────────────┘
                      │ 2. HTTPS / TLS 1.3 Requests                  │ 3. Read / Write Cache
                      ▼                                              ▼
┌───────────────────────────────────────────┐  ┌─────────────────────────────────────────┐
│          GitHub REST API v3               │  │           Device Local Storage          │
│       (api.github.com Endpoints)          │  │        (Android Sandbox / Browser)      │
└───────────────────────────────────────────┘  └─────────────────────────────────────────┘
```

### Data Flow Lifecycle

1. **User Query**: The developer enters a GitHub handle on `HomeScreen`.
2. **Network Ingestion**: `GitHubApiService` orchestrates concurrent GET requests to GitHub REST API v3 (`/users`, `/repos`, and `/events`). If a Personal Access Token exists in `StorageService`, the request is sent with `Bearer` authorization.
3. **Model Deserialization**: JSON responses are deserialized into strongly-typed domain models (`GitHubUser`, `GitHubRepo`, and event payloads).
4. **On-Device Analytics**: `UserStats.calculate()` aggregates cumulative stars and forks, maps timestamps into 24-hour hourly bins adjusted to the device's local timezone, and evaluates developer persona traits.
5. **Reactive Presentation**: `StatsDetailScreen` renders charts via `fl_chart`, displays repository rankings, and allows the profile to be saved to offline storage via `StorageService`.

---

### Project Directory Structure

```text
gitpulse_mobile/
├── .github/
│   └── workflows/
│       └── build-apk.yml            # CI/CD pipeline for automated release APK builds
├── android/                         # Android platform host files (Gradle, Manifests)
├── lib/
│   ├── main.dart                    # Application entrypoint & global theme configuration
│   ├── localization/                # Multi-language internationalization support
│   │   ├── app_language.dart        # Supported language enums & locales
│   │   └── app_localizations.dart   # Localized string dictionaries (6 languages)
│   ├── models/                      # Domain entities & analytical computation engines
│   │   ├── bookmarked_user.dart     # Bookmarked profile serialization model
│   │   ├── contribution_stats.dart  # Event activity & contribution metrics model
│   │   ├── github_rate_limit.dart   # API rate-limit state tracking model
│   │   ├── github_repo.dart         # Repository schema deserializer
│   │   ├── github_user.dart         # User profile schema deserializer
│   │   ├── tech_news.dart           # Tech news item model
│   │   └── user_stats.dart          # Core telemetry calculation & persona engine
│   ├── screens/                     # UI screens & controllers
│   │   ├── home_screen.dart         # Minimalist search, bookmarks, news & version badge
│   │   └── stats_detail_screen.dart # Interactive analytics dashboard & charts
│   ├── services/                    # Networking & persistent storage layer
│   │   ├── app_language_service.dart# Language preference manager
│   │   ├── github_api_service.dart  # GitHub REST API v3 client with error handling
│   │   ├── storage_service.dart     # SharedPreferences persistence wrapper
│   │   └── tech_news_service.dart   # Curated tech news feed fetcher
│   ├── theme/                       # Design system tokens & application metadata
│   │   └── app_theme.dart           # Minimalist slate palette, typography & AppConfig
│   └── widgets/                     # Modular reusable UI components
│       ├── activity_chart.dart      # 24-hour activity bar chart (fl_chart)
│       ├── animated_tier_title.dart # Minimalist status badge component
│       ├── language_chart.dart      # Language distribution donut chart (fl_chart)
│       ├── repo_tile.dart           # GitHub native repository card
│       ├── settings_sheet.dart      # Modal sheet for settings, PAT token & About app
│       ├── stat_card.dart           # Minimalist summary metric card
│       └── tech_news_card.dart      # Engineering digest card widget
├── test/
│   └── widget_test.dart             # Unit, widget, model & version test suite
├── web/                             # Web/PWA deployment entrypoint
└── pubspec.yaml                     # Dependency manifest & version metadata (v1.0.1+2)
```

---

## Developer Persona Classification Matrix

The persona classification engine assigns a title based on the following deterministic priority order:

| Persona | Evaluation Criteria | Characteristic Profile |
| :--- | :--- | :--- |
| **Star Magnet** | `Total Stars >= 100` | Exceptional community impact with widely acknowledged open-source repositories. |
| **Polyglot Architect** | `Unique Languages >= 4` | Broad technological breadth across distinct ecosystems, languages, and paradigms. |
| **Midnight Owl Coder** | `Night Events (22:00–04:59) > Morning & Afternoon` | Highest engineering focus and productivity occur during late-night hours. |
| **Early Bird Developer** | `Morning Events (05:00–11:59) > Afternoon & Night` | Consistent early-morning execution rhythm with high-clarity morning commits. |
| **Prolific Builder** | `Total Public Repositories > 20` | High-output builder continuously creating, prototyping, and shipping code. |
| **Dedicated Craftsman** | *Default Fallback Condition* | Consistent, methodical contributor dedicated to quality software craftsmanship. |

---

## Security & Privacy Governance

GitPulse Mobile is engineered around a **Privacy-First** ethos:

1. **Direct Client-to-API Communication**: All HTTPS transactions occur directly between the user's device and official GitHub endpoints (`api.github.com`) using TLS 1.3. No third-party proxy or intermediary server is involved.
2. **Sandboxed Personal Access Token (PAT)**: Optional GitHub tokens are stored solely in the application's internal sandboxed storage (`shared_preferences`). Tokens are never sent to external telemetry servers or logged to console output in release builds.
3. **Least Privilege Enforcement**: The application operates exclusively with read permissions on public data. No write scopes or private repository permissions are requested.
4. **Zero Third-Party Telemetry**: Contains no third-party tracking scripts, advertising SDKs, or invasive user analytics.

---

## Technology Stack

| Category | Technology | Version | Architectural Purpose |
| :--- | :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | `>=3.24.0` | High-performance Ahead-Of-Time (AOT) cross-platform compilation for Android and Web |
| **Language** | [Dart](https://dart.dev) | `>=3.5.0` | Sound null-safety, pattern matching, and structured concurrency |
| **Visualization** | [fl_chart](https://pub.dev/packages/fl_chart) | `^1.2.0` | Hardware-accelerated vector charting engine with touch interactions |
| **Networking** | [http](https://pub.dev/packages/http) | `^1.6.0` | Robust composable HTTP client for RESTful API communication |
| **Typography** | [google_fonts](https://pub.dev/packages/google_fonts) | `^8.2.1` | Professional, high-legibility Inter font family |
| **Persistence** | [shared_preferences](https://pub.dev/packages/shared_preferences) | `^2.5.5` | Platform-native encrypted key-value storage abstraction |
| **Formatting** | [intl](https://pub.dev/packages/intl) | `^0.20.3` | ISO 8601 timezone manipulation and localized number formatting |
| **Deep Linking** | [url_launcher](https://pub.dev/packages/url_launcher) | `^6.3.2` | External browser navigation for repository links and articles |
| **Code Quality** | [flutter_lints](https://pub.dev/packages/flutter_lints) | `^6.0.0` | Official Flutter linter ruleset for idiomatic Dart standards |

---

## Installation & Getting Started

### Prerequisites
- **Flutter SDK**: Version `3.24.0` or higher
- **Dart SDK**: Version `3.5.0` or higher
- **Java Development Kit (JDK)**: OpenJDK 17 (Eclipse Temurin recommended)
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

This repository utilizes a two-tier GitHub Actions architecture separating automated quality gates from release binary publishing:

1. **Automated CI Quality Gate (`.github/workflows/ci.yml`)**:
   - Triggers on every push and pull request to `main` and `master`.
   - Runs `flutter pub get`, `flutter analyze` (zero lint warnings), and `flutter test` (100% test coverage).
   - **Does NOT build APKs on commit**, keeping CI execution under 25 seconds and preserving runner quotas.

2. **Manual Release Pipeline (`.github/workflows/release.yml`)**:
   - Triggered **manually via `workflow_dispatch`** only when you are ready to publish a new version.
   - Compiles **strictly 64-bit ARM APK** (`--target-platform android-arm64`, with `arm64-v8a` ABI filter).
   - Packages the artifact as `GitPulse-v1.0.1-arm64-v8a.apk` and calculates SHA-256 checksums (`.sha256`).
   - Automatically publishes the release to **GitHub Releases** and uploads the assets.

```text
┌────────────────────────────────────────────────────────────────────────┐
│              Manual Release Workflow (workflow_dispatch)               │
│                  (.github/workflows/release.yml)                       │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│   [Stage 1: Manual Trigger via GitHub Actions UI]                      │
│   └── Inputs: tag_name (e.g. v1.0.1), release_title, notes             │
│                                                                        │
│   [Stage 2: Verification & Quality Gate]                               │
│   ├── flutter analyze           ──► Static analysis (zero warnings)    │
│   └── flutter test              ──► 100% Unit test pass rate           │
│                                                                        │
│   [Stage 3: 64-bit Compilation & Optimization]                         │
│   └── flutter build apk --release --target-platform android-arm64      │
│       (Excludes legacy 32-bit & universal bloat; ~50% smaller APK)     │
│                                                                        │
│   [Stage 4: Checksum & Distribution]                                   │
│   ├── sha256sum GitPulse-v1.0.1-arm64-v8a.apk                          │
│   └── softprops/action-gh-release@v2                                   │
│       ├── Creates GitHub Release Tag                                   │
│       ├── Attaches GitPulse-v1.0.1-arm64-v8a.apk                       │
│       └── Attaches GitPulse-v1.0.1-arm64-v8a.apk.sha256                │
│                                                                        │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼
┌────────────────────────────────────────────────────────────────────────┐
│                       GitHub Releases Dashboard                        │
│            Production 64-bit APK ready for user downloads              │
└────────────────────────────────────────────────────────────────────────┘
```

### How to Trigger a Release Build:
1. Navigate to the **Actions** tab on GitHub.
2. Select **Release 64-bit APK** from the left sidebar.
3. Click **Run workflow**, verify the tag (e.g., `v1.0.1`), and click the green **Run workflow** button.
4. Once completed, your new APK will automatically appear under [Releases](https://github.com/zerabyte88/gitpulse_mobile/releases).

---

## Strategic Roadmap

- [x] Comprehensive cross-repo metric aggregation (Stars, Forks, Repos).
- [x] 24-hour developer productivity rhythm histogram.
- [x] Rule-based deterministic developer persona classification engine.
- [x] Top repository showcase sorted by star and fork volume.
- [x] Persistent local bookmarking & sandboxed Personal Access Token support.
- [x] Integrated real-time tech news feed.
- [x] **v1.0.1 UI/UX Overhaul**: Professional minimalist GitHub Dark & Linear aesthetic.
- [x] **In-App Build & Versioning**: `v1.0.1` (Build 2) telemetry on home bar and settings.
- [ ] **Visual Card Export**: Generate high-resolution PNG/SVG summary cards for social platforms.
- [ ] **Head-to-Head Compare**: Side-by-side productivity and language comparison between two developers.
- [ ] **Yearly Wrapped Recap**: Annual retrospective report summarizing annual coding habits.
- [ ] **Android Home Screen Widget**: Quick glance at productivity metrics via a native desktop widget.

---

## Contributing Guidelines

Contributions are welcome! Please follow these steps:

1. **Fork** the repository on GitHub.
2. Create a dedicated feature branch with semantic naming:
   ```bash
   git checkout -b feat/add-pr-merge-ratio-metric
   ```
3. Commit your changes adhering to **Conventional Commits**:
   ```bash
   git commit -m "feat(analytics): add PR merge velocity calculation"
   ```
4. Verify code quality and ensure all tests pass:
   ```bash
   flutter analyze && flutter test
   ```
5. Push to your branch and open a **Pull Request** with a detailed summary of your changes.

---

## License

This project is open-source software licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this project in accordance with the license conditions.
