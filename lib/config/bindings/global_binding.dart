import 'package:get/get.dart';
import '../../core/network/dio_client.dart';

/// Global dependencies that are shared across all features.
/// These are initialized once at app startup.
class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Network client - singleton available everywhere
    Get.put(DioClient.instance, permanent: true);

    // Add other global services here:
    // Get.put(AuthService(), permanent: true);
    // Get.put(LoggingService(), permanent: true);
    // Get.put(AnalyticsService(), permanent: true);
  }
}
