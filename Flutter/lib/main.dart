import 'package:IOFit/Login/LoginProvider.dart';
import 'package:IOFit/Register/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'Homepage/CalendarProvider.dart';
import 'Homepage/homepage_provider.dart';
import 'Login/login_widget.dart';
import 'Personal/PersonalProvider.dart';
import 'Plans/PlanProvider.dart';
import 'Progress/HistoryPageProvider.dart';
import 'Progress/ProgressChartProvider.dart';
import 'Progress/ProgressProvider.dart';
import 'SearchExercise/search_exercise_provider.dart';
import 'Settings/ChangePasswordProvider.dart';
import 'Settings/settings_provider.dart';
import 'Social/SocialProvider.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- Import FirebaseAuth
import 'notifications_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  final pushManager = PushNotificationManager();
  await pushManager.init();

  // Request permission for notifications
  final flutterLocalNotificationsPlugin =
      pushManager.flutterLocalNotificationsPlugin;

  final bool? granted = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  if (granted == null || !granted) {
    print('Notification permission not granted!');
  } else {
    print('Notification permission granted!');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlanProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              ProgressProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ProgressChartProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (context) => HistoryPageProvider()),
        ChangeNotifierProvider(create: (context) => HomepageProvider()),
        ChangeNotifierProvider(create: (context) => SearchExerciseProvider()),
        ChangeNotifierProvider(create: (context) => PersonalProvider()),
        ChangeNotifierProvider(create: (context) => SocialProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(
          create: (context) => CalendarProvider(
            Provider.of<HistoryPageProvider>(context, listen: false),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  /// Flag to ensure we only call `handleLogin` once per app launch.
  bool _didCallLogin = false;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
      FlutterFlowTheme.saveThemeMode(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'project',
      // Use StreamBuilder to decide which screen to show based on Firebase auth state
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. While waiting for the first event, show loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // 2. If user is logged in (snapshot.data != null)
          if (snapshot.hasData && snapshot.data != null) {
            // Call handleLogin once to fetch user data & navigate
            if (!_didCallLogin) {
              _didCallLogin = true;
              final loginProvider =
              Provider.of<LoginProvider>(context, listen: false);
              loginProvider.handleLogin(context);
            }

            // While handleLogin runs (and does Navigator.pushReplacement),
            // show a temporary loading screen.
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Optional: Customize the color
                ),
              ),
            );
          } else {
            // 3. If user is not logged in, go to LoginWidget
            return const LoginWidget();
          }
        },
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
    );
  }
}
