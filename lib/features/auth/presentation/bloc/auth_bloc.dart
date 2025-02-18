import 'package:blog_post_using_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';

import 'package:blog_post_using_clean_architecture/core/usecase/usecase.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/usecase/user_login.dart';
import 'package:blog_post_using_clean_architecture/features/auth/domain/usecase/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entities/user.dart';
import '../../domain/usecase/current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _signup;
  final UserLogin _login;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignup signup,
      required UserLogin login,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _signup = signup,
        _login = login,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthUserLoggedIn>(_isUserLoggedIn);
  }

  Future<void> _isUserLoggedIn(
      AuthUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());

    res.fold((failure) => emit(AuthFailure(message: failure.message)), (user) {
      _emitAuthSuccess(user, emit);
    });
  }

  Future<void> _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final resp = await _signup(
      UserSignupParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    resp.fold((failure) => emit(AuthFailure(message: failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final resp = await _login(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    resp.fold((failure) => emit(AuthFailure(message: failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
