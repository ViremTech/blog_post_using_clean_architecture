import 'package:blog_post_using_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_post_using_clean_architecture/core/theme/theme.dart';
import 'package:blog_post_using_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_post_using_clean_architecture/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_post_using_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_post_using_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_post_using_clean_architecture/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<BlogBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoadedIn) {
          if (isLoadedIn) {
            return BlogPage();
          } else {
            return SigninPage();
          }
        },
      ),
    );
  }
}
