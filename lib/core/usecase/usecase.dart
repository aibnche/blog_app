import 'package:blog/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

// use cases in simple it is represent the return type of the operation
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}