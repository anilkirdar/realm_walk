import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../core/init/cache/local_manager.dart';
import '../../../core/init/network/vexana_manager.dart';
import '../../../core/init/print_dev.dart';
import '../../../product/enum/local_keys_enum.dart';
import '../../_main/model/character_model.dart';
import '../../_main/model/user_model.dart';
import '../model/sign_in/sign_in_response_model.dart';
import '../model/sign_up/sign_up_with_email_model.dart';
import '../service/auth_service.dart';
import 'i_auth_provider.dart';

class AuthProvider with ChangeNotifier implements IAuthProvider {
  AuthService authService = AuthService(VexanaManager.instance.networkManager);
  LocalManager localManager = LocalManager.instance;

  // Core state
  UserModel? _user;
  CharacterModel? _character;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isWelcomeView = true;
  String _token = '';
  String _userId = '';
  DateTime? _expiryDate = DateTime.utc(2021);

  // Getters
  @override
  UserModel? get user => _user;

  @override
  CharacterModel? get character => _character;

  @override
  bool get isLoading => _isLoading;

  @override
  bool get isWelcomeView => _isWelcomeView;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String get userId => _userId;

  @override
  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token.isNotEmpty) {
      return _token;
    }
    return '';
  }

  // Initialize - uygulama açıldığında çağrılır
  @override
  Future<SignInResponseModel?> initialize() async {
    _setLoading(true);

    try {
      if (tryAutoLogin()) {
        final result = await authService.verifyToken(_token);
        if (result?.isSuccess ?? false) {
          _user = result?.user;
          _character = result?.character;
          _isAuthenticated = true;

          // Network manager'ı güncelle
          VexanaManager.instance.addToken(token);
        } else {
          // Token geçersiz, çıkış yap
          await _clearAuthState();
        }
        _setLoading(false);
        return result;
      }
    } catch (e, stackTrace) {
      PrintDev.instance.exception('Error in initialize: $e\n$stackTrace');
      _setLoading(false);
      return SignInResponseModel.error('Initialization failed: $e');
    }

    _setLoading(false);
    return null;
  }

  // Email ile kayıt
  @override
  Future<bool> signUpWithEmail(SignUpWithEmailModel signUpModel) async {
    _setLoading(true);
    bool isSuccess = false;

    try {
      final result = await authService.signUpWithEmail(signUpModel);

      if (result?.isSuccess ?? false) {
        await _handleSuccessfulAuth(result!);
        isSuccess = true;
      } else {
        _handleAuthError(result?.message ?? 'Sign up failed');
      }
    } catch (e, stackTrace) {
      PrintDev.instance.exception('Error in signUpWithEmail: $e\n$stackTrace');
      _handleAuthError('Sign up failed: $e');
    }

    _setLoading(false);
    return isSuccess;
  }

  // Email ile giriş
  @override
  Future<SignInResponseModel?> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoading(true);
    bool isSuccess = false;

    try {
      final result = await authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (result?.isSuccess ?? false) {
        await _handleSuccessfulAuth(result!);
        isSuccess = true;
      } else {
        _handleAuthError(result?.message ?? 'Sign in failed');
        _showErrorToast(context, result?.message);
      }

      _setLoading(false);
      return result;
    } catch (e, stackTrace) {
      PrintDev.instance.exception('Error in signInWithEmail: $e\n$stackTrace');
      _handleAuthError('Sign in failed: $e');
      _setLoading(false);
      return null;
    }
  }

  // Çıkış
  @override
  Future<void> signOut() async {
    _setLoading(true);

    try {
      // Backend'e logout isteği gönder
      if (_token.isNotEmpty) {
        await authService.signOut(_token);
      }

      // Local state temizle
      await _clearAuthState();
    } catch (e, stackTrace) {
      PrintDev.instance.exception('Error in signOut: $e\n$stackTrace');
    }

    _setLoading(false);
  }

  // Welcome view kontrolü
  @override
  Future<void> triggerWelcomeView() async {
    if (!_isWelcomeView) return;

    // 2 saniye bekle sonra welcome screen'i kapat
    await Future.delayed(const Duration(seconds: 2));

    _isWelcomeView = false;
    notifyListeners();
  }

  // Auto-login kontrol
  @override
  bool tryAutoLogin() {
    PrintDev.instance.debug('tryAutoLogin');

    final String tokenExpiryDate = localManager.getStringValue(
      LocalManagerKeys.tokenExpiryDate,
    );
    final String token = localManager.getStringValue(LocalManagerKeys.token);
    final String userId = localManager.getStringValue(LocalManagerKeys.userId);

    if (tokenExpiryDate.isEmpty || token.isEmpty) return false;

    final DateTime expiry = DateTime.parse(tokenExpiryDate);
    if (expiry.isBefore(DateTime.now())) return false;

    _token = token;
    _userId = userId;
    _expiryDate = expiry;
    _isAuthenticated = true;

    return true;
  }

  // Karakter bilgilerini yenile
  Future<bool> refreshCharacterProfile() async {
    try {
      final result = await authService.getCharacterProfile();

      if (result != null) {
        _character = result;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      PrintDev.instance.exception(
        'Error in refreshCharacterProfile: $e\n$stackTrace',
      );
      return false;
    }
  }

  // Başarılı authentication'ı handle et
  Future<void> _handleSuccessfulAuth(SignInResponseModel signInResponse) async {
    try {
      // Token ve expiry date set et
      _token = signInResponse.token ?? '';

      // JWT'den expiry date'i çıkar (eğer JWT kullanıyorsanız)
      if (_token.isNotEmpty) {
        // Basit bir expiry date set edelim - gerçek projede JWT'den parse edilmeli
        _expiryDate = DateTime.now().add(Duration(days: 7));
      }

      _user = signInResponse.user;
      _character = signInResponse.character;
      _userId = signInResponse.user?.id ?? '';
      _isAuthenticated = true;
      _isWelcomeView = false;

      // Cache'e kaydet
      await _saveDataToCache(signInResponse);

      // Network manager'ı güncelle
      VexanaManager.instance.addToken(token);

      notifyListeners();
    } catch (e, stackTrace) {
      PrintDev.instance.exception(
        'Error in _handleSuccessfulAuth: $e\n$stackTrace',
      );
      rethrow;
    }
  }

  // Cache'e veri kaydet
  Future<void> _saveDataToCache(SignInResponseModel signInResponse) async {
    try {
      await localManager.setStringValue(LocalManagerKeys.token, _token);
      await localManager.setStringValue(
        LocalManagerKeys.tokenExpiryDate,
        _expiryDate!.toIso8601String(),
      );
      await localManager.setStringValue(
        LocalManagerKeys.userEmail,
        _user?.email ?? '',
      );
      await localManager.setStringValue(
        LocalManagerKeys.username,
        _user?.username ?? '',
      );
      await localManager.setStringValue(LocalManagerKeys.userId, _userId);

      // Character data'sını kaydet
      if (signInResponse.character != null) {
        await localManager.setNullableStringValue(
          LocalManagerKeys.characterData,
          jsonEncode(signInResponse.character!.toJson()),
        );
      }

      // App açılış tarihini kaydet
      final int todayFromZeroHour = DateTime.now().millisecondsSinceEpoch;
      await localManager.setIntValue(
        LocalManagerKeys.firstAppRunOfToday,
        todayFromZeroHour,
      );
    } catch (e, stackTrace) {
      PrintDev.instance.exception('Error in _saveDataToCache: $e\n$stackTrace');
      rethrow;
    }
  }

  // Auth state'i temizle
  Future<void> _clearAuthState() async {
    _user = null;
    _character = null;
    _isAuthenticated = false;
    _token = '';
    _userId = '';
    _expiryDate = DateTime.utc(2021);
    _isWelcomeView = true;

    await localManager.clearAll();
    notifyListeners();
  }

  // Error handling
  void _handleAuthError(String error) {
    _isAuthenticated = false;
    PrintDev.instance.exception('Auth Error: $error');
  }

  // Toast göster
  void _showErrorToast(BuildContext? context, String? message) {
    if (context == null || message == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Loading state helper
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Social login metodları - gerekirse implement edin
  @override
  Future<bool> signInWithGoogle(BuildContext context) async {
    // Google Sign-In implementasyonu
    return false;
  }

  @override
  Future<bool> signInWithApple(BuildContext context) async {
    // Apple Sign-In implementasyonu
    return false;
  }
}
