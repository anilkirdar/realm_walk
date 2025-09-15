import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../core/base/model/base_view_model.dart';
import '../../../../core/constants/regex_constants.dart';
import '../../../../core/init/notifier/theme_notifier.dart';
import '../../../../core/init/system_init.dart';
part 'login_viewmodel.g.dart';

class LoginViewModel = _LoginViewModelBase with _$LoginViewModel;

abstract class _LoginViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => viewModelContext = context;

  @override
  void init() async {
    SystemInit.instance.setSystemUIOverlayStyleAuthView();

    try {
      setLoading(true);
      // Simulate initialization delay
      await Future.delayed(const Duration(milliseconds: 500));
      setLoading(false);
    } catch (e) {
      setError(true);
      setLoading(false);
    }
  }

  void dispose() {
    SystemInit.instance.setSystemUIOverlayStyle(
      Provider.of<ThemeNotifier>(viewModelContext, listen: false).isDark,
    );

    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
  }

  // Form key and controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable states
  @observable
  bool isLoading = true;

  @observable
  bool isError = false;

  @observable
  bool isPasswordVisible = false;

  @observable
  bool isLoggingIn = false;

  // Actions
  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setError(bool value) {
    isError = value;
  }

  @action
  void setLoggingIn(bool value) {
    isLoggingIn = value;
  }

  @action
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  // Validation Methods
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // More comprehensive email regex
    if (!RegExp(RegexConst.instance.emailRegex).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Action Methods
  Future<void> login() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        setLoggingIn(true);

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Create login data object
        final loginData = {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        };

        // Here you would typically call your API service
        // final result = await AuthService.instance.login(loginData);

        setLoggingIn(false);

        // Show success message
        ScaffoldMessenger.of(viewModelContext).showSnackBar(
          SnackBar(
            content: const Text(
              'Login successful! Welcome back.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate to main app
        await Future.delayed(const Duration(milliseconds: 500));
        navigateToMain();
      } catch (e) {
        setLoggingIn(false);

        // Show error message
        ScaffoldMessenger.of(viewModelContext).showSnackBar(
          SnackBar(
            content: Text(
              'Login failed: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      // Show validation error message
      ScaffoldMessenger.of(viewModelContext).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill in all fields correctly',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      setLoading(true);

      // Simulate Google sign-in
      await Future.delayed(const Duration(seconds: 1));

      // Here you would typically call your Google sign-in service
      // final result = await GoogleSignInService.instance.signIn();

      setLoading(false);

      ScaffoldMessenger.of(viewModelContext).showSnackBar(
        SnackBar(
          content: const Text(
            'Google sign-in initiated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Navigate to main app after successful Google sign-in
      await Future.delayed(const Duration(milliseconds: 500));
      navigateToMain();
    } catch (e) {
      setLoading(false);
      ScaffoldMessenger.of(viewModelContext).showSnackBar(
        SnackBar(
          content: Text(
            'Google sign-in failed: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      setLoading(true);

      // Simulate Facebook sign-in
      await Future.delayed(const Duration(seconds: 1));

      // Here you would typically call your Facebook sign-in service
      // final result = await FacebookSignInService.instance.signIn();

      setLoading(false);

      ScaffoldMessenger.of(viewModelContext).showSnackBar(
        SnackBar(
          content: const Text(
            'Facebook sign-in initiated',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Navigate to main app after successful Facebook sign-in
      await Future.delayed(const Duration(milliseconds: 500));
      navigateToMain();
    } catch (e) {
      setLoading(false);
      ScaffoldMessenger.of(viewModelContext).showSnackBar(
        SnackBar(
          content: Text(
            'Facebook sign-in failed: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void navigateToCreateAccount() {
    // Clear form data
    clearForm();

    // Navigate to create account page
    viewModelContext.go('/auth/create-account');
  }

  void navigateToForgotPassword() {
    // Navigate to forgot password page
    viewModelContext.go('/auth/forgot-password');
  }

  void navigateToMain() {
    // Clear form data
    clearForm();

    // Navigate to main app (dashboard/home)
    viewModelContext.go('/main');
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();

    // Reset visibility states
    isPasswordVisible = false;
  }

  // Helper method to get form data
  Map<String, String> getFormData() {
    return {'email': emailController.text.trim()};
  }

  // Helper method to check if form is valid without showing errors
  bool get isFormValid {
    return validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null;
  }

  // Helper method to enable/disable login button
  bool get canLogin {
    return emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty &&
        !isLoggingIn;
  }
}
