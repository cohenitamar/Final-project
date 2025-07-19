// plan_tile.dart


import 'package:collection/collection.dart';

import '../History.dart';

import 'package:IOFit/Plans/plan_exercise.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../PlanProvider.dart';
import '../PlanStart/plan_start.dart';


class PlanTile extends StatefulWidget {
  final String userID;
  String id;
  final String title;
  final String subTitle;
  String url;
  final List<PlanExercise> exercises;
  final int index;
  final String cDate;
  final bool isEditMode;
  final List<String> days;
  int rating;
  final Map<String, dynamic> raters;

  PlanTile({
    required this.id,
    required this.userID,
    required this.title,
    required this.subTitle,
    required this.url,
    required this.exercises,
    required this.index,
    required this.cDate,
    required this.isEditMode,
    required this.days,
    required this.rating,
    required this.raters
  });

  @override
  _PlanTileState createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  bool isEditingTitle = false;
  bool isEditingSubtitle = false;
  bool isEditingDays = false;

  final List<String> orderedDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  late Map<String, bool> _selectedDays;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _subtitleController = TextEditingController(text: widget.subTitle);
    _initializeSelectedDays();
  }

  void _initializeSelectedDays() {
    _selectedDays = {
      for (var day in orderedDays) day: false,
    };
    for (var day in widget.days) {
      _selectedDays[day] = true;
    }
  }

  @override
  void didUpdateWidget(covariant PlanTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if isEditMode changed from true to false
    if (oldWidget.isEditMode && !widget.isEditMode) {
      // Save any pending changes when exiting edit mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePlan(); // This will now run after the build is complete
      });

      setState(() {
        // Reset all editing states
        isEditingTitle = false;
        isEditingSubtitle = false;
        isEditingDays = false;
      });
    }
    // Update controllers if title or subtitle has changed
    if (widget.title != oldWidget.title) {
      _titleController.text = widget.title;
    }
    if (widget.subTitle != oldWidget.subTitle) {
      _subtitleController.text = widget.subTitle;
    }
    // Update selected days if days list has changed
    if (!ListEquality().equals(widget.days, oldWidget.days)) {
      _initializeSelectedDays();
    }
  }

  void _updatePlan() {
    final newTitle = _titleController.text;
    final newSubtitle = _subtitleController.text;
    final newDays =
        orderedDays.where((day) => _selectedDays[day] == true).toList();

    Provider.of<PlanProvider>(context, listen: false).updatePlan(
      widget.index,
      newTitle: newTitle,
      newSubtitle: newSubtitle,
      newDays: newDays,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _cancelDaysEditing() {
    setState(() {
      isEditingDays = false;
      _initializeSelectedDays(); // Reset to the original days
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                widget.url,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
            title: widget.isEditMode
                ? isEditingTitle
                    ? TextField(
                        controller: _titleController,
                        autofocus: true,
                        onSubmitted: (_) {
                          setState(() {
                            isEditingTitle = false;
                          });
                          _updatePlan(); // Update the plan after editing title
                        },
                        onEditingComplete: () {
                          setState(() {
                            isEditingTitle = false;
                          });
                          _updatePlan();
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditingTitle = true;
                          });
                        },
                        child: Text(
                          _titleController.text,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      )
                : Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isEditMode
                    ? isEditingSubtitle
                        ? TextField(
                            controller: _subtitleController,
                            autofocus: true,
                            onSubmitted: (_) {
                              setState(() {
                                isEditingSubtitle = false;
                              });
                              _updatePlan(); // Update the plan after editing subtitle
                            },
                            onEditingComplete: () {
                              setState(() {
                                isEditingSubtitle = false;
                              });
                              _updatePlan();
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditingSubtitle = true;
                              });
                            },
                            child: Text(
                              _subtitleController.text,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                    : Text(
                        widget.subTitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                const SizedBox(height: 8.0),
                widget.isEditMode
                    ? isEditingDays
                        ? Column(
                            children: [
                              ...orderedDays.map((String day) {
                                return CheckboxListTile(
                                  title: Text(day),
                                  value: _selectedDays[day],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _selectedDays[day] = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              }).toList(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: _cancelDaysEditing,
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isEditingDays = false;
                                      });
                                    },
                                    child: const Text('Done'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditingDays = true;
                              });
                            },
                            child: Text(
                              'Days: ${orderedDays.where((day) => _selectedDays[day] == true).join(', ')}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                    : Text(
                        'Days: ${orderedDays.where((day) => widget.days.contains(day)).join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
              ],
            ),
            onTap: () {
              if (!widget.isEditMode) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanStartWidget(
                      planId: widget.index,
                    ),
                  ),
                );
              }
            },
            trailing: widget.isEditMode
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<PlanProvider>(context, listen: false)
                          .removePlan(widget.index);
                    },
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

List<ExecutedPlan> putellasHistory = [
  ExecutedPlan(
      id: "1",
      title: "My first workout",
      exercises: [
        PlanExercise(
          name: "Atlas Stones",
          imagePath: "assets/dataset/Atlas_Stones/LowerBack_Atlas_Stones.gif",
          category: "LowerBack",
          sets: 1,
          rep: 7,
          weight: 5,
          checked: true,
        ),
        PlanExercise(
            name: "Car driver",
            imagePath: "assets/dataset/Car_driver/Shoulders_Car_driver.gif",
            category: "Shoulders",
            sets: 2,
            rep: 3,
            weight: 3,
            checked: false),
        PlanExercise(
            name: "Clean",
            imagePath: "assets/dataset/Clean/Hamstrings_Clean.gif",
            category: "Hamstrings",
            sets: 3,
            rep: 7,
            weight: 3,
            checked: false),
        PlanExercise(
            name: "Cocoons",
            imagePath: "assets/dataset/Cocoons/Abdominals_Cocoons.gif",
            category: "Abdominals",
            sets: 4,
            rep: 5,
            weight: 13,
            checked: true)
      ],
      executionDate: "04.11.2015",
      executionTime: "00:00:10",
      finished: true),
  ExecutedPlan(
      id: "1",
      title: "My first workout",
      exercises: [
        PlanExercise(
            name: "Ab Roller",
            imagePath: "assets/dataset/Ab_Roller/Abdominals_Ab_Roller.gif",
            category: "Abdominals",
            sets: 3,
            rep: 10,
            weight: 7,
            checked: true),
        PlanExercise(
            name: "Ab bicycle",
            imagePath: "assets/dataset/Ab_bicycle/Abdominals_Ab_bicycle.gif",
            category: "Abdominals",
            sets: 4,
            rep: 9,
            weight: 9,
            checked: false),
        PlanExercise(
            name: "Arnold press",
            imagePath: "assets/dataset/Arnold_press/Shoulders_Arnold_press.gif",
            category: "Shoulders",
            sets: 2,
            rep: 8,
            weight: 10,
            checked: true)
      ],
      executionDate: "08.12.2018",
      executionTime: "00:00:20",
      finished: true),
];

List<PlanTile> exercisesData = [
  PlanTile(
      id: "d6c27a8a-2e42-4b1a-84d5-8a8d5c2e2a2c",
      title: "Plan_1",
      userID: "_________",
      index: 0,
      raters: {},
      subTitle: "2",
      isEditMode: false,
      days: ["Thursday", "Friday", "Sunday"],
      rating: 0,
      url: "https://media.istockphoto.com/id/116180672/photo/dark-black-and-white-television-static.jpg?s=612x612&w=0&k=20&c=WTLAPJKvNbhysXE-loVBqspxIchY30uu2l2d37Q8PlA=",
      cDate: DateFormat('dd.MM.yyyy').format(DateTime.now()),
      exercises: [
        PlanExercise(
            name: "Ab Roller",
            imagePath: "assets/dataset/Ab_Roller/Abdominals_Ab_Roller.gif",
            category: "Abdominals",
            sets: 3,
            rep: 10,
            weight: 7,
            checked: false),
        PlanExercise(
            name: "Ab bicycle",
            imagePath: "assets/dataset/Ab_bicycle/Abdominals_Ab_bicycle.gif",
            category: "Abdominals",
            sets: 4,
            rep: 9,
            weight: 9,
            checked: false),
        PlanExercise(
            name: "Arnold press",
            imagePath: "assets/dataset/Arnold_press/Shoulders_Arnold_press.gif",
            category: "Shoulders",
            sets: 2,
            rep: 8,
            weight: 10,
            checked: false)
      ]),
  PlanTile(
      id: "d6c27a8a-2e42-4b1a-84d5-8a8d5c2e2a21",
      title: "Plan_2",
      index: 1,
      userID: "_________",
      subTitle: "1",
      raters: {},
      isEditMode: false,
      days: ["Friday", "Monday"],
      rating: 0,
      cDate: DateFormat('dd.MM.yyyy').format(DateTime.now()),
      url: "https://media.istockphoto.com/id/116180672/photo/dark-black-and-white-television-static.jpg?s=612x612&w=0&k=20&c=WTLAPJKvNbhysXE-loVBqspxIchY30uu2l2d37Q8PlA=",
      exercises: [
        PlanExercise(
            name: "Atlas Stones",
            imagePath: "assets/dataset/Atlas_Stones/LowerBack_Atlas_Stones.gif",
            category: "LowerBack",
            sets: 1,
            rep: 7,
            weight: 5,
            checked: false),
        PlanExercise(
            name: "Car driver",
            imagePath: "assets/dataset/Car_driver/Shoulders_Car_driver.gif",
            category: "Shoulders",
            sets: 2,
            rep: 3,
            weight: 3,
            checked: false),
        PlanExercise(
            name: "Clean",
            imagePath: "assets/dataset/Clean/Hamstrings_Clean.gif",
            category: "Hamstrings",
            sets: 3,
            rep: 7,
            weight: 3,
            checked: false),
        PlanExercise(
            name: "Cocoons",
            imagePath: "assets/dataset/Cocoons/Abdominals_Cocoons.gif",
            category: "Abdominals",
            sets: 4,
            rep: 5,
            weight: 13,
            checked: false)
      ]),
];

/*List<PlanTile> exercisesData = [
  PlanTile(
      title: "Neta",
      subTitle: "2",
      url: "https://i.imgur.com/zXeEYo3.png",
      exercises: const [
        "assets/dataset/Ab_Roller/Abdominals_Ab_Roller.gif",
        "assets/dataset/Ab_bicycle/Abdominals_Ab_bicycle.gif",
        "assets/dataset/Arnold_press/Shoulders_Arnold_press.gif"
      ]),
  PlanTile(
      title: "Osher",
      subTitle: "1",
      url: "https://i.imgur.com/4MEYh76.png",
      exercises: const [
        "assets/dataset/Atlas_Stones/LowerBack_Atlas_Stones.gif",
        "assets/dataset/Car_driver/Shoulders_Car_driver.gif",
        "assets/dataset/Clean/Hamstrings_Clean.gif",
        "assets/dataset/Cocoons/Abdominals_Cocoons.gif"
      ]),
];*/
