import 'package:IOFit/Login/LoginProvider.dart';
import 'package:IOFit/Social/SocialPostList.dart';
import 'package:IOFit/Social/SocialAppBar.dart';
import 'package:IOFit/Social/SocialProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:IOFit/Social/plan_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Plans/PlanList/plan_data.dart';
import '../User/User.dart'; // Import your user model
import 'Post.dart';
import '../Personal/personal_widget.dart'; // Import the existing PersonalWidget
import 'dart:math';
import '../User/user_db.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Plans/PlanProvider.dart';
import 'SocialPlanList.dart';

class SocialWidget extends StatefulWidget {
  const SocialWidget({Key? key}) : super(key: key);

  @override
  _SocialWidgetState createState() => _SocialWidgetState();
}

class _SocialWidgetState extends State<SocialWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    /// Defer initializeData so we don't get "notifyListeners during build."
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SocialProvider>(context, listen: false);
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final planProvider = Provider.of<PlanProvider>(context, listen: false);
      final socialProvider = Provider.of<SocialProvider>(context, listen: false);
      provider.initializeData(this, loginProvider, planProvider, socialProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Use listen: true so this widget rebuilds when tabController becomes non-null.
    final provider = Provider.of<SocialProvider>(context, listen: true);

    /// If tabController is null, show a loading screen.
    if (provider.tabController == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF062029),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// Once tabController is initialized, show the real UI.
    return Scaffold(
      backgroundColor: const Color(0xFF062029),
      appBar: SocialAppBar(tabController: provider.tabController!),
      body: TabBarView(
        controller: provider.tabController!,
        children: const [
          SocialPlanList(),
          SocialPostsList(),
        ],
      ),
    );
  }
}
