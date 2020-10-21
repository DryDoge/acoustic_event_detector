// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get languageCode {
    return Intl.message(
      'en',
      name: 'languageCode',
      desc: '',
      args: [],
    );
  }

  /// `Acoustic event detector`
  String get appName {
    return Intl.message(
      'Acoustic event detector',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Sensors`
  String get sensors {
    return Intl.message(
      'Sensors',
      name: 'sensors',
      desc: '',
      args: [],
    );
  }

  /// `Sensor`
  String get sensor {
    return Intl.message(
      'Sensor',
      name: 'sensor',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get current_event {
    return Intl.message(
      'Event',
      name: 'current_event',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get log_in {
    return Intl.message(
      'Log in',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Rights`
  String get rights {
    return Intl.message(
      'Rights',
      name: 'rights',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get rights_basic {
    return Intl.message(
      'Basic',
      name: 'rights_basic',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get rights_all {
    return Intl.message(
      'All',
      name: 'rights_all',
      desc: '',
      args: [],
    );
  }

  /// `Add an user`
  String get new_user {
    return Intl.message(
      'Add an user',
      name: 'new_user',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Create a new user`
  String get user_create_new {
    return Intl.message(
      'Create a new user',
      name: 'user_create_new',
      desc: '',
      args: [],
    );
  }

  /// `Creating a new user...`
  String get user_create_new_now {
    return Intl.message(
      'Creating a new user...',
      name: 'user_create_new_now',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to log out?`
  String get log_out_question {
    return Intl.message(
      'Do you really want to log out?',
      name: 'log_out_question',
      desc: '',
      args: [],
    );
  }

  /// `Password is wrong`
  String get sign_in_wrong_pass {
    return Intl.message(
      'Password is wrong',
      name: 'sign_in_wrong_pass',
      desc: '',
      args: [],
    );
  }

  /// `User with this email does not exist`
  String get sign_in_no_user {
    return Intl.message(
      'User with this email does not exist',
      name: 'sign_in_no_user',
      desc: '',
      args: [],
    );
  }

  /// `User with this email is disabled`
  String get sign_in_disabled_user {
    return Intl.message(
      'User with this email is disabled',
      name: 'sign_in_disabled_user',
      desc: '',
      args: [],
    );
  }

  /// `Email address is invalid`
  String get sign_in_wrong_email {
    return Intl.message(
      'Email address is invalid',
      name: 'sign_in_wrong_email',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get register_password_error_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'register_password_error_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Enter a password 6+ chars long`
  String get register_password_info_short {
    return Intl.message(
      'Enter a password 6+ chars long',
      name: 'register_password_info_short',
      desc: '',
      args: [],
    );
  }

  /// `Password is too short`
  String get register_password_error_short {
    return Intl.message(
      'Password is too short',
      name: 'register_password_error_short',
      desc: '',
      args: [],
    );
  }

  /// `Enter passwords again`
  String get register_password_info_not_match {
    return Intl.message(
      'Enter passwords again',
      name: 'register_password_info_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Enter an email`
  String get register_email_info {
    return Intl.message(
      'Enter an email',
      name: 'register_email_info',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get register_error_default {
    return Intl.message(
      'Something went wrong',
      name: 'register_error_default',
      desc: '',
      args: [],
    );
  }

  /// `Try again later`
  String get register_info_default {
    return Intl.message(
      'Try again later',
      name: 'register_info_default',
      desc: '',
      args: [],
    );
  }

  /// `An user wasAn user was not created created`
  String get register_success {
    return Intl.message(
      'An user wasAn user was not created created',
      name: 'register_success',
      desc: '',
      args: [],
    );
  }

  /// `The email is already in use`
  String get register_email_already_exists_error {
    return Intl.message(
      'The email is already in use',
      name: 'register_email_already_exists_error',
      desc: '',
      args: [],
    );
  }

  /// `The registration is disabled`
  String get register_regirstration_disabled_error {
    return Intl.message(
      'The registration is disabled',
      name: 'register_regirstration_disabled_error',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests`
  String get register_too_many_requests_error {
    return Intl.message(
      'Too many requests',
      name: 'register_too_many_requests_error',
      desc: '',
      args: [],
    );
  }

  /// `An user was not created`
  String get register_user_not_created {
    return Intl.message(
      'An user was not created',
      name: 'register_user_not_created',
      desc: '',
      args: [],
    );
  }

  /// `A sensor with this id already exists`
  String get sensor_already_exists_id {
    return Intl.message(
      'A sensor with this id already exists',
      name: 'sensor_already_exists_id',
      desc: '',
      args: [],
    );
  }

  /// `Add a new sensor`
  String get add_sensor {
    return Intl.message(
      'Add a new sensor',
      name: 'add_sensor',
      desc: '',
      args: [],
    );
  }

  /// `Update the sensor`
  String get update_sensor {
    return Intl.message(
      'Update the sensor',
      name: 'update_sensor',
      desc: '',
      args: [],
    );
  }

  /// `Delete the sensor`
  String get delete_sensor {
    return Intl.message(
      'Delete the sensor',
      name: 'delete_sensor',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get id {
    return Intl.message(
      'ID',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get latitude {
    return Intl.message(
      'Latitude',
      name: 'latitude',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get longitude {
    return Intl.message(
      'Longitude',
      name: 'longitude',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get sensor_delete_question {
    return Intl.message(
      'Are you sure?',
      name: 'sensor_delete_question',
      desc: '',
      args: [],
    );
  }

  /// `Please fill location`
  String get sensor_map_location {
    return Intl.message(
      'Please fill location',
      name: 'sensor_map_location',
      desc: '',
      args: [],
    );
  }

  /// `Show map`
  String get show_on_map {
    return Intl.message(
      'Show map',
      name: 'show_on_map',
      desc: '',
      args: [],
    );
  }

  /// `Show list`
  String get show_list {
    return Intl.message(
      'Show list',
      name: 'show_list',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'cs'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}