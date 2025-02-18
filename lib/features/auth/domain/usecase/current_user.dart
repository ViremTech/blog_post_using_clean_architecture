import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:blog_post_using_clean_architecture/core/usecase/usecase.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
