// register_provider.dart

import 'dart:convert';
import 'dart:io';
import 'package:IOFit/Login/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../Social/SocialProvider.dart';
import '../api/user_api_service.dart';
import '../auth_service.dart';
import '../file_handler.dart';
import '../models/registerusermodel.dart';
import '../Login/login_widget.dart';
import '../Homepage/homepage.dart';

/// Custom auth result class from your AuthService
/// Typically, this is something like:
/// class AuthResult {
///   final UserCredential? userCredential;
///   final String? errorMessage;
///   AuthResult({this.userCredential, this.errorMessage});
/// }
/// Make sure to use your own implementation.

class RegisterProvider with ChangeNotifier {
  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Password visibility toggles
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  // Profile picture
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  // AuthService and Dio
  final AuthService _authService = AuthService();
  final Dio _dio = Dio();
  late final UserApiService _apiService = UserApiService(_dio);

  RegisterProvider() {
    // Init logic if needed
  }

  /// Toggle password visibility for the main password
  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  /// Toggle visibility for confirm password
  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }


  void reset() {
    // Clear text fields
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    // Reset toggles
    passwordVisible = false;
    confirmPasswordVisible = false;

    // Reset profile image
    profileImage = null;

    notifyListeners();
  }


  /// Pick image from gallery (profile picture)
  Future<void> pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  /// Perform user registration with email & password
  Future<void> registerUser(BuildContext context) async {
    try {
      if (passwordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        // Passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
        return;
      }

      // 1. Firebase auth sign-up
      final AuthResult? authResult = await _authService.registerWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (authResult == null || authResult.userCredential == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authResult?.errorMessage ?? 'Sign-up failed'),
          ),
        );
        return;
      }

      // 2. Get token
      User? user = authResult.userCredential!.user;
      String? token = await user?.getIdToken(true);
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-up token was not found. Please try again.'),
          ),
        );
        return;
      }

      // 3. Convert selected profile image to base64 if available
      String base64Image = '';
      if (profileImage != null) {
        base64Image = await Utility.fileToBase64(profileImage!.path);
      }

      // 4. Create the backend user model
      RegisterUserModel rUser = RegisterUserModel(
        picture: base64Image,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      // 5. Make API call to create user in your backend
      await _apiService.createUser("Bearer $token", rUser);

      // 6. Navigate to login or wherever you need
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
    } catch (e) {
      debugPrint('Error in registerUser: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during sign-up')),
      );
    }
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      // 1. Attempt to "sign up" in Firebase using Google
      final AuthResult result = await _authService.signUpWithGoogleInFirebase();

      if (result.errorMessage != null) {
        // Show the error in a snack bar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage!)),
        );
        return;
      }

      // 2. If we get here, userCredential is available
      final userCredential = result.userCredential;
      if (userCredential == null || userCredential.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-Up failed.')),
        );
        return;
      }

      // 3. Get an ID token
      final String? token = await userCredential.user!.getIdToken(true);
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve ID token.')),
        );
        return;
      }

      // 4. Create user in your backend
      RegisterUserModel rUser = RegisterUserModel(
        picture: "",
        firstName: "",
        lastName: "",
      );

      await _apiService.createUser("Bearer $token", rUser);

      // 5. Finally, reuse your handleLogin to proceed
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      await loginProvider.handleLogin(context, skipEmailLogin: true);

    } catch (e) {
      debugPrint('Error in signUpWithGoogle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during Google Sign-Up')),
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
