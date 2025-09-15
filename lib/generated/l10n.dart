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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Next`
  String get buttonNext {
    return Intl.message('Next', name: 'buttonNext', desc: '', args: []);
  }

  /// `Skip`
  String get buttonSkip {
    return Intl.message('Skip', name: 'buttonSkip', desc: '', args: []);
  }

  /// `Done`
  String get buttonDone {
    return Intl.message('Done', name: 'buttonDone', desc: '', args: []);
  }

  /// `Earn Rewards\nPlaying Games!`
  String get onboardTitle1 {
    return Intl.message(
      'Earn Rewards\nPlaying Games!',
      name: 'onboardTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Plan a\nGame Night`
  String get onboardTitle2 {
    return Intl.message(
      'Plan a\nGame Night',
      name: 'onboardTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Text, Voice\n& Video Chat`
  String get onboardTitle3 {
    return Intl.message(
      'Text, Voice\n& Video Chat',
      name: 'onboardTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Collect points and money by winning games.\nWithdraw your earnings instantly!`
  String get onboardSubtitle1 {
    return Intl.message(
      'Collect points and money by winning games.\nWithdraw your earnings instantly!',
      name: 'onboardSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Easily set up an event\nand get ready to play. Yes, you are the hero!`
  String get onboardSubtitle2 {
    return Intl.message(
      'Easily set up an event\nand get ready to play. Yes, you are the hero!',
      name: 'onboardSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Feel real connection on mobile.\nChat for free before and after the game!`
  String get onboardSubtitle3 {
    return Intl.message(
      'Feel real connection on mobile.\nChat for free before and after the game!',
      name: 'onboardSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Let’s play!`
  String get letsPlay {
    return Intl.message('Let’s play!', name: 'letsPlay', desc: '', args: []);
  }

  /// `Create Account`
  String get createAccountTitle {
    return Intl.message(
      'Create Account',
      name: 'createAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hello, please fill in the form to continue\nyour adventure.`
  String get createAccountSubtitle {
    return Intl.message(
      'Hello, please fill in the form to continue\nyour adventure.',
      name: 'createAccountSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullNameLabel {
    return Intl.message('Full Name', name: 'fullNameLabel', desc: '', args: []);
  }

  /// `Username`
  String get userNameLabel {
    return Intl.message('Username', name: 'userNameLabel', desc: '', args: []);
  }

  /// `Phone Number`
  String get yourPhoneLabel {
    return Intl.message(
      'Phone Number',
      name: 'yourPhoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccountButton {
    return Intl.message(
      'Create Account',
      name: 'createAccountButton',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connectWithText {
    return Intl.message('Connect', name: 'connectWithText', desc: '', args: []);
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Something went wrong!`
  String get formErrorGeneral {
    return Intl.message(
      'Something went wrong!',
      name: 'formErrorGeneral',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection.`
  String get checkYourInternet {
    return Intl.message(
      'Please check your internet connection.',
      name: 'checkYourInternet',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get closeText {
    return Intl.message('Close', name: 'closeText', desc: '', args: []);
  }

  /// `Try Again`
  String get retryText {
    return Intl.message('Try Again', name: 'retryText', desc: '', args: []);
  }

  /// `Sign In`
  String get loginButtonText {
    return Intl.message('Sign In', name: 'loginButtonText', desc: '', args: []);
  }

  /// `Don’t have an account?`
  String get dontHaveAccountText {
    return Intl.message(
      'Don’t have an account?',
      name: 'dontHaveAccountText',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcomeBackTitle {
    return Intl.message(
      'Welcome Back!',
      name: 'welcomeBackTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hello, please log in to continue\nyour journey.`
  String get welcomeBackSubtitle {
    return Intl.message(
      'Hello, please log in to continue\nyour journey.',
      name: 'welcomeBackSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPasswordText {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Choose Account Type`
  String get userChoiceTitle {
    return Intl.message(
      'Choose Account Type',
      name: 'userChoiceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pick the option right for you`
  String get userChoiceSubtitle {
    return Intl.message(
      'Pick the option right for you',
      name: 'userChoiceSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Parent`
  String get parentChoice {
    return Intl.message('Parent', name: 'parentChoice', desc: '', args: []);
  }

  /// `Track your child’s safety.`
  String get parentChoiceDescription {
    return Intl.message(
      'Track your child’s safety.',
      name: 'parentChoiceDescription',
      desc: '',
      args: [],
    );
  }

  /// `Child`
  String get childChoice {
    return Intl.message('Child', name: 'childChoice', desc: '', args: []);
  }

  /// `Discover safely.`
  String get childChoiceDescription {
    return Intl.message(
      'Discover safely.',
      name: 'childChoiceDescription',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'az'),
      Locale.fromSubtags(languageCode: 'bg'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fa'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'gn'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'hy'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ka'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'lt'),
      Locale.fromSubtags(languageCode: 'mn'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'ne'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sg'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'te'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tl'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'uz'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zu'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
