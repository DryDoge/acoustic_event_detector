import 'package:acoustic_event_detector/data/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart' as model;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Future<void> authenticateUser(
    String email,
    String password,
  ) async {
    try {
      emit(const AuthLoading());
      await _authRepository.logIn(email: email, password: password);
      final user = await _authRepository.user;
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logOutUser() async {
    try {
      await _authRepository.logOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> tryToLoginAutomaticly() async {
    try {
      emit(const AuthLoading());
      final model.User user = await _authRepository.user;
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
