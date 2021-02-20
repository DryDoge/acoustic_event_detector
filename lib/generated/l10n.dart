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

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
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
  String get error_default {
    return Intl.message(
      'Something went wrong',
      name: 'error_default',
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

  /// `An user was created`
  String get register_success {
    return Intl.message(
      'An user was created',
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
  String get delete_question {
    return Intl.message(
      'Are you sure?',
      name: 'delete_question',
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

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Possible address`
  String get possible_address {
    return Intl.message(
      'Possible address',
      name: 'possible_address',
      desc: '',
      args: [],
    );
  }

  /// `Exit application`
  String get exit_app {
    return Intl.message(
      'Exit application',
      name: 'exit_app',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to exit an application?`
  String get exit_app_message {
    return Intl.message(
      'Do you really want to exit an application?',
      name: 'exit_app_message',
      desc: '',
      args: [],
    );
  }

  /// `Delete the event`
  String get delete_event {
    return Intl.message(
      'Delete the event',
      name: 'delete_event',
      desc: '',
      args: [],
    );
  }

  /// `Count of sensors`
  String get sensors_count {
    return Intl.message(
      'Count of sensors',
      name: 'sensors_count',
      desc: '',
      args: [],
    );
  }

  /// `A new event has been recorded`
  String get new_event_alert_title {
    return Intl.message(
      'A new event has been recorded',
      name: 'new_event_alert_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to view it?`
  String get new_event_alert_message {
    return Intl.message(
      'Do you want to view it?',
      name: 'new_event_alert_message',
      desc: '',
      args: [],
    );
  }

  /// `Refresh?`
  String get refresh {
    return Intl.message(
      'Refresh?',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Address not found\nPlease insert other location`
  String get no_address_found {
    return Intl.message(
      'Address not found\nPlease insert other location',
      name: 'no_address_found',
      desc: '',
      args: [],
    );
  }

  /// `Address/location not found`
  String get no_address_found_short {
    return Intl.message(
      'Address/location not found',
      name: 'no_address_found_short',
      desc: '',
      args: [],
    );
  }

  /// `Try again?`
  String get try_refresh {
    return Intl.message(
      'Try again?',
      name: 'try_refresh',
      desc: '',
      args: [],
    );
  }

  /// `No event has happened so far`
  String get no_history_event {
    return Intl.message(
      'No event has happened so far',
      name: 'no_history_event',
      desc: '',
      args: [],
    );
  }

  /// `The sensor was deleted successfully`
  String get sensor_was_deleted {
    return Intl.message(
      'The sensor was deleted successfully',
      name: 'sensor_was_deleted',
      desc: '',
      args: [],
    );
  }

  /// `The event was deleted successfully`
  String get event_was_deleted {
    return Intl.message(
      'The event was deleted successfully',
      name: 'event_was_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Insert a number without a decimal point`
  String get id_error_message {
    return Intl.message(
      'Insert a number without a decimal point',
      name: 'id_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Insert a latitude (-90.0 - +90.0)`
  String get latitute_error_message {
    return Intl.message(
      'Insert a latitude (-90.0 - +90.0)',
      name: 'latitute_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Insert a longitude (-180.0 - +180.0)`
  String get longitude_error_message {
    return Intl.message(
      'Insert a longitude (-180.0 - +180.0)',
      name: 'longitude_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Pick a position on the map`
  String get pick_on_map {
    return Intl.message(
      'Pick a position on the map',
      name: 'pick_on_map',
      desc: '',
      args: [],
    );
  }

  /// `Pick a position`
  String get pick_position {
    return Intl.message(
      'Pick a position',
      name: 'pick_position',
      desc: '',
      args: [],
    );
  }

  /// `Allow location sharing`
  String get allow_share_current_location {
    return Intl.message(
      'Allow location sharing',
      name: 'allow_share_current_location',
      desc: '',
      args: [],
    );
  }

  /// `Location service is disabled.`
  String get location_disabled {
    return Intl.message(
      'Location service is disabled.',
      name: 'location_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permantly denied.\nPlease change this in your settings.`
  String get location_denied_permanently {
    return Intl.message(
      'Location permissions are permantly denied.\nPlease change this in your settings.',
      name: 'location_denied_permanently',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are denied.`
  String get location_denied {
    return Intl.message(
      'Location permissions are denied.',
      name: 'location_denied',
      desc: '',
      args: [],
    );
  }

  /// `No sensor has been added so far`
  String get no_sensor {
    return Intl.message(
      'No sensor has been added so far',
      name: 'no_sensor',
      desc: '',
      args: [],
    );
  }

  /// `No event has been resolved so far`
  String get no_history {
    return Intl.message(
      'No event has been resolved so far',
      name: 'no_history',
      desc: '',
      args: [],
    );
  }

  /// `Sensor added`
  String get sensor_added {
    return Intl.message(
      'Sensor added',
      name: 'sensor_added',
      desc: '',
      args: [],
    );
  }

  /// `Sensor edited`
  String get sensor_edited {
    return Intl.message(
      'Sensor edited',
      name: 'sensor_edited',
      desc: '',
      args: [],
    );
  }

  /// `No position was picked`
  String get pick_sensor_title {
    return Intl.message(
      'No position was picked',
      name: 'pick_sensor_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to close the map?`
  String get pick_sensor_message {
    return Intl.message(
      'Do you want to close the map?',
      name: 'pick_sensor_message',
      desc: '',
      args: [],
    );
  }

  /// `Close the event`
  String get event_resolve {
    return Intl.message(
      'Close the event',
      name: 'event_resolve',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get close_event_question {
    return Intl.message(
      'Are you sure?',
      name: 'close_event_question',
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