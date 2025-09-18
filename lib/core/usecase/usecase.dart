import 'package:blog/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

// use cases in simple it is represent the return type of the operation

/*
  @ Any use case must implement a call() method that takes some input (Params)
    and returns a Future<Type>
*/

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}