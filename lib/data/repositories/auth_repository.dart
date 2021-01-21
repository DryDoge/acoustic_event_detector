import 'dart:convert';
import 'dart:async';

import 'package:acoustic_event_detector/data/admin_dao.dart';
import 'package:acoustic_event_detector/data/models/custom_exception.dart';
import 'package:acoustic_event_detector/data/user_dao.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:acoustic_event_detector/data/models/user.dart' as model;
import 'package:http/http.dart' as http;

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
    } catch (error) {
      String errorMessage;
      switch (error.code) {
        case FirebaseConst.errorWrongEmail:
          errorMessage = S.current.sign_in_wrong_email;
          break;
        case FirebaseConst.errorWrongPass:
          errorMessage = S.current.sign_in_wrong_pass;
          break;
        case FirebaseConst.errorNoUser:
          errorMessage = S.current.sign_in_no_user;
          break;
        case FirebaseConst.errorDisabledUser:
          errorMessage = S.current.sign_in_disabled_user;
          break;
        default:
          errorMessage = S.current.register_info_default;
      }

      throw CustomException(errorMessage);
    }
  }

  Future<void> logOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<model.User> get user async {
    final User user = await _firebaseAuth.authStateChanges().first;
    if (user != null) {
      final Map<String, dynamic> response =
          await UserDao().getRightsForUser(user.uid);
      final int rights = response[FirebaseConst.rightsField] as int ?? 0;

      return Future.value(
          getUserFromFirebaseUser(user.uid, rights, user.email));
    }
    return Future.value(null);
  }

  model.User getUserFromFirebaseUser(String id, int rights, String email) {
    return model.User(uid: id, rights: rights, email: email);
  }

  Future<void> deleteUser(String token) async {
    final response = await http.post(
      FirebaseConst.deleteUrl(),
      body: json.encode(
        {FirebaseConst.tokenField: token},
      ),
    );

    final responseData = json.decode(response.body);

    if (responseData[FirebaseConst.errorField] != null) {
      final String error =
          responseData[FirebaseConst.errorField]['message'] as String;
      String errorMessage;
      switch (error) {
        case FirebaseConst.errorInvalidToken:
          errorMessage = S.current.error_default;
          break;
        case FirebaseConst.errorUserNotFound:
          errorMessage = S.current.error_default;
          break;
        default:
          errorMessage = error;
      }
      throw CustomException(errorMessage);
    }
  }

  Future<void> registerWithEmailAndPassword({
    @required String email,
    @required String password,
    @required int rights,
  }) async {
    final response = await http.post(
      FirebaseConst.signUpUrl(),
      body: json.encode(
        {
          FirebaseConst.emailField: email,
          FirebaseConst.passwordField: password,
        },
      ),
    );

    final responseData = json.decode(response.body);

    if (responseData[FirebaseConst.errorField] == null) {
      final String _email = responseData[FirebaseConst.emailField];
      final String _userId = responseData[FirebaseConst.uidField];
      final String _token = responseData[FirebaseConst.tokenField];

      final bool result = await AdminDao().createUser(
        userId: _userId,
        rights: rights,
        email: _email,
      );

      print(result);

      if (result) {
        return;
      }

      await deleteUser(_token);
      throw CustomException(S.current.register_user_not_created);
    } else {
      final String error =
          responseData[FirebaseConst.errorField]['message'] as String;
      print(error);
      String errorMessage;
      switch (error) {
        case FirebaseConst.errorEmailAlreadyExists:
          errorMessage = S.current.register_email_already_exists_error;
          break;
        case FirebaseConst.errorRegistrationDisabled:
          errorMessage = S.current.register_regirstration_disabled_error;
          break;
        case FirebaseConst.errorTooManyRequests:
          errorMessage = S.current.register_too_many_requests_error;
          break;
        default:
          errorMessage = S.current.error_default;
      }
      throw CustomException(errorMessage);
    }
  }
}
