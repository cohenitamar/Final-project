import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Homepage/homepage_provider.dart';
import '../SearchExercise/exercise.dart';

class ExerciseWidget extends StatefulWidget {
  final Exercise exercise;

  const ExerciseWidget({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color backgroundColor = Color(0xFF1A1A2E);
  final Color primaryColor = Color(0xFF1A1A2E);
  final Color accentColor = Color(0xFF1A1A2E);
  final Color highlightColor = Color(0xFFEA6D13);

  final TextStyle titleTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
  );
  final TextStyle bodyTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOverviewTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Image with Exercise Name Overlay
        Stack(
          children: [
            Image.asset(
              widget.exercise.fullSizeImagePath,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.black38,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Text(
                widget.exercise.name,
                style: titleTextStyle.copyWith(fontSize: 32.0),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Category: ${widget.exercise.category}',
            style: bodyTextStyle.copyWith(color: highlightColor),
          ),
        ),
        SizedBox(height: 10.0),
        Divider(color: Colors.white24),
        // Make the instructions scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.exercise.instructions,
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMusclesTab() {
    return Column(
      children: [
        // Muscles Worked Image
        Image.asset(
          widget.exercise.muscles,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 20.0),
        // Make the description scrollable if it overflows
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'This exercise primarily targets the muscles highlighted above. Incorporating this exercise into your routine will help strengthen and tone these muscle groups.',
              style: bodyTextStyle,
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.white,
            size: 20.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.exercise.name,
          style: titleTextStyle.copyWith(fontSize: 20.0),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: highlightColor,
          indicatorWeight: 3.0,
          labelColor: highlightColor,
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(
              text: 'Overview',
              icon: Icon(Icons.info_outline),
            ),
            Tab(
              text: 'Muscles',
              icon: Icon(Icons.fitness_center),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildMusclesTab(),
        ],
      ),
    );
  }
}
