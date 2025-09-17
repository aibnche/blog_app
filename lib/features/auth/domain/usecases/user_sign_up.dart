import 'package:blog/core/error/failure.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/core/common/entities/user.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class UserSignUp implements UseCase<User, UserSignUpParams>{
  final AuthRepository authRepository;

  UserSignUp({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.singUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}