// plan_list_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Login/LoginProvider.dart';
import '../../Progress/ProgressProvider.dart';
import '../../Social/SocialProvider.dart';
import '../PlanProvider.dart';
import '../PlanList/plan_data.dart'; // Import your PlanTile widget

class PlanListWidget extends StatefulWidget {
  const PlanListWidget({Key? key}) : super(key: key);

  @override
  _PlanListWidgetState createState() => _PlanListWidgetState();
}

class _PlanListWidgetState extends State<PlanListWidget> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    // Define custom colors and text styles
    const Color backgroundColor = Color(0xFF062029);
    const Color secondaryColor = Colors.white;

    const TextStyle headlineStyle = TextStyle(
      fontFamily: 'Outfit',
      color: secondaryColor,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    const TextStyle labelMediumStyle = TextStyle(
      fontFamily: 'Readex Pro',
      color: secondaryColor,
      fontSize: 16.0,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: secondaryColor),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plans', style: headlineStyle),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditMode ? Icons.check : Icons.edit,
              color: secondaryColor,
            ),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          ),
        ],
      ),
      body: Consumer<PlanProvider>(
        builder: (context, planProvider, child) {
          final plans = planProvider.plans;
          return plans.isEmpty
              ? Center(
                  child: Text(
                    'No exercises added yet.',
                    style: labelMediumStyle,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return PlanTile(
                      id: plan.id,
                      title: plan.title,
                      subTitle: plan.subTitle,
                      url: plan.url,
                      exercises: plan.exercises,
                      index: index,
                      cDate: plan.cDate,
                      isEditMode: isEditMode,
                      days: plan.days,
                      rating: plan.rating,
                      userID: plan.userID,
                      raters: plan.raters,
                    );
                  },
                );
        },
      ),
      floatingActionButton: const AddPlanButton(),
    );
  }
}

class AddPlanButton extends StatefulWidget {
  const AddPlanButton({Key? key}) : super(key: key);

  @override
  _AddPlanButtonState createState() => _AddPlanButtonState();
}

class _AddPlanButtonState extends State<AddPlanButton> {
  final TextEditingController _planTitleController = TextEditingController();
  final TextEditingController _planSubtitleController = TextEditingController();

  final Map<String, bool> _selectedDays = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
  };

  @override
  void dispose() {
    _planTitleController.dispose();
    _planSubtitleController.dispose();
    super.dispose();
  }

  void _showAddPlanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder to manage state inside the dialog
        return StatefulBuilder(
          builder: (context, setState) {
            // Define custom colors
            const Color backgroundColor = Color(0xFF062029);
            const Color secondaryColor = Colors.white;

            return AlertDialog(
              backgroundColor: backgroundColor,
              title: const Text(
                'Add Plan',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _planTitleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Plan Title',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _planSubtitleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Plan Subtitle',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Select Days',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    Column(
                      children: _selectedDays.keys.map((String day) {
                        return CheckboxListTile(
                          title: Text(day,
                              style: const TextStyle(color: Colors.white)),
                          value: _selectedDays[day],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedDays[day] = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _planTitleController.clear();
                    _planSubtitleController.clear();
                    _selectedDays.updateAll((key, value) => false);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_planTitleController.text.isNotEmpty &&
                        _planSubtitleController.text.isNotEmpty) {
                      List<String> selectedDays = _selectedDays.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .toList();

                      Provider.of<PlanProvider>(context, listen: false).addPlan(
                          _planTitleController.text,
                          _planSubtitleController.text,
                          "Not in use",
                          selectedDays,
                          Provider.of<ProgressProvider>(context,
                              listen: false));

                      _planTitleController.clear();
                      _planSubtitleController.clear();
                      _selectedDays.updateAll((key, value) => false);
                      final socialProvider =
                          Provider.of<SocialProvider>(context, listen: false);
                      final loginProvider =
                          Provider.of<LoginProvider>(context, listen: false);
                      Provider.of<PlanProvider>(context, listen: false)
                          .pickSuggestedPlans(socialProvider, loginProvider);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                        ),
                      );
                    }
                  },
                  child:
                      const Text('Add', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF913131);
    return FloatingActionButton(
      heroTag: "addPlanFAB",
      backgroundColor: primaryColor,
      onPressed: _showAddPlanDialog,
      child: const Icon(Icons.add),
    );
  }
}
