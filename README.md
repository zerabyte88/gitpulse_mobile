# ⚡ GitPulse Mobile

<div align="center">

<p align="center">
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Flutter-Dark.svg" height="52" alt="Flutter" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Dart-Dark.svg" height="52" alt="Dart" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Github-Dark.svg" height="52" alt="GitHub" />
</p>

### Enterprise-Grade Developer Telemetry & Productivity Analytics

[![Release](https://img.shields.io/badge/Release-v1.0.0-blue?style=flat-square)](https://github.com/zerabyte88/gitpulse_mobile/releases)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.24.0-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.5.0-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-10B981?style=flat-square&logo=android&logoColor=white)](https://developer.android.com)
[![CI/CD Status](https://img.shields.io/badge/CI%2FCD-Passing-brightgreen?style=flat-square&logo=githubactions&logoColor=white)](.github/workflows/build-apk.yml)
[![Tests](https://img.shields.io/badge/Tests-Passing%20(100%25)-success?style=flat-square)](test/widget_test.dart)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Layered-orange?style=flat-square)](#-system-architecture--data-flow)
[![License](https://img.shields.io/badge/License-MIT-8B5CF6?style=flat-square)](LICENSE)

<p align="center">
  <b>GitPulse Mobile</b> is an open-source developer telemetry and productivity analytics mobile application built with Flutter. It transforms raw GitHub REST API v3 payloads into 24-hour work rhythm visualizations, cumulative portfolio impact metrics, and deterministic developer persona classifications—processed entirely on-device without third-party intermediary servers.
</p>

<p align="center">
  <a href="#-problem-statement--core-value">Problem Statement</a> •
  <a href="#-key-features">Key Features</a> •
  <a href="#-system-architecture--data-flow">Architecture & Data Flow</a> •
  <a href="#-developer-persona-classification-matrix">Persona Matrix</a> •
  <a href="#-security--privacy-governance">Security</a> •
  <a href="#-technology-stack">Tech Stack</a> •
  <a href="#-installation--getting-started">Installation</a> •
  <a href="#-cicd-pipeline--apk-distribution">CI/CD APK</a> •
  <a href="#-strategic-roadmap">Roadmap</a>
</p>

</div>

---

## 📌 Problem Statement & Core Value

The standard GitHub contribution graph ("green squares") displays daily activity frequency, but suffers from fundamental limitations:
- **Absence of Temporal Context**: It does not distinguish whether commits occur at midnight, early dawn, or during core business hours.
- **Fragmented Portfolio Impact**: Users must manually calculate aggregate stargazers and forks scattered across dozens of repositories.
- **Lack of Qualitative Profiling**: It fails to capture an engineer's architectural habits (e.g., deep focus within a single ecosystem vs. polyglot versatility).

**GitPulse Mobile** solves these gaps by aggregating public repository metadata, user profiles, and event streams into a unified, privacy-first, on-device intelligence dashboard.

---

## 🌟 Key Features

<table>
  <thead>
    <tr>
      <th width="45%">Feature</th>
      <th width="55%">Technical Specification</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <b>⚡ 24-Hour Productivity Rhythm</b><br/>
        <i>Peak Coding Hours Detection</i>
      </td>
      <td>
        Maps public event streams into an interactive 24-bar histogram using <code>fl_chart</code>. Automatically converts UTC timestamps to local device time to pinpoint when an engineer is most active in commits, PRs, and reviews.
      </td>
    </tr>
    <tr>
      <td>
        <b>🎭 Deterministic Developer Persona Engine</b><br/>
        <i>Rule-Based Qualitative Profiling</i>
      </td>
      <td>
        Evaluates quantitative telemetry against a deterministic heuristic matrix to classify developers into specialized professional personas (e.g., Star Magnet, Midnight Owl, Polyglot Architect).
      </td>
    </tr>
    <tr>
      <td>
        <b>📊 Language Footprint Distribution</b><br/>
        <i>Interactive Multi-Language Breakdown</i>
      </td>
      <td>
        Renders a donut chart illustrating primary programming languages across non-forked public repositories, weighted by repository size or codebase volume.
      </td>
    </tr>
    <tr>
      <td>
        <b>🔍 Consolidated Portfolio Aggregator</b><br/>
        <i>Cross-Repository Impact Metrics</i>
      </td>
      <td>
        Aggregates cumulative stargazers, total forks, public repository counts (original vs. forked), and follower ratios without external database dependencies.
      </td>
    </tr>
    <tr>
      <td>
        <b>🔖 Offline-First Local Cache & Bookmarks</b><br/>
        <i>Persistent State Management</i>
      </td>
      <td>
        Enables one-tap bookmarking of developer profiles into localized <code>shared_preferences</code> storage for instantaneous offline access without network latency.
      </td>
    </tr>
    <tr>
      <td>
        <b>🔑 Adaptive Dual Rate-Limiting Strategy</b><br/>
        <i>Anonymous vs. Authenticated Execution</i>
      </td>
      <td>
        Seamlessly alternates between anonymous requests (60 req/hr) and authenticated execution via GitHub Personal Access Tokens (5,000 req/hr), stored securely inside the application sandbox.
      </td>
    </tr>
    <tr>
      <td>
        <b>📰 Curated Tech News & Engineering Feeds</b><br/>
        <i>Real-Time Industry Intelligence</i>
      </td>
      <td>
        Integrates a live tech news stream directly inside the home screen, allowing developers to monitor ecosystem trends alongside GitHub activity.
      </td>
    </tr>
    <tr>
      <td>
        <b>📋 One-Click Shareable Telemetry</b><br/>
        <i>Social Summary Generator</i>
      </td>
      <td>
        Formats high-impact developer metrics into structured markdown text optimized for quick sharing on LinkedIn, X/Twitter, or technical portfolios.
      </td>
    </tr>
  </tbody>
</table>

---

## 🏛️ System Architecture & Data Flow

GitPulse Mobile follows **Clean Layered Architecture** principles to separate concerns, enforce testability, and isolate business logic from presentation and transport protocols:

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                   PRESENTATION LAYER                                   │
│                        (Flutter 3 • Material Design 3 • Slate Dark)                    │
│                                                                                        │
│   ┌───────────────────────────┐                     ┌──────────────────────────────┐   │
│   │        HomeScreen         │                     │      StatsDetailScreen       │   │
│   ├───────────────────────────┤                     ├──────────────────────────────┤   │
│   │ • Search Input Field      │                     │ • 24h Activity Histogram     │   │
│   │ • Bookmarked Profiles     │                     │ • Language Distribution Donut│   │
│   │ • GitHub Token Modal      │                     │ • Top Repositories Grid      │   │
│   │ • Tech News Feeds         │                     │ • Persona Badge & Telemetry  │   │
│   └─────────────┬─────────────┘                     └──────────────▲───────────────┘   │
└─────────────────┼──────────────────────────────────────────────────┼───────────────────┘
                  │ 1. Search Query (username)                       │ 5. Aggregated UI State
                  ▼                                                  │
┌────────────────────────────────────────────────────────────────────┴───────────────────┐
│                                   DOMAIN & LOGIC LAYER                                 │
│                                                                                        │
│   ┌────────────────────────────────────────────────────────────────────────────────┐   │
│   │                              UserStats Calculation Engine                      │   │
│   │  • Metric Aggregator (Total Stars, Forks, Repo Volume, Primary Languages)       │   │
│   │  • 24-Hour Event Binner (Converts ISO-8601 UTC to Local Time 00:00–23:00)       │   │
│   │  • Deterministic Persona Classifier (Star Magnet, Midnight Owl, Polyglot, etc.) │   │
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
│   ├── models/                      # Domain entities & analytical computation engines
│   │   ├── bookmarked_user.dart     # Bookmarked profile serialization model
│   │   ├── contribution_stats.dart  # Event activity & contribution metrics model
│   │   ├── github_rate_limit.dart   # API rate-limit state tracking model
│   │   ├── github_repo.dart         # Repository schema deserializer
│   │   ├── github_user.dart         # User profile schema deserializer
│   │   ├── tech_news.dart           # Tech news item model
│   │   └── user_stats.dart          # Core telemetry calculation & persona engine
│   ├── screens/                     # UI screens & controllers
│   │   ├── home_screen.dart         # Search interface, bookmarks, & PAT configuration
│   │   └── stats_detail_screen.dart # Interactive analytics dashboard & charts
│   ├── services/                    # Networking & persistent storage layer
│   │   ├── app_language_service.dart# Language preference manager
│   │   ├── github_api_service.dart  # GitHub REST API v3 client with error handling
│   │   ├── storage_service.dart     # SharedPreferences persistence wrapper
│   │   └── tech_news_service.dart   # Curated tech news feed fetcher
│   ├── theme/                       # Design system tokens
│   │   └── app_theme.dart           # Slate Midnight color palette & typography
│   └── widgets/                     # Modular reusable UI components
│       ├── activity_chart.dart      # 24-hour activity bar chart (fl_chart)
│       ├── animated_tier_title.dart # Animated persona badge component
│       ├── language_chart.dart      # Language distribution donut chart (fl_chart)
│       ├── repo_tile.dart           # Repository card with star and fork stats
│       ├── settings_sheet.dart      # Modal bottom sheet for settings & PAT token
│       ├── stat_card.dart           # Summary metric card with glassmorphism style
│       └── tech_news_card.dart      # News card widget for the home screen
├── test/
│   └── widget_test.dart             # Unit and widget test suite
├── web/                             # Web/PWA deployment entrypoint
└── pubspec.yaml                     # Dependency manifest & project metadata
```

---

## 🎯 Developer Persona Classification Matrix

The persona classification engine assigns a title based on the following deterministic priority order:

| Persona | Evaluation Criteria | Characteristic Profile |
| :--- | :--- | :--- |
| **🌟 Star Magnet** | `Total Stars >= 100` | Exceptional community impact with widely acknowledged open-source repositories. |
| **⚡ Polyglot Architect** | `Unique Languages >= 4` | Broad technological breadth across distinct ecosystems, languages, and paradigms. |
| **🦉 Midnight Owl Coder** | `Night Events (22:00–04:59) > Morning & Afternoon` | Highest engineering focus and productivity occur during late-night hours. |
| **🌅 Early Bird Developer** | `Morning Events (05:00–11:59) > Afternoon & Night` | Consistent early-morning execution rhythm with high-clarity morning commits. |
| **🚀 Prolific Builder** | `Total Public Repositories > 20` | High-output builder continuously creating, prototyping, and shipping code. |
| **💻 Dedicated Craftsman** | *Default Fallback Condition* | Consistent, methodical contributor dedicated to quality software craftsmanship. |

---

## 🔒 Security & Privacy Governance

GitPulse Mobile is engineered around a **Privacy-First** ethos:

1. **Direct Client-to-API Communication**: All HTTPS transactions occur directly between the user's device and official GitHub endpoints (`api.github.com`) using TLS 1.3. No third-party proxy or intermediary server is involved.
2. **Sandboxed Personal Access Token (PAT)**: Optional GitHub tokens are stored solely in the application's internal sandboxed storage (`shared_preferences`). Tokens are never sent to external telemetry servers or logged to console output in release builds.
3. **Least Privilege Enforcement**: The application operates exclusively with read permissions on public data. No write scopes or private repository permissions are requested.
4. **Zero Third-Party Telemetry**: Contains no third-party tracking scripts, advertising SDKs, or invasive user analytics.

---

## 🛠️ Technology Stack

| Category | Technology | Version | Architectural Purpose |
| :--- | :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | `>=3.24.0` | High-performance Ahead-Of-Time (AOT) cross-platform compilation for Android and Web |
| **Language** | [Dart](https://dart.dev) | `>=3.5.0` | Sound null-safety, pattern matching, and structured concurrency |
| **Visualization** | [fl_chart](https://pub.dev/packages/fl_chart) | `^1.2.0` | Hardware-accelerated vector charting engine with touch interactions |
| **Networking** | [http](https://pub.dev/packages/http) | `^1.6.0` | Robust composable HTTP client for RESTful API communication |
| **Typography** | [google_fonts](https://pub.dev/packages/google_fonts) | `^8.2.1` | Modern, high-legibility Outfit font family |
| **Persistence** | [shared_preferences](https://pub.dev/packages/shared_preferences) | `^2.5.5` | Platform-native encrypted key-value storage abstraction |
| **Formatting** | [intl](https://pub.dev/packages/intl) | `^0.20.3` | ISO 8601 timezone manipulation and localized number formatting |
| **Deep Linking** | [url_launcher](https://pub.dev/packages/url_launcher) | `^6.3.2` | External browser navigation for repository links and articles |
| **Code Quality** | [flutter_lints](https://pub.dev/packages/flutter_lints) | `^6.0.0` | Official Flutter linter ruleset for idiomatic Dart standards |

---

## 💻 Installation & Getting Started

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
   * For Google Chrome (Web):
     ```bash
     flutter run -d chrome
     ```
   * For Android Device / Emulator:
     ```bash
     flutter run -d android
     ```

5. **Build Release APK**:
   ```bash
   flutter build apk --release
   # Compiled binary output: build/app/outputs/flutter-apk/app-release.apk
   ```

---

## 🤖 CI/CD Pipeline & APK Distribution

This repository features an automated **GitHub Actions** CI/CD pipeline (`.github/workflows/build-apk.yml`) triggered on every push and pull request to `main` and `master`:

```text
┌──────────────────────┐
│  Developer Git Push  │  ──► Branch: main, master, or Pull Request
└──────────┬───────────┘
           │
           ▼
┌────────────────────────────────────────────────────────────────────────┐
│                  GitHub Actions CI/CD Pipeline                         │
│                    (.github/workflows/build-apk.yml)                   │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│   [Stage 1: Environment Provisioning]                                  │
│   ├── VM Runner: Ubuntu Latest                                         │
│   ├── actions/checkout@v4                                              │
│   ├── actions/setup-java@v4 (Eclipse Temurin JDK 17)                   │
│   └── subosito/flutter-action@v2 (Flutter Stable with caching)         │
│                                                                        │
│   [Stage 2: Code Verification & Quality Gate]                          │
│   ├── flutter pub get           ──► Resolve & lock dependency graph    │
│   ├── flutter analyze           ──► Static analysis (zero warnings)    │
│   └── flutter test              ──► 100% Unit test pass rate           │
│                                                                        │
│   [Stage 3: Compilation & Optimization]                                │
│   └── flutter build apk --release ──► Tree-shaking, AOT ARM64 binary   │
│                                                                        │
│   [Stage 4: Artifact Distribution]                                     │
│   └── actions/upload-artifact@v4                                       │
│       └── Output: GitPulse-Android-APK (app-release.apk)               │
│                                                                        │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼
┌────────────────────────────────────────────────────────────────────────┐
│                           Release Artifact                             │
│       Downloadable Production APK ready for deployment & install       │
└────────────────────────────────────────────────────────────────────────┘
```

### How to Download the Latest APK Build:
1. Navigate to the [Actions tab](https://github.com/zerabyte88/gitpulse_mobile/actions) on GitHub.
2. Select the latest successful run of the **Build & Release GitPulse APK** workflow.
3. Scroll down to the **Artifacts** section at the bottom of the page.
4. Click **GitPulse-Android-APK** to download the pre-compiled `.apk` bundle.
5. Extract the ZIP archive and install `app-release.apk` on your Android device.

---

## 🗺️ Strategic Roadmap

- [x] Comprehensive cross-repo metric aggregation (Stars, Forks, Repos).
- [x] 24-hour developer productivity rhythm histogram.
- [x] Rule-based deterministic developer persona classification engine.
- [x] Top repository showcase sorted by star and fork volume.
- [x] Persistent local bookmarking & sandboxed Personal Access Token support.
- [x] Integrated real-time tech news feed.
- [ ] **Visual Card Export**: Generate high-resolution PNG/SVG summary cards for social platforms.
- [ ] **Head-to-Head Compare**: Side-by-side productivity and language comparison between two developers.
- [ ] **Yearly Wrapped Recap**: Annual retrospective report summarizing annual coding habits.
- [ ] **Android Home Screen Widget**: Quick glance at productivity metrics via a native desktop widget.

---

## 🤝 Contributing Guidelines

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

## 📄 License

This project is open-source software licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this project in accordance with the license conditions.

