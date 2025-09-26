import 'package:vexana/vexana.dart';

import '../../../core/init/network/model/error_model_custom.dart';
import '../model/sign_in/sign_in_response_model.dart';
import '../model/sign_up/sign_up_with_email_model.dart';

abstract class IAuthService {
  IAuthService(this.manager);
  final INetworkManager<ErrorModelCustom> manager;

  // Core authentication
  Future<SignInResponseModel?> signUpWithEmail(
    SignUpWithEmailModel signUpModel,
  );
  Future<SignInResponseModel?> signInWithEmail({
    required String email,
    required String password,
  });
  Future<SignInResponseModel?> verifyToken(String token);
  Future<void> signOut(String? token);

  // Social authentication (opsiyonel)
  Future<SignInResponseModel?> signInWithGoogle({
    required String idToken,
    required String timeZone,
    required String fcmToken,
    required String os,
  });

  Future<SignInResponseModel?> signInWithApple({
    required String idToken,
    required String timeZone,
    required String fcmToken,
    required String os,
  });
}
