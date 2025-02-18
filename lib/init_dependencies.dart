import 'package:blog_post_using_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_post_using_clean_architecture/core/network/connection_checker.dart';
import 'package:blog_post_using_clean_architecture/core/secrets/app_secret.dart';
import 'package:blog_post_using_clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_post_using_clean_architecture/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/usecase/current_user.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/usecase/user_login.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/usecase/user_signup.dart';
import 'package:blog_post_using_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_post_using_clean_architecture/features/blog/data/data_souce/blog_remote_data_source.dart';
import 'package:blog_post_using_clean_architecture/features/blog/data/data_souce/local_data_source.dart';
import 'package:blog_post_using_clean_architecture/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/usecases/get_all_blog.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_post_using_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supaBase = await Supabase.initialize(
    // url: AppSecret.supabaseUrl,
    // anonKey: AppSecret.apiKey,

    url: (dotenv.env['SUPABASEURL']).toString(),
    anonKey: (dotenv.env['APIKEY']).toString(),
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton<SupabaseClient>(
    () => supaBase.client,
  );

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      internetConnection: serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Data Source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()),
    )

    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        connectionChecker: serviceLocator(),
        authRemoteDataSource: serviceLocator(),
      ),
    )
    // Authentication Usecase
    ..registerFactory(
      () => UserSignup(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        authRepository: serviceLocator(),
      ),
    )

    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        signup: serviceLocator(),
        login: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  // Data Source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        box: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
        blogLocalDataSource: serviceLocator(),
      ),
    )
    // Blog Usecase
    ..registerFactory(
      () => UploadBlog(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlog(
        blogRepository: serviceLocator(),
      ),
    )
    // Blog Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
