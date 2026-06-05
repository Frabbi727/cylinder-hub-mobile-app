# Cylinder Hub Mobile App

A professional, scalable Flutter project built with **GetX**, following **MVVM** and **SOLID** principles. This project is designed for high maintainability, featuring centralized API handling, multi-environment support, and real-time connectivity monitoring.

## 🚀 Key Features

- **Architecture**: MVVM (Model-View-ViewModel) + SOLID Principles.
- **State Management**: GetX (Reactive approach).
- **Network Layer**: Centralized `Dio` client with interceptors for logging, tokens, and error handling.
- **Environments**: Multi-environment setup (`dev`, `staging`, `prod`) with separate base URLs.
- **Theme**: Global light/dark mode support with persistent storage.
- **Localization**: Multi-language support (English & Bangla) with persistent storage.
- **Connectivity**: Real-time "No Internet" monitoring with global UI warning.
- **Navigation**: Structured routing with custom Bottom Navigation and Smart Back Button logic.

---

## 📂 Project Structure

```text
lib/
├── app/
│   ├── core/               # Global configurations
│   │   ├── base/           # Abstract BaseController & BaseRepository
│   │   ├── services/       # Persistent services (Connectivity, etc.)
│   │   ├── theme/          # Centralized light/dark theme data
│   │   └── values/         # App constants, sizes, colors, and translations
│   ├── data/               # Data layer
│   │   ├── api/            # ApiClient, Endpoints, NetworkExceptions
│   │   ├── local/          # Local storage (TokenManager)
│   │   └── models/         # Standard API Response & Pagination models
│   ├── modules/            # Feature-based modules
│   │   └── [feature_name]/
│   │       ├── bindings/   # Dependency injection
│   │       ├── controllers/# Business logic (ViewModel)
│   │       ├── repository/ # Data fetching
│   │       └── views/      # UI (View)
│   └── routes/             # App routing configuration
├── main_common.dart        # Shared entry point logic
├── main_dev.dart           # Development entry point
├── main_staging.dart       # Staging entry point
└── main_prod.dart          # Production entry point
```

---

## ⚙️ Configuration & Constants

To ensure security and maintainability, all configurations are centralized in specific files:

### 1. Environment & Base URLs
- **File**: `lib/app/core/values/constants.dart`
    - Contains `devBaseUrl`, `stagingBaseUrl`, and `prodBaseUrl`.
- **File**: `lib/app/core/values/app_env.dart`
    - Contains the `AppConfig` class which holds the active environment configuration (URL, Title, API Keys).
- **Entry Points**: 
    - `lib/main_dev.dart`
    - `lib/main_staging.dart`
    - `lib/main_prod.dart`
    - *These files inject the correct URL from `Constants` into `AppConfig` at startup.*

### 2. API Endpoints
- **File**: `lib/app/data/api/endpoints.dart`
    - All API paths (e.g., `/auth/login`, `/user/profile`) must be defined here as `static const` strings. **Never hardcode paths in repositories.**

### 3. UI Constants (Theming)
- **Colors**: `lib/app/core/values/app_colors.dart`
    - Centralized palette for brand, background, text (light/dark), and status colors.
- **Sizes**: `lib/app/core/values/app_sizes.dart`
    - Standardized padding, margins, font sizes, and icon sizes.
- **Theme Data**: `lib/app/core/theme/app_theme.dart`
    - Configures global `ThemeData` for Light and Dark modes using the colors and sizes above.

### 4. Localization & Keys
- **Translation Keys**: `lib/app/core/values/languages/translation_keys.dart`
    - Contains `static const` strings for all UI text. This allows for **Command+Click** navigation to definitions.
- **Language Files**: 
    - `lib/app/core/values/languages/en_us.dart` (English)
    - `lib/app/core/values/languages/bn_bd.dart` (Bangla)

---

## 🛠 Setup & Running

### 1. Prerequisites
- Flutter SDK (Recommended: `^3.10.7`)
- Dart SDK

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
Choose the environment you want to run:
- **Development**: `flutter run -t lib/main_dev.dart`
- **Staging**: `flutter run -t lib/main_staging.dart`
- **Production**: `flutter run -t lib/main_prod.dart`

### 4. Build Release
Generate a release APK for the production environment:
```bash
flutter build apk --release -t lib/main_prod.dart
```

---

## 🏗 Technical Architecture

### 1. Base Classes
Every feature module follows a strict inheritance:
- **`BaseController`**: Inherits `GetxController`. Handles `isLoading`, `errorMessage`, `toggleTheme()`, `toggleLanguage()`, and `currentLanguage` state.
- **`BaseRepository`**: Provides a shared instance of `ApiClient`.

### 2. API Management (`ApiClient`)
- **Interceptors**: 
    - `Request`: Automatically attaches Bearer Tokens from `TokenManager`.
    - `Response`: Logs pretty-printed JSON output using the `Logger` package.
    - `Error`: Maps Dio/HTTP errors to user-friendly messages via `NetworkException`.

### 3. Connectivity Monitoring
- **Service**: `lib/app/core/services/connectivity_service.dart`
- **UI**: A global "No Internet" banner is managed in the `builder` of `main_common.dart`, floating above all views when offline.

---

## 📝 Best Practices
1. **Separation of Concerns**: UI stays in `Views`, logic in `Controllers`, and data fetching in `Repositories`.
2. **Global Navigation**: Use `Get.offAllNamed(Routes.NAME)` for auth-related transitions.
3. **Reactive UI**: Use `Obx(() => ...)` only for the smallest widget that needs to update.
4. **Smart Back Button**: The `MainNavigationView` uses `PopScope` to ensure the back button returns to the "My Day" tab before exiting the app.




### dart run build_runner build --force-jit --delete-conflicting-outputs
