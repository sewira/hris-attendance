import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class BaseUsecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
