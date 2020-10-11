class FirebaseConst {
  static const String userCollection = 'users';
  static const String sensorsCollection = 'sensors';

  static const String rightsField = 'rights';
  static const String emailField = 'email';
  static const String passwordField = 'password';
  static const String tokenField = 'idToken';
  static const String uidField = 'localId';
  static const String errorField = 'error';
  static const String idField = 'id';

  static const String errorWrongEmail = "invalid-email";
  static const String errorWrongPass = "wrong-password";
  static const String errorNoUser = "user-not-found";
  static const String errorDisabledUser = "user-disabled";
  static const String errorEmailAlreadyExists = 'EMAIL_EXISTS';
  static const String errorRegistrationDisabled = 'OPERATION_NOT_ALLOWED';
  static const String errorTooManyRequests = 'TOO_MANY_ATTEMPTS_TRY_LATER';
  static const String errorInvalidToken = 'INVALID_ID_TOKEN';
  static const String errorUserNotFound = 'USER_NOT_FOUND';

  static const String optionDelete = 'delete';
  static const String optionSignUp = 'signUp';

  static String deleteUrl() {
    return _prepareUrl(optionDelete);
  }

  static String signUpUrl() {
    return _prepareUrl(optionSignUp);
  }

  static const String API_KEY = 'AIzaSyDoGd89bdD-Egmet_l2tEOaNzaxvk08UY0';

  static String _prepareUrl(String option) {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$option?key=$API_KEY';
  }
}
