import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:blog_post_using_clean_architecture/core/usecase/usecase.dart';
import 'package:blog_post_using_clean_architecture/core/common/entities/user.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup implements Usecase<User, UserSignupParams> {
  final AuthRepository authRepository;

  UserSignup({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailPassWord(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String email;
  final String password;
  final String name;

  UserSignupParams(
      {required this.email, required this.password, required this.name});
}
