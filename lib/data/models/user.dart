import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final int rights;

  const User({
    @required this.uid,
    @required this.email,
    @required this.rights,
  });

  @override
  List<Object> get props => [uid, rights, email];
}
