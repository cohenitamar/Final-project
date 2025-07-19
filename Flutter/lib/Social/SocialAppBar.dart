import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Login/LoginProvider.dart';
import '../Plans/PlanList/plan_data.dart';
import '../Plans/PlanProvider.dart';
import 'SocialProvider.dart';

class SocialAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const SocialAppBar({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socialProvider = Provider.of<SocialProvider>(context);
    final planProvider = Provider.of<PlanProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return AppBar(
      title: Text('Social Feed'),
      backgroundColor: const Color(0xFF062029),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.white,
          onPressed: () {
            socialProvider.fetchPlans(planProvider, loginProvider, socialProvider);
            socialProvider.fetchPosts();
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: () => _showCreateOptionsDialog(context),
        ),
        IconButton(
          icon: Icon(
            socialProvider.showMyContentOnly ? Icons.filter_list_off : Icons.filter_list,
          ),
          color: Colors.white,
          onPressed: () {
            socialProvider.toggleMyContentOnly();
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(48.0),
        child: Container(
          color: const Color(0xFF0A2A35),
          child: TabBar(
            controller: tabController,
            indicatorColor: const Color(0xFFEA6D13),
            tabs: const [
              Tab(text: 'Plans'),
              Tab(text: 'Posts'),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A2A35),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.fitness_center, color: Colors.white),
              title: Text('Share plan', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showSelectPlanToShareDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.campaign, color: Colors.white),
              title: Text('Create post', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                final socialProvider =
                Provider.of<SocialProvider>(context, listen: false);
                socialProvider.showCreatePostDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectPlanToShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<PlanProvider>(
          builder: (context, planProvider, child) {
            List<PlanTile> myPlans = planProvider.plans;
            return AlertDialog(
              backgroundColor: const Color(0xFF0A2A35),
              // Wrap the title in a Row to add the X button on the right
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select a Plan to Share',
                    style: TextStyle(color: Colors.white),
                  ),
                  // The X button to close the dialog
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: myPlans.length,
                  itemBuilder: (context, index) {
                    PlanTile plan = myPlans[index];
                    return ListTile(
                      leading: plan.url.isNotEmpty
                          ? Image.asset(
                        plan.url,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.fitness_center, color: Colors.white),
                      title: Text(
                        plan.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<SocialProvider>(context, listen: false)
                            .sharePlan(plan, context);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 48.0);
}
