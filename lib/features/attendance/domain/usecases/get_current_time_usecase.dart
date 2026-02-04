import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failure.dart';

/// Example usecase with no parameters.
/// Returns current server time.
class GetCurrentTimeUsecase extends BaseUsecase<DateTime, NoParams> {
  GetCurrentTimeUsecase();

  @override
  Future<Either<Failure, DateTime>> call(NoParams params) async {
    try {
      // Example: could fetch from server
      // For now, just return local time
      return Right(DateTime.now());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
