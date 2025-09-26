import 'package:flutter/material.dart';

import '../../_main/model/character_model.dart';
import '../../_main/model/user_model.dart';
import '../model/sign_in/sign_in_response_model.dart';
import '../model/sign_up/sign_up_with_email_model.dart';

abstract class IAuthProvider {
  // Getters
  UserModel? get user;
  CharacterModel? get character;
  bool get isLoading;
  bool get isAuthenticated;
  bool get isWelcomeView;
  String get token;
  String get userId;

  // Core methods
  Future<SignInResponseModel?> initialize();
  Future<void> signOut();
  bool tryAutoLogin();
  Future<void> triggerWelcomeView();

  // Authentication methods
  Future<bool> signUpWithEmail(SignUpWithEmailModel signUpModel);
  Future<SignInResponseModel?> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  });

  // Social login methods (opsiyonel - gerekirse implement edin)
  Future<bool> signInWithGoogle(BuildContext context);
  Future<bool> signInWithApple(BuildContext context);
}
