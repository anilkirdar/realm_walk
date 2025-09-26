import 'package:vexana/vexana.dart';

import '../../../core/constants/network/api_const.dart';
import '../../../core/init/print_dev.dart';
import '../../_main/model/base_response_model.dart';
import '../../_main/model/character_model.dart';
import '../model/auth_model.dart';
import '../model/sign_in/sign_in_response_model.dart';
import '../model/sign_up/sign_up_with_email_model.dart';

import 'i_auth_service.dart';

class AuthService extends IAuthService {
  AuthService(super.manager);

  @override
  Future<SignInResponseModel?> signUpWithEmail(
    SignUpWithEmailModel signUpModel,
  ) async {
    try {
      final response = await manager
          .send<SignInResponseModel, SignInResponseModel>(
            APIConst.signUp,
            parseModel: SignInResponseModel(),
            method: RequestType.POST,
            data: signUpModel.toJson(),
          );

      if (response.error != null) {
        return SignInResponseModel.error(_getErrorMessage(response.error!));
      }

      return response.data;
    } catch (e, stackTrace) {
      PrintDev.instance.exception(
        'signUpWithEmail at AuthService. error: $e.\nStack trace: $stackTrace',
      );
      return SignInResponseModel.error('Sign up failed: $e');
    }
  }

  @override
  Future<SignInResponseModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final authModel = AuthModel(identifier: email, password: password);

      final response = await manager
          .send<SignInResponseModel, SignInResponseModel>(
            APIConst.signIn,
            parseModel: SignInResponseModel(),
            method: RequestType.POST,
            data: authModel.toJson(),
          );

      if (response.error != null) {
        return SignInResponseModel.error(_getErrorMessage(response.error!));
      }

      return response.data;
    } catch (e, stackTrace) {
      PrintDev.instance.exception(
        'signInWithEmail at AuthService. error: $e.\nStack trace: $stackTrace',
      );
      return SignInResponseModel.error('Sign in failed: $e');
    }
  }

  @override
  Future<SignInResponseModel?> verifyToken(String token) async {
    try {
      final response = await manager
          .send<SignInResponseModel, SignInResponseModel>(
            APIConst.verifyToken,
            parseModel: SignInResponseModel(),
            method: RequestType.GET,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );

      if (response.error != null) {
        return SignInResponseModel.error(_getErrorMessage(response.error!));
      }

      return response.data;
    } catch (e, stackTrace) {
      PrintDev.instance.exception(
        'verifyToken at AuthService. error: $e.\nStack trace: $stackTrace',
      );
      return SignInResponseModel.error('Token verification failed: $e');
    }
  }

  @override
  Future<void> signOut(String? token) async {
    try {
      if (token != null && token.isNotEmpty) {
        await manager.send<BaseResponseModel, BaseResponseModel>(
          APIConst.logout,
          parseModel: BaseResponseModel(),
          method: RequestType.POST,
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );
      }
    } catch (e, stackTrace) {
      PrintDev.instance.exception(
        'signOut at AuthService. error: $e.\nStack trace: $stackTrace',
      );
      // Logout request hatası görmezden gelinir
    }
  }

  // Karakter profilini getir
  Future<CharacterModel?> getCharacterProfile() async {
    try {
      final response = await manager.send<CharacterModel, CharacterModel>(
        APIConst.getCharacterProfile,
        parseModel: CharacterModel(),
        method: RequestType.GET,
      );

      if (response.error != null) {
        PrintDev.instance.exception(
          'getCharacterProfile error: ${_getErrorMessage(response.error!)}',
        );
        return null;
      }

      return response.data;
    } catch (e, stackTrace) {
      PrintDev.instance.exception(
        'getCharacterProfile at AuthService. error: $e.\nStack trace: $stackTrace',
      );
      return null;
    }
  }

  // Error message extractor
  String _getErrorMessage(IErrorModel error) {
    if (error.description != null && error.description!.isNotEmpty) {
      return error.description!;
    }

    if (error.model != null) {
      final errorData = error.model!.toJson();

      // API'den gelen error message'ı çıkar
      if (errorData?['message'] is String) {
        return errorData?['message'];
      }

      if (errorData?['message'] is List) {
        final List<dynamic> messages = errorData?['message'];
        if (messages.isNotEmpty) {
          return messages.first.toString();
        }
      }

      return errorData.toString();
    }

    return 'An unknown error occurred';
  }

  // Social login metodları - gerekirse implement edin
  @override
  Future<SignInResponseModel?> signInWithGoogle({
    required String idToken,
    required String timeZone,
    required String fcmToken,
    required String os,
  }) async {
    // Google Sign-In implementasyonu gerekirse buraya eklenebilir
    throw UnimplementedError('Google Sign-In not implemented');
  }

  @override
  Future<SignInResponseModel?> signInWithApple({
    required String idToken,
    required String timeZone,
    required String fcmToken,
    required String os,
  }) async {
    // Apple Sign-In implementasyonu gerekirse buraya eklenebilir
    throw UnimplementedError('Apple Sign-In not implemented');
  }
}
