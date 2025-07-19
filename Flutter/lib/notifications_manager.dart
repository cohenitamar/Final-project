// File: push_notification_manager.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class PushNotificationManager {
  // Singleton
  PushNotificationManager._internal();
  static final PushNotificationManager _instance = PushNotificationManager._internal();
  factory PushNotificationManager() => _instance;

  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  /// Initialize time zone and local notifications plugin
  Future<void> init() async {
    // Initialize time zones (required for zonedSchedule)
    tz.initializeTimeZones();

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android init
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // Combine them
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Actual plugin initialization
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Schedules a one-time notification at the given [scheduledTime].
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      await _buildNotificationDetails(),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedules a daily notification at the given [timeOfDay].
  /// Repeats every day at that time.
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay timeOfDay,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    var firstTrigger = scheduledTime;
    if (firstTrigger.isBefore(now)) {
      firstTrigger = firstTrigger.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      firstTrigger,
      await _buildNotificationDetails(),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedules a weekly notification on a specific weekday at [timeOfDay].
  /// [weekday] can be DateTime.monday (1) through DateTime.sunday (7).
  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay timeOfDay,
    required int weekday, // Monday=1, Tuesday=2,... Sunday=7
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Create the first instance of that weekday/time
    tz.TZDateTime firstTrigger = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // Move forward until it matches the desired weekday
    while (firstTrigger.weekday != weekday) {
      firstTrigger = firstTrigger.add(const Duration(days: 1));
    }

    // If the time has already passed today, push to next week
    if (firstTrigger.isBefore(now)) {
      firstTrigger = firstTrigger.add(const Duration(days: 7));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      firstTrigger,
      await _buildNotificationDetails(),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Notification channel details for Android, plus iOS specifics
  Future<NotificationDetails> _buildNotificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'training_reminder_channel_id', // channel ID
      'Training Reminders',          // channel name
      channelDescription: 'Reminder notifications for your workouts',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  /// Cancel a single notification by ID
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Encodes (planIndex, dayIndex, timeSlot) into a single int.
  ///
  /// - [planIndex] can be any integer >= 0
  /// - [dayIndex] must be 0..9 (if you only need 0..6, that still fits)
  /// - [timeSlot] must be 0..9 (if you only need 1..2, that also fits)
  ///
  /// Formula: id = planIndex * 100 + (dayIndex * 10) + timeSlot
  int encodeNotificationId({
    required int planIndex,
    required int dayIndex,
    required int timeSlot,
  }) {
    return planIndex * 100 + (dayIndex * 10) + timeSlot;
  }

  /// Decodes [id] back into a map of {planIndex, dayIndex, timeSlot}.
  Map<String, int> decodeNotificationId(int id) {
    final int timeSlot = id % 10;            // last digit
    final int dayIndex = (id ~/ 10) % 10;    // second-to-last digit
    final int planIndex = id ~/ 100;         // remaining digits (leading)

    return {
      'planIndex': planIndex,
      'dayIndex': dayIndex,
      'timeSlot': timeSlot,
    };
  }



}
