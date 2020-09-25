import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../models/user.dart' as model;
import '../user_dao.dart';

//TODO Thrown during the login process if a failure occurs.
class LogInFailure implements Exception {}

//TODO Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> logIn({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInFailure();
    }
  }

  Future<void> logOut() async {
    try {
      return await _firebaseAuth.signOut();
    } on Exception {
      throw LogOutFailure();
    }
  }

  Future<model.User> get user async {
    final User user = await _firebaseAuth.authStateChanges().first;
    final Map<String, dynamic> response =
        await UserDao().getRightsForUser(user.uid);

    final int rights = response['rights'] as int ?? 0;
    final String email = response['email'] as String ?? '';

    if (user != null) {
      return Future.value(getUserFromFirebaseUser(user.uid, rights, email));
    }
    return Future.value(null);
  }

  model.User getUserFromFirebaseUser(String id, int rights, String email) {
    return model.User(uid: id, rights: rights, email: email);
  }

  Future<dynamic> registerWithEmailAndPassword({
    @required String email,
    @required String password,
    @required int rights,
  }) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //TODO create in users collection document(id = user.uid)
      return getUserFromFirebaseUser(user.uid, rights, user.email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
