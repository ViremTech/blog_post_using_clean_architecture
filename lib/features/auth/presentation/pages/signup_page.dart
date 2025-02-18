import 'package:blog_post_using_clean_architecture/core/common/widget/loader.dart';
import 'package:blog_post_using_clean_architecture/core/utils/show_snackbar.dart';
import 'package:blog_post_using_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_post_using_clean_architecture/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_post_using_clean_architecture/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_post_using_clean_architecture/features/auth/presentation/widgets/auth_griedient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../blog/presentation/pages/blog_page.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
          builder: (
        context,
      ) =>
              SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return Loader();
              } else if (state is AuthSuccess) {
                Navigator.pushAndRemoveUntil(
                    context, BlogPage.route(), (route) => false);
              }

              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up.',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    AuthField(
                      hintText: 'Name',
                      controller: nameController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      hintText: 'Email',
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      obscureText: true,
                      hintText: 'Password',
                      controller: passwordController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthGriedientButton(
                      text: 'Sign Up',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                AuthSignUp(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, SigninPage.route());
                      },
                      child: RichText(
                        text: TextSpan(
                          text: ' Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
