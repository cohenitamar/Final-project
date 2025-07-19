import 'package:IOFit/Homepage/homepage_provider.dart';
import 'package:IOFit/Plans/PlanProvider.dart';
import 'package:IOFit/Progress/HistoryPageProvider.dart';
import 'package:IOFit/Progress/ProgressChartProvider.dart';
import 'package:IOFit/Progress/ProgressProvider.dart';
import 'package:IOFit/Register/register_provider.dart';
import 'package:IOFit/SearchExercise/search_exercise_provider.dart';
import 'package:IOFit/Settings/ChangePasswordProvider.dart';
import 'package:IOFit/Plans/PlanProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../Social/SocialProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_service.dart';
import '../notifications_manager.dart';

class SettingsProvider extends ChangeNotifier {
  /// Tracks the status of 'Reminder Notifications'
  bool _reminderNotifications = true;
  bool get reminderNotifications => _reminderNotifications;

  String _uid = '';
  final _pushManager = PushNotificationManager();



  /// Update the reminderNotifications value
  void setReminderNotifications(bool value,context) async{
    _reminderNotifications = value;
    notifyListeners();
  }

  void handleNotifications(bool value, BuildContext context) async {
    final planProvider = Provider.of<PlanProvider>(context, listen: false);
    if (value) {
      await planProvider.addNotifications(); // Call the method with ()
    } else {
      await _pushManager.cancelAllNotifications(); // Call the method with ()
    }



  await saveBool(value, _uid);
    _reminderNotifications = value;
    notifyListeners();
  }

  // Save a boolean value
  static Future<void> saveBool(bool value,String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Get a boolean value
  static Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false; // Default to false if not set
  }

  /// Sign out using AuthService
  Future<void> signOut(context) async {
    final authService = AuthService();
    Provider.of<SocialProvider>(context, listen: false).reset();
    Provider.of<PlanProvider>(context, listen: false).reset();
    Provider.of<ProgressChartProvider>(context, listen: false).reset();
    Provider.of<ProgressProvider>(context, listen: false).reset();
    Provider.of<RegisterProvider>(context, listen: false).reset();
    Provider.of<SearchExerciseProvider>(context, listen: false).reset();
    Provider.of<ChangePasswordProvider>(context, listen: false).reset();
    Provider.of<HistoryPageProvider>(context, listen: false).reset();
    Provider.of<HomepageProvider>(context, listen: false).reset();
    await authService.signOut();
    await _pushManager.cancelAllNotifications();
    // You can call notifyListeners() here if the sign-out affects other parts of your app
    // notifyListeners();
  }
  void updateUser(String uid) async{
    this._uid = uid;
    _reminderNotifications = await getBool(uid);
  }
}
