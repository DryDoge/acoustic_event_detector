part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final model.User user;

  const Authenticated(
    this.user,
  );

  @override
  List<Object> get props => [user];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Authenticated && o.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AuthError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
