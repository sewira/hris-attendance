# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter HR Attendance application using **Clean Architecture** with **GetX** state management. The project is currently in the scaffolding phase with planned architecture documented in `docs/STRUCTURE.md`.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run                  # Default device
flutter run -d chrome        # Web
flutter run -d <device_id>   # Specific device

# Build
flutter build apk            # Android
flutter build ios            # iOS
flutter build web            # Web

# Code quality
dart analyze                 # Static analysis
dart format lib/             # Format code
dart fix --apply             # Apply fixes

# Testing
flutter test                 # All tests
flutter test test/path       # Specific test
flutter test --coverage      # With coverage

# Clean
flutter clean
```

## Architecture

The project follows **Clean Architecture** with three layers:

```
lib/
├── main.dart
├── app.dart                    # Root GetMaterialApp
├── config/
│   ├── routes/                 # Route definitions
│   ├── endpoints/              # API constants
│   └── theme/                  # App theming
├── core/
│   ├── base/                   # Base usecase class
│   ├── network/                # Dio client, exceptions
│   ├── error/                  # Failure classes
│   └── utils/                  # Storage, extensions
├── features/
│   └── <feature>/
│       ├── data/
│       │   ├── models/         # Data models with fromJson/toJson
│       │   ├── datasources/    # Remote/local data sources
│       │   └── repositories/   # Repository implementations
│       ├── domain/
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Abstract repository interfaces
│       │   └── usecases/       # Business logic
│       └── presentation/
│           ├── bindings/       # GetX dependency injection
│           ├── controllers/    # GetX controllers
│           ├── screens/        # UI screens
│           └── widgets/        # Feature-specific widgets
└── shared/
    └── widgets/                # Shared UI components
```

## Key Patterns

### State Management (GetX)
- Use `.obs` for reactive state variables
- Controllers extend `GetxController`
- `Obx()` widgets rebuild on state changes
- `Get.lazyPut()` for lazy dependency injection in bindings

### Error Handling
- Use `Either<Failure, T>` from dartz for result types
- Handle with `.fold((failure) => ..., (success) => ...)`
- Custom `Failure` classes: `ServerFailure`, `CacheFailure`, `NetworkFailure`

### Dependency Injection
- Each feature has bindings that register datasources, repositories, usecases, and controllers
- Dependencies are resolved per-route via GetX bindings

## Dependencies

```yaml
dependencies:
  get: ^4.6.6                    # State management & routing
  dio: ^5.4.0                    # HTTP client
  dartz: ^0.10.1                 # Functional programming (Either type)
  get_storage: ^2.1.1            # Local storage
  cached_network_image: ^3.3.0   # Image caching
  intl: ^0.19.0                  # Date/time formatting
```

## Current Features

### Attendance Feature
- Clock in/out functionality with `ClockInUsecase` and `ClockOutUsecase`
- Today's attendance display via `GetTodayAttendanceUsecase`
- Attendance history via `GetAttendanceHistoryUsecase`
- API endpoints defined in `lib/config/endpoints/api_endpoints.dart` (update baseUrl for your backend)

## Development Notes

- See `docs/STRUCTURE.md` for detailed architecture guide and code examples
- Update `ApiEndpoints.baseUrl` in `lib/config/endpoints/api_endpoints.dart` to point to your backend
- Replace hardcoded `employeeId` in `AttendanceController` with actual auth implementation
- Domain layer must have no dependencies on data or presentation layers
- Data layer implements domain interfaces
- Outer layers depend on inner layers (dependency inversion)
