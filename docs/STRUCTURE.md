# Intern Task: Flutter Clean Architecture Project

## Objective

Build a simple Flutter application using **Clean Architecture** with **GetX** state management. This task will help you understand how production-ready Flutter apps are structured.

---

## Project: Simple Product Catalog App

Create a product catalog app with the following features:
1. **Product List**: Display a list of products from a public API
2. **Product Detail**: Show product details when tapping on a product
3. **Favorites**: Add/remove products to favorites (local storage)

---

## API to Use

Use the free **Fake Store API**: https://fakestoreapi.com

Endpoints:
- `GET /products` - Get all products
- `GET /products/{id}` - Get single product
- `GET /products/categories` - Get all categories
- `GET /products/category/{category}` - Get products by category

---

## Project Structure

Create this folder structure:

```
lib/
├── main.dart
├── app.dart                           # Root GetMaterialApp
│
├── config/
│   ├── routes/
│   │   └── app_routes.dart            # All route definitions
│   ├── endpoints/
│   │   └── api_endpoints.dart         # API endpoint constants
│   └── theme/
│       └── app_theme.dart             # App theming
│
├── core/
│   ├── base/
│   │   └── base_usecase.dart          # Base class for usecases
│   ├── network/
│   │   ├── dio_client.dart            # Dio configuration
│   │   └── api_exception.dart         # Exception handling
│   ├── error/
│   │   └── failure.dart               # Failure classes
│   └── utils/
│       ├── app_storage.dart           # Local storage helper
│       └── extensions.dart            # Extension methods
│
├── features/
│   ├── product/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── product_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── product_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── product_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── product_repository.dart   # Abstract
│   │   │   └── usecases/
│   │   │       ├── get_products_usecase.dart
│   │   │       └── get_product_detail_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── bindings/
│   │       │   ├── product_list_binding.dart
│   │       │   └── product_detail_binding.dart
│   │       ├── controllers/
│   │       │   ├── product_list_controller.dart
│   │       │   └── product_detail_controller.dart
│   │       ├── screens/
│   │       │   ├── product_list_screen.dart
│   │       │   └── product_detail_screen.dart
│   │       └── widgets/
│   │           └── product_card.dart
│   │
│   └── favorite/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── favorite_local_datasource.dart
│       │   └── repositories/
│       │       └── favorite_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── repositories/
│       │   │   └── favorite_repository.dart
│       │   └── usecases/
│       │       ├── add_favorite_usecase.dart
│       │       ├── remove_favorite_usecase.dart
│       │       └── get_favorites_usecase.dart
│       │
│       └── presentation/
│           ├── bindings/
│           │   └── favorite_binding.dart
│           ├── controllers/
│           │   └── favorite_controller.dart
│           └── screens/
│               └── favorite_screen.dart
│
└── shared/
    └── widgets/
        ├── loading_widget.dart
        └── error_widget.dart
```

---

## Dependencies

Add these to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                 # State management & routing
  dio: ^5.4.0                 # HTTP client
  dartz: ^0.10.1              # Functional programming (Either type)
  get_storage: ^2.1.1         # Local storage
  cached_network_image: ^3.3.0  # Image caching

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## Code Examples

### 1. Base Usecase (`core/base/base_usecase.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class BaseUsecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
```

### 2. Failure Class (`core/error/failure.dart`)

```dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
```

### 3. Dio Client (`core/network/dio_client.dart`)

```dart
import 'package:dio/dio.dart';

class DioClient {
  static DioClient? _instance;
  late Dio dio;

  DioClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for logging (optional)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }
}
```

### 4. Product Model (`features/product/data/models/product_model.dart`)

```dart
class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: RatingModel.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
    };
  }
}

class RatingModel {
  final double rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}
```

### 5. Repository Interface (`features/product/domain/repositories/product_repository.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, ProductModel>> getProductById(int id);
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(String category);
}
```

### 6. Remote Datasource (`features/product/data/datasources/product_remote_datasource.dart`)

```dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final Dio _dio = DioClient.instance.dio;

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _dio.get('/products');
    final List<dynamic> data = response.data;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await _dio.get('/products/$id');
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await _dio.get('/products/category/$category');
    final List<dynamic> data = response.data;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
```

### 7. Repository Implementation (`features/product/data/repositories/product_repository_impl.dart`)

```dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final result = await remoteDatasource.getProducts();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(int id) async {
    try {
      final result = await remoteDatasource.getProductById(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
      String category) async {
    try {
      final result = await remoteDatasource.getProductsByCategory(category);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### 8. Usecase (`features/product/domain/usecases/get_products_usecase.dart`)

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/product_model.dart';
import '../repositories/product_repository.dart';

class GetProductsUsecase extends BaseUsecase<List<ProductModel>, NoParams> {
  final ProductRepository repository;

  GetProductsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ProductModel>>> call(NoParams params) {
    return repository.getProducts();
  }
}
```

### 9. Controller (`features/product/presentation/controllers/product_list_controller.dart`)

```dart
import 'package:get/get.dart';
import '../../../../core/base/base_usecase.dart';
import '../../data/models/product_model.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductListController extends GetxController {
  final GetProductsUsecase _getProductsUsecase;

  ProductListController({required GetProductsUsecase getProductsUsecase})
      : _getProductsUsecase = getProductsUsecase;

  // State
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getProductsUsecase.call(NoParams());

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (data) {
        products.value = data;
        isLoading.value = false;
      },
    );
  }

  void goToDetail(int productId) {
    Get.toNamed('/product/$productId');
  }
}
```

### 10. Binding (`features/product/presentation/bindings/product_list_binding.dart`)

```dart
import 'package:get/get.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../controllers/product_list_controller.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    // Register datasource
    Get.lazyPut<ProductRemoteDatasource>(
      () => ProductRemoteDatasourceImpl(),
    );

    // Register repository
    Get.lazyPut(
      () => ProductRepositoryImpl(
        remoteDatasource: Get.find<ProductRemoteDatasource>(),
      ),
    );

    // Register usecase
    Get.lazyPut(
      () => GetProductsUsecase(
        repository: Get.find<ProductRepositoryImpl>(),
      ),
    );

    // Register controller
    Get.lazyPut(
      () => ProductListController(
        getProductsUsecase: Get.find<GetProductsUsecase>(),
      ),
    );
  }
}
```

### 11. Screen (`features/product/presentation/screens/product_list_screen.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_list_controller.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.toNamed('/favorites'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchProducts,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return ProductCard(
                product: product,
                onTap: () => controller.goToDetail(product.id),
              );
            },
          ),
        );
      }),
    );
  }
}
```

### 12. Routes (`config/routes/app_routes.dart`)

```dart
import 'package:get/get.dart';
import '../../features/product/presentation/bindings/product_list_binding.dart';
import '../../features/product/presentation/bindings/product_detail_binding.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/favorite/presentation/bindings/favorite_binding.dart';
import '../../features/favorite/presentation/screens/favorite_screen.dart';

abstract class AppRoutes {
  static const productList = '/products';
  static const productDetail = '/product/:id';
  static const favorites = '/favorites';
}

final List<GetPage> appPages = [
  GetPage(
    name: AppRoutes.productList,
    page: () => const ProductListScreen(),
    binding: ProductListBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.productDetail,
    page: () => const ProductDetailScreen(),
    binding: ProductDetailBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: AppRoutes.favorites,
    page: () => const FavoriteScreen(),
    binding: FavoriteBinding(),
    transition: Transition.rightToLeft,
  ),
];
```

### 13. Main App (`app.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.productList,
      getPages: appPages,
    );
  }
}
```

### 14. Main Entry (`main.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await GetStorage.init();

  runApp(const App());
}
```

---

## Tasks Checklist

### Phase 1: Setup (Day 1)
- [ ] Create new Flutter project
- [ ] Add dependencies to `pubspec.yaml`
- [ ] Create folder structure
- [ ] Setup Dio client
- [ ] Create base classes (BaseUsecase, Failure)

### Phase 2: Product Feature (Day 2-3)
- [ ] Create ProductModel
- [ ] Create ProductRepository (abstract)
- [ ] Create ProductRemoteDatasource
- [ ] Create ProductRepositoryImpl
- [ ] Create GetProductsUsecase
- [ ] Create GetProductDetailUsecase
- [ ] Create ProductListController
- [ ] Create ProductDetailController
- [ ] Create ProductListBinding
- [ ] Create ProductDetailBinding
- [ ] Create ProductListScreen
- [ ] Create ProductDetailScreen
- [ ] Create ProductCard widget

### Phase 3: Favorite Feature (Day 4)
- [ ] Create FavoriteLocalDatasource (using GetStorage)
- [ ] Create FavoriteRepository (abstract)
- [ ] Create FavoriteRepositoryImpl
- [ ] Create AddFavoriteUsecase
- [ ] Create RemoveFavoriteUsecase
- [ ] Create GetFavoritesUsecase
- [ ] Create FavoriteController
- [ ] Create FavoriteBinding
- [ ] Create FavoriteScreen

### Phase 4: Polish (Day 5)
- [ ] Add loading states
- [ ] Add error handling UI
- [ ] Add pull-to-refresh
- [ ] Style the app (colors, fonts)
- [ ] Test all features

---

## Key Concepts to Understand

1. **Clean Architecture Layers**:
   - **Data Layer**: Deals with external data (API, database)
   - **Domain Layer**: Business logic, independent of frameworks
   - **Presentation Layer**: UI and state management

2. **Dependency Direction**:
   - Outer layers depend on inner layers
   - Domain layer has NO dependencies on data or presentation
   - Data layer implements domain interfaces

3. **Either Type (dartz)**:
   - `Either<Left, Right>` represents success OR failure
   - `Left` = Failure case
   - `Right` = Success case
   - Use `.fold()` to handle both cases

4. **GetX Reactive State**:
   - `Rx<T>` for reactive variables
   - `.obs` to make variables observable
   - `Obx()` widget rebuilds when observables change
   - `.value` to get/set the actual value

5. **Dependency Injection with Bindings**:
   - Bindings register dependencies when route is accessed
   - `Get.lazyPut()` creates instance when first needed
   - `Get.find()` retrieves registered instance

---

## Submission Requirements

1. GitHub repository with complete code
2. README.md explaining:
   - How to run the project
   - Architecture overview
   - Screenshots of the app
3. Demo video showing all features working

---

## Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Dartz Package](https://pub.dev/packages/dartz)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Fake Store API Docs](https://fakestoreapi.com/docs)

---

## Questions?

If you have any questions about the task or architecture, feel free to ask your mentor.

Good luck!
