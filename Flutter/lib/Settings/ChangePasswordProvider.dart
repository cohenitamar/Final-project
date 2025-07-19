// lib/providers/ChangePasswordProvider.dart
import 'package:flutter/material.dart';

import '../Login/login_widget.dart';
import '../auth_service.dart';

class ChangePasswordProvider with ChangeNotifier {
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Obscure text flags
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  // Password validity flags
  bool _isLengthValid = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  // Getters
  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController get newPasswordController => _newPasswordController;

  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  bool get isNewPasswordObscured => _isNewPasswordObscured;

  bool get isConfirmPasswordObscured => _isConfirmPasswordObscured;

  // Password validity getters
  bool get isLengthValid => _isLengthValid;

  bool get hasUppercase => _hasUppercase;

  bool get hasLowercase => _hasLowercase;

  bool get hasDigit => _hasDigit;

  bool get hasSpecialChar => _hasSpecialChar;

  // Toggle visibility of new password
  void setIsNewPasswordObscured() {
    _isNewPasswordObscured = !_isNewPasswordObscured;
    notifyListeners();
  }

  // Toggle visibility of confirm password
  void setIsConfirmPasswordObscured() {
    _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    notifyListeners();
  }

  void reset() {
    // Clear controllers
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    // Reset obscurity
    _isNewPasswordObscured = true;
    _isConfirmPasswordObscured = true;

    // Reset password validity flags
    _isLengthValid = false;
    _hasUppercase = false;
    _hasLowercase = false;
    _hasDigit = false;
    _hasSpecialChar = false;

    notifyListeners();
  }



  // Update password validity flags based on the input
  void updatePasswordValidity(String password) {
    _isLengthValid = password.length >= 8;
    _hasUppercase = password.contains(RegExp(r'[A-Z]'));
    _hasLowercase = password.contains(RegExp(r'[a-z]'));
    _hasDigit = password.contains(RegExp(r'\d'));
    _hasSpecialChar =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\/\\\[\]]'));
    notifyListeners();
  }

  // Check if the password meets all requirements
  bool isPasswordValid(String password) {
    return _isLengthValid &&
        _hasUppercase &&
        _hasLowercase &&
        _hasDigit &&
        _hasSpecialChar;
  }

  // Handle validation for new password field
  String? handleNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new password';
    }
    if (!isPasswordValid(value)) {
      return 'Password does not meet requirements';
    }
    return null;
  }

  // Handle validation for confirm password field
  String? handleConfirmPassword(String? value) {
    String newPassword = _newPasswordController.text.trim();
    if (newPassword == "") {
      return null;
    }
    if (value == null || newPassword.compareTo(value) != 0) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> handleChangePassword(BuildContext context) async {
    // Validate the form fields
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is invalid
    }

    // Call AuthService to change password
    final authService = AuthService();
    final result = await authService.changePassword(_newPasswordController.text);
    await authService.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginWidget()),
    );


    // If there's an error, show it and return early
    if (result.errorMessage != null) {
      // You can use a SnackBar, dialog, or any other widget to show the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage!)),
      );
      return;
    }

    // If we get here, it means the password was changed successfully
    Navigator.pop(context, "Password updated successfully");

    // Clear text fields and reset validity flags
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    resetPasswordValidity();
  }


  // Handle cancel action
  Future<void> handleCancel(BuildContext context) async {
    Navigator.pop(context, "Password change cancelled");
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    resetPasswordValidity();
  }

  // Reset password validity flags
  void resetPasswordValidity() {
    _isLengthValid = false;
    _hasUppercase = false;
    _hasLowercase = false;
    _hasDigit = false;
    _hasSpecialChar = false;
    notifyListeners();
  }

  // Dispose controllers
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
