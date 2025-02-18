import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:blog_post_using_clean_architecture/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassWord({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginUpWithEmailPassWord({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
