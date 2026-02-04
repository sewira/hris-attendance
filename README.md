# HR Attendance

A Flutter application for employee attendance clock-in/clock-out management built with Clean Architecture and GetX.

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Architecture

This project follows **Clean Architecture** with **GetX** state management.

```
lib/
├── main.dart
├── app.dart
├── config/
│   ├── bindings/          # Global dependency injection
│   ├── routes/            # Route definitions
│   ├── endpoints/         # API endpoint constants
│   └── theme/             # App theming
├── core/
│   ├── base/              # Base classes (BaseUsecase, NoParams)
│   ├── error/             # Failure classes
│   ├── network/           # Dio client, API exceptions
│   └── utils/             # Storage, extensions
├── features/
│   └── <feature>/
│       ├── data/
│       │   ├── models/        # Data models
│       │   └── datasources/   # API calls (implements repository)
│       ├── domain/
│       │   ├── repositories/  # Abstract interfaces
│       │   └── usecases/      # Business logic
│       └── presentation/
│           ├── bindings/      # Feature DI
│           ├── controllers/   # GetX controllers
│           ├── screens/       # UI screens
│           └── widgets/       # Feature widgets
└── shared/
    └── widgets/               # Shared UI components
```

## Key Concepts

### Usecase Parameters

| Parameters | Approach |
|------------|----------|
| 0 | Use `NoParams` |
| 1 | Pass directly (e.g., `String`) |
| 2+ | Create a params class |

### Dependency Injection

- **Global services**: Register in `GlobalBinding` with `Get.put(..., permanent: true)`
- **Feature services**: Register in feature binding with `Get.lazyPut()`

### Error Handling

Uses `Either<Failure, T>` from dartz:
```dart
result.fold(
  (failure) => handleError(failure.message),
  (data) => handleSuccess(data),
);
```

## Configuration

Update API base URL in `lib/config/endpoints/api_endpoints.dart`:
```dart
static const String baseUrl = 'https://your-api-url.com';
```

## Features

- [x] Attendance clock-in/clock-out
- [ ] Authentication
- [ ] Attendance history
- [ ] Employee management

## Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Dartz Package](https://pub.dev/packages/dartz)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
