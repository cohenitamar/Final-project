import 'package:IOFit/Personal/PersonalProvider.dart';

import '../Plans/PlanProvider.dart';
import 'HeadlineProgress.dart';
import 'HistoryPage.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'PersonGeneralData.dart';
import 'workoutProgramData.dart';
import 'TimePeriodSelector.dart';
import 'GeneralProgress.dart';
import 'Achievements.dart';
import 'UpcomingWorkoutListMember.dart';

import '../../bottom_toolbar.dart';
import 'generalProgressListMember.dart';
import 'progressListMember.dart';
import 'progressChart.dart';
import 'ProgressProvider.dart';

class ProgressWidget extends StatefulWidget {
  const ProgressWidget({super.key});

  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
    progressProvider.initializeTabBarController(this, 2);
    progressProvider.dropDownValueController = FormFieldController<String>("");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personalProvider =
        Provider.of<PersonalProvider>(context, listen: true);
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: true);
    return GestureDetector(
      onTap: () => progressProvider.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(progressProvider.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: progressProvider.scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: const Color(0xFF062029),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Progress',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  letterSpacing: 0.0,
                ),
              ),
            )

          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF062029),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: const Alignment(0.0, 0),
                        child: FlutterFlowButtonTabBar(
                          useToggleButtonStyle: true,
                          labelStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                          unselectedLabelStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                          labelColor: FlutterFlowTheme.of(context).tertiary,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          unselectedBackgroundColor: const Color(0xFFD7DBE1),
                          borderColor: const Color(0xFFBFCEDA),
                          unselectedBorderColor:
                              FlutterFlowTheme.of(context).alternate,
                          borderWidth: 2.0,
                          borderRadius: 8.0,
                          elevation: 0.0,
                          labelPadding: const EdgeInsetsDirectional.fromSTEB(
                              32.0, 0.0, 32.0, 0.0),
                          buttonMargin: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 0.0),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          tabs: const [
                            Tab(
                              text: 'Live',
                            ),
                            Tab(
                              text: 'General',
                            ),
                          ],
                          controller: progressProvider.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}][i]();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: progressProvider.tabBarController,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  HeadlineProgress(title: "Upcoming Workouts"),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: progressProvider
                                        .changeStrUpcomingLst()
                                        .length,
                                    itemBuilder: (context, index) {
                                      final workout = progressProvider
                                          .changeStrUpcomingLst()[index];

                                      return UpcomingWorkoutListMember(
                                          title: workout);
                                    },
                                  ),
                                  HeadlineProgress(title: "Achievements:"),
                                  Achievements(
                                      text: "Max Weight Lifted:",
                                      icon: Icons.fitness_center,
                                      measurement: "kg",
                                      color: Colors.red,
                                      val: progressProvider
                                          .achievements.maxWeight
                                          .toDouble()),
                                  Achievements(
                                      text: "Highest Reps",
                                      icon: Icons.repeat,
                                      measurement: "reps",
                                      color: Colors.red,
                                      val: progressProvider
                                          .achievements.highestReps
                                          .toDouble()),
                                  Achievements(
                                      text: "Longest Workout Duration:",
                                      icon: Icons.timer,
                                      measurement: "hours",
                                      color: Colors.red,
                                      val: progressProvider
                                          .achievements.longestWorkoutDuration
                                          .toDouble()),
                                  Achievements(
                                      text: "Lowest Body Fat Percentage:",
                                      icon: Icons.percent_outlined,
                                      measurement: "%",
                                      color: Colors.red,
                                      val: progressProvider
                                          .achievements.lowestBodyFatPercent
                                          .toDouble()),
                                  Achievements(
                                      text: "Longest Work Streak: ",
                                      icon: Icons.local_fire_department_rounded,
                                      measurement: "days",
                                      color: Colors.red,
                                      val: progressProvider
                                          .achievements.longestWorkoutStreak
                                          .toDouble()),
                                  HeadlineProgress(title: "Personal:"),
                                  Achievements(
                                      text: "Weight: ",
                                      icon: Icons.person_outline,
                                      measurement: "kg",
                                      color: Colors.red,
                                      val: personalProvider.user.info.weight),
                                  Achievements(
                                      text: "Height: ",
                                      icon: Icons.person_outline,
                                      measurement: "cm",
                                      color: Colors.red,
                                      val: personalProvider.user.info.height),
                                  Achievements(
                                      text: "Body Fat: ",
                                      icon: Icons.person_outline,
                                      measurement: "%",
                                      color: Colors.red,
                                      val: personalProvider.user.info.bodyFat),
                                  Achievements(
                                      text: "BMI: ",
                                      icon: Icons.person_outline,
                                      measurement: "",
                                      color: Colors.red,
                                      val: personalProvider.bmiValue),
                                  HeadlineProgress(
                                      title: "Progress Over Time:"),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 20.0, 0.0, 10),
                                    child: FlutterFlowDropDown<String>(
                                      controller: progressProvider
                                          .dropDownValueController,
                                      options: progressProvider.excList!,
                                      onChanged: (value) {
                                        progressProvider.dropDownClick(value!);
                                      },
                                      width: 350.0,
                                      height: 45.0,
                                      searchHintTextStyle:
                                          FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0.0,
                                              ),
                                      searchTextStyle:
                                          FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0.0,
                                              ),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0.0,
                                          ),
                                      searchHintText: 'Search For Exercises',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 20.0,
                                      ),
                                      borderColor: Colors.grey,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      elevation: 2.0,
                                      borderWidth: 2.0,
                                      borderRadius: 10.0,
                                      margin:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 4.0, 16.0, 4.0),
                                      isOverButton: true,
                                      isSearchable: true,
                                      isMultiSelect: false,
                                    ),
                                  ),
                                  TimePeriodSelector(
                                    clicked: progressProvider.clickPress,
                                    clickedChanged: progressProvider.dateClick,
                                    timePeriods: ['1W','1M','3M','6M','1Y'],
                                  ),
                                  Visibility(
                                    visible: progressProvider.visible,
                                    child: ProgressChart(
                                      exercise:
                                          progressProvider.dropDownValue ?? " ",
                                      value: 1,
                                      clicked: progressProvider.clickPress,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 0.0),
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      children: [
                                        GeneralProgress(
                                          title: 'Total Workouts',
                                          initialValue:
                                              "${progressProvider.achievements.totalWorkouts}",
                                          icon: Icons.fitness_center,
                                          color: Colors.tealAccent,
                                        ),
                                        GeneralProgress(
                                          title: 'Total Weight Lifted',
                                          initialValue:
                                              "${progressProvider.achievements.totalWeightLifted} kg",
                                          icon: Icons.local_fire_department,
                                          color: Colors.orangeAccent,
                                        ),
                                        GeneralProgress(
                                          title: 'Total Reps',
                                          initialValue:
                                              "${progressProvider.achievements.totalReps}",
                                          icon: Icons.repeat,
                                          color: Colors.greenAccent,
                                        ),
                                        GeneralProgress(
                                          title: 'Active Days',
                                          initialValue:
                                              "${progressProvider.achievements.activeDays}",
                                          icon: Icons.calendar_today,
                                          color: Colors.purpleAccent,
                                        ),
                                        GeneralProgress(
                                          title: 'Last Day Active',
                                          initialValue:
                                              "${progressProvider.achievements.lastActiveDay}",
                                          icon: Icons.timer,
                                          color: Colors.green,
                                        ),
                                        GeneralProgress(
                                          title: 'Total Workout Duration',
                                          initialValue:
                                              '${progressProvider.achievements.totalWorkoutDuration} hours',
                                          icon: Icons.timer,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  // Top Workouts
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: const Text(
                                      'History',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  TimePeriodSelector(
                                    clicked: progressProvider.historyPress,
                                    clickedChanged: progressProvider.dateClickHistory,
                                    timePeriods: ['All','1W','1M','3M','6M'],
                                  ),
                                  HistoryPage(clicked:progressProvider.historyPress),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
