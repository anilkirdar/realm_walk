import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../core/base/model/base_view_model.dart';
import '../../../../core/constants/regex_constants.dart';
import '../../../../core/init/notifier/theme_notifier.dart';
import '../../../../core/init/system_init.dart';
part 'create_account_viewmodel.g.dart';

class CreateAccountViewModel = _CreateAccountViewModelBase
    with _$CreateAccountViewModel;

abstract class _CreateAccountViewModelBase with Store, BaseViewModel {
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
    fullNameController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  // Form key and controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Observable states
  @observable
  bool isLoading = true;

  @observable
  bool isError = false;

  @observable
  bool isPasswordVisible = false;

  @observable
  bool isConfirmPasswordVisible = false;

  @observable
  bool isCreatingAccount = false;

  @observable
  String countryCode = '+90';

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
  void setCreatingAccount(bool value) {
    isCreatingAccount = value;
  }

  @action
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  @action
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
  }

  // Validation Methods
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.trim().length > 20) {
      return 'Username cannot exceed 20 characters';
    }
    // Check if username contains only alphanumeric characters and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Remove any non-digit characters for validation
    String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length < 10) {
      return 'Please enter a valid phone number (at least 10 digits)';
    }
    if (cleanPhone.length > 15) {
      return 'Phone number is too long';
    }
    return null;
  }

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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // // Check for at least one uppercase letter
    // if (!RegExp(r'[A-Z]').hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter';
    // }
    // // Check for at least one lowercase letter
    // if (!RegExp(r'[a-z]').hasMatch(value)) {
    //   return 'Password must contain at least one lowercase letter';
    // }
    // // Check for at least one digit
    // if (!RegExp(r'\d').hasMatch(value)) {
    //   return 'Password must contain at least one number';
    // }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Action Methods
  Future<void> createAccount() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        setCreatingAccount(true);

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Create account data object
        // final accountData = getFormData();

        // Here you would typically call your API service
        // await AuthService.instance.createAccount(accountData);

        setCreatingAccount(false);

        // Show success message
        ScaffoldMessenger.of(viewModelContext).showSnackBar(
          SnackBar(
            content: const Text(
              'Account created successfully! Please verify your email.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate to email verification or login
        await Future.delayed(const Duration(milliseconds: 500));
        navigateToLogin();
      } catch (e) {
        setCreatingAccount(false);

        // Show error message
        ScaffoldMessenger.of(viewModelContext).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create account: ${e.toString()}',
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

  void navigateToLogin() {
    // Clear form data
    clearForm();

    // Navigate to login page
    viewModelContext.go('/auth/login');
  }

  void clearForm() {
    fullNameController.clear();
    userNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    // Reset visibility states
    isPasswordVisible = false;
    isConfirmPasswordVisible = false;
  }

  // Helper method to get form data
  Map<String, String> getFormData() {
    return {
      'fullName': fullNameController.text.trim(),
      'userName': userNameController.text.trim(),
      'phone': '$countryCode${phoneController.text.trim()}',
      'email': emailController.text.trim(),
      'password': passwordController.text,
    };
  }

  // Helper method to check if form is valid without showing errors
  bool get isFormValid {
    return validateFullName(fullNameController.text) == null &&
        validateUserName(userNameController.text) == null &&
        validatePhone(phoneController.text) == null &&
        validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null &&
        validateConfirmPassword(confirmPasswordController.text) == null;
  }
}
