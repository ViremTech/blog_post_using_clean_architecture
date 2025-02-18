import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:blog_post_using_clean_architecture/core/network/connection_checker.dart';
import 'package:blog_post_using_clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_post_using_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:blog_post_using_clean_architecture/core/common/entities/user.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/error/exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ConnectionChecker connectionChecker;
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({
    required this.connectionChecker,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> loginUpWithEmailPassWord(
      {required String email, required String password}) async {
    return _getUser(
      () async => await authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailPassWord(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, UserModel>> _getUser(
      Future<UserModel> Function() fn) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No Internet connection'));
      }
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = authRemoteDataSource.currentUserSession;

        if (session == null) {
          return left(
            Failure(
              'User not logged in',
            ),
          );
        }

        return right(UserModel(
            id: session.user.id,
            email: (session.user.email).toString(),
            name: ''));
      }
      final user = await authRemoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(
          Failure('User not logged in !'),
        );
      }
      return right(user);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.message,
        ),
      );
    }
  }
}
