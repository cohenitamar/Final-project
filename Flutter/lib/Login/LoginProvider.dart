import 'package:IOFit/Adapters/UserAdapter.dart';
import 'package:IOFit/Personal/PersonalProvider.dart';
import 'package:IOFit/Plans/PlanProvider.dart';
import 'package:IOFit/Progress/ProgressProvider.dart';
import 'package:IOFit/SearchExercise/search_exercise_provider.dart';
import 'package:IOFit/Settings/settings_provider.dart';
import 'package:IOFit/Social/SocialProvider.dart';
import 'package:IOFit/Social/social_information.dart';
import 'package:IOFit/User/user_db.dart';
import 'package:IOFit/api/stats_api_service.dart';
import 'package:IOFit/models/historymodel.dart';
import 'package:IOFit/models/poststatsmodel.dart';


import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Adapters/AchievmentAdapter.dart';
import '../Adapters/HistoryAdapter.dart';
import '../Adapters/PlanAdapter.dart';
import '../Adapters/ProgressAdapter.dart';
import '../Homepage/CalendarProvider.dart';
import '../Homepage/homepage_provider.dart';
import '../Plans/PlanList/plan_data.dart';
import '../Plans/plan_exercise.dart';
import '../Progress/HistoryPageProvider.dart';
import '../Progress/PersonGeneralData.dart';
import '../Progress/workoutProgramData.dart';
import '../Social/Post.dart';
import '../User/PersonalInformation.dart';
import '../User/User.dart';
import '../api/user_api_service.dart';
import '../auth_service.dart';
import '../main_screen.dart';
import '../models/planmodel.dart';
import '../models/postmodel.dart';
import '../models/progressmodel.dart';
import '../models/statsmodel.dart';
import '../models/usermodel.dart';
import '../notifications_manager.dart';

class LoginProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  late User _user;
  late AppUser _appUser;

  bool _isLoggingIn = false;
  bool get isLoggingIn => _isLoggingIn;

  void _setLoggingIn(bool value) {
    _isLoggingIn = value;
    notifyListeners();
  }



  final Dio _dio = Dio();
  bool _passwordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _pushManager = PushNotificationManager();

  late final UserApiService _apiService = UserApiService(_dio);

  // Getters
  AuthService get authService => _authService;
  Dio get dio => _dio;
  User get user => _user;
  AppUser get appUser => _appUser;

  bool get passwordVisible => _passwordVisible;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  UserApiService get apiService => _apiService;

  void changeVisible() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // 1. Attempt to sign in with Google in Firebase
      final AuthResult result = await _authService.signInWithGoogleInFirebase();

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
          const SnackBar(content: Text('Google Sign-In failed.')),
        );
        return;
      }

      // 3. Once successfully signed in, call handleLogin
      // (this sets _user in your provider, etc.)
      _user = userCredential.user!;
      await handleLogin(context, skipEmailLogin: true);

    } catch (e) {
      debugPrint('Error in signInWithGoogle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during Google Sign-In')),
      );
    }
  }


  /// Primary login method: tries email/password if `skipEmailLogin` is false,
  /// otherwise just loads data from your backend using the `_user` (if already set).
  Future<void> handleLogin(BuildContext context, {bool skipEmailLogin = false}) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setLoggingIn(true);
      });      // 1. Check if there's already a signed-in user
      User? currentUser = FirebaseAuth.instance.currentUser;
      AuthResult? authResult;

      // Only do email login if we're NOT skipping it:
      if (!skipEmailLogin) {
        if (currentUser == null) {
          authResult = await _authService.signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          if (authResult.userCredential == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authResult.errorMessage ?? 'Sign-in failed'),
              ),
            );
            return;
          }
          // Email sign-in was successful, store the Firebase user
          _user = authResult.userCredential!.user!;
        } else {
          // Already signed in
          _user = currentUser;
        }
      } else {
        // If skipping email login, we assume _user is already set (e.g. by Google)
        if (_user == null && currentUser != null) {
          _user = currentUser;
        }
      }

      // 4. Now we fetch the Firebase ID token to call your API
      final String? token = await _user.getIdToken(true);

      // 5. If we have a valid token, fetch user data from your backend
      if (token != null) {
        UserModel userModel = await _apiService.getUser("Bearer $token");

        final achievement = userModel.achievements;
        final achievementData =
        AchievementAdapter.achievementModelToGeneralAchievements(achievement);
        final planProvider = Provider.of<PlanProvider>(context, listen: false);

        final AppUser newUser = UserAdapter.convertToAppUser(userModel);
        _appUser = newUser;

        // Example of populating providers
        final socialProvider = Provider.of<SocialProvider>(context, listen: false);
        await socialProvider.fetchPosts();
        await socialProvider.fetchPlans(planProvider, this, socialProvider);

        final planl = PlanAdapter.convertPlanModelToPlanTile(userModel.plans, true);
        final list = ProgressAdapter.transformToWorkoutProgramData(userModel.progress);


        planProvider.updatePlans(planl, context);


        final searchProvider = Provider.of<SearchExerciseProvider>(context, listen: false);
        await searchProvider.loadExercises();

        final homeProvider = Provider.of<HomepageProvider>(context, listen: false);
        homeProvider.updateUser(newUser);
        homeProvider.loadAllWorkoutsFromLocal();

        final personalProvider = Provider.of<PersonalProvider>(context, listen: false);
        personalProvider.initializeControllers(newUser);

        final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
        progressProvider.updateUser(list, achievementData, planl, _appUser.id);
        final settingProvider = Provider.of<SettingsProvider>(context, listen: false);
        settingProvider.updateUser(_appUser.id);
        bool pref = await SettingsProvider.getBool(_appUser.id);
        if (pref){
          await planProvider.addNotifications();
        }

        print('User email from API: ${userModel.email}');

        final historyList = HistoryAdapter.convertHistoryToExecutedPlan(userModel.history);
        final historyProvider = Provider.of<HistoryPageProvider>(context, listen: false);
        historyProvider.updateHistory(historyList.reversed.toList());

        final calenderProvider = Provider.of<CalendarProvider>(context, listen: false);
        calenderProvider.initList(historyList);

        // Navigate to MainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        // If token is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-in token was not found. Please try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred during sign-in'),
        ),
      );
    } finally {
      _setLoggingIn(false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
