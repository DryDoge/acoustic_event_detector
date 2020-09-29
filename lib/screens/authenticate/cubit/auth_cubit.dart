import 'package:acoustic_event_detector/data/models/custom_exception.dart';
import 'package:acoustic_event_detector/data/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:acoustic_event_detector/data/models/user.dart' as model;
import 'package:flutter/foundation.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({@required this.authRepository}) : super(const AuthInitial());

  Future<void> authenticateUser(
    String email,
    String password,
  ) async {
    try {
      emit(const AuthLoading());
      await authRepository.logIn(email: email, password: password);
      final user = await authRepository.user;
      emit(Authenticated(user));
    } on CustomException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  Future<void> logOutUser() async {
    try {
      await authRepository.logOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> tryToLoginAutomaticly() async {
    try {
      emit(const AuthLoading());
      final model.User user = await authRepository.user;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
