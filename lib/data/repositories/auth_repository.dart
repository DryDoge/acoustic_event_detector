import 'dart:convert';
import 'dart:async';

import 'package:acoustic_event_detector/data/admin_dao.dart';
import 'package:acoustic_event_detector/data/user_dao.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:acoustic_event_detector/data/models/user.dart' as model;
import 'package:acoustic_event_detector/utils/firebase_const.dart';
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

      throw errorMessage;
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

  String prepareUrl(String option) {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$option?key=AIzaSyDoGd89bdD-Egmet_l2tEOaNzaxvk08UY0';
  }

  Future<bool> registerWithEmailAndPassword({
    @required String email,
    @required String password,
    @required int rights,
  }) async {
    try {
      final response = await http.post(
        prepareUrl('signUp'),
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] == null) {
        final String _email = responseData['email'];
        final String _userId = responseData['localId'];
        final String _token = responseData['idToken'];

        final bool result = await AdminDao().createUser(
          userId: _userId,
          rights: rights,
          email: _email,
        );

        if (result) {
          return Future.value(result);
        }

        await http.post(
          prepareUrl('delete'),
          body: json.encode(
            {'idToken': _token},
          ),
        );
      }
      return Future.value(false);
    } catch (e) {
      print(e.toString());
      return Future.value(false);
    }
  }
}
