import 'package:IOFit/Adapters/PlanAdapter.dart';
import 'package:IOFit/Social/social_personal_widget.dart';
import 'package:IOFit/Social/social_information.dart';
import 'package:IOFit/api/social_api_service.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:IOFit/Social/plan_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Login/LoginProvider.dart';
import '../Plans/PlanList/plan_data.dart';
import '../Plans/plan_exercise.dart';
import '../Progress/ProgressProvider.dart';
import '../User/PersonalInformation.dart';
import '../User/User.dart'; // Import your user model
import '../file_handler.dart';
import '../models/fetchplanmodel.dart';
import '../models/fetchpostsmodel.dart';
import '../models/planmodel.dart';
import '../models/postmodel.dart';
import 'Post.dart';
import 'dart:math';
import '../Plans/PlanProvider.dart';
import 'SocialPlan.dart';

class SocialProvider with ChangeNotifier {
  bool _isLoadingPlans = false;
  bool _isLoadingPosts = false;

  bool get isLoadingPlans => _isLoadingPlans;

  bool get isLoadingPosts => _isLoadingPosts;

  final Dio _dio = Dio();
  late final SocialApiService _apiService = SocialApiService(_dio);
  late AppUser user;

  Map<String, List<bool>> votes = {};
  List<SocialPlan> _socialPlans = [];
  List<Post> _posts = [];

  // For filtering categories
  String _selectedCategory = 'All';

  // For filtering by user content only
  bool _showMyContentOnly = false;

  // Getter and setter for selectedCategory
  String get selectedCategory => _selectedCategory;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Getter and setter for my content only
  bool get showMyContentOnly => _showMyContentOnly;

  void toggleMyContentOnly() {
    _showMyContentOnly = !_showMyContentOnly;
    notifyListeners();
  }

  // Filter socialPlans based on category and _showMyContentOnly
  List<SocialPlan> get socialPlans {
    List<SocialPlan> filtered = _socialPlans;
    if (_selectedCategory != 'All') {
      filtered = filtered.where((plan) {
        return plan.plan.exercises.any(
          (exercise) => exercise.category == _selectedCategory,
        );
      }).toList();
    }
    if (_showMyContentOnly) {
      filtered = filtered.where((plan) => plan.plan.userID == user.id).toList();
    }
    return filtered;
  }

  // Filter posts based on _showMyContentOnly
  List<Post> get posts {
    if (_showMyContentOnly) {
      return _posts.where((post) => post.userID == user.id).toList();
    }
    return _posts;
  }

  /// Make `_tabController` nullable instead of `late`.
  TabController? _tabController;

  TabController? get tabController => _tabController;

  Future<String?> getUserToken() async {
    try {
      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in");
      }
      String? token = await currentUser.getIdToken();
      return "Bearer " + token!;
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  List<SocialPlan> convertFetchPlanModelsToSocialPlans(
      List<FetchPlanModel> planModels, bool isEditMode) {
    return planModels.map((plan) {
      final planTile = PlanTile(
        id: plan.id ?? "",
        userID: plan.userID ?? "",
        title: plan.title,
        subTitle: plan.subTitle,
        url: plan.img,
        exercises: plan.exercises?.map((exercise) {
              return PlanExercise(
                name: exercise.name,
                imagePath: exercise.img,
                category: exercise.category,
                rep: exercise.exerciseDetails.reps,
                sets: exercise.exerciseDetails.sets,
                weight: exercise.exerciseDetails.weight,
                checked: exercise.checked,
              );
            }).toList() ??
            [],
        index: 0,
        cDate: plan.creationDate,
        isEditMode: isEditMode,
        days: plan.days,
        rating: plan.rating.toInt(),
        raters: plan.raters ?? {},
      );

      final info = SocialInformation(
        firstName: plan.user.firstName,
        lastName: plan.user.lastName,
        profilePicture: plan.user.profilePicture,
        decodedProfilePicture: Utility.base64ToBytes(plan.user.profilePicture),
        age: plan.user.age,
        gender: plan.user.gender,
        occupation: plan.user.occupation,
        experienceLevel: plan.user.experienceLevel,
        certifications: plan.user.certifications
            .map((cert) => Certification(
                  title: cert.title,
                  link: cert.link,
                ))
            .toList(),
        languages: plan.user.languages,
        specializations: plan.user.specializations,
        socialAccounts: plan.user.socialAccounts,
      );

      return SocialPlan(plan: planTile, info: info);
    }).toList();
  }

  List<Post> convertPostModelsToPosts(List<FetchPostModel> postModels) {
    return postModels.map((post) {
      return Post(
        id: post.id,
        userID: post.userID,
        user: SocialInformation(
          firstName: post.user.firstName,
          lastName: post.user.lastName,
          profilePicture: post.user.profilePicture,
          decodedProfilePicture:
              Utility.base64ToBytes(post.user.profilePicture),
          age: post.user.age,
          gender: post.user.gender,
          occupation: post.user.occupation,
          experienceLevel: post.user.experienceLevel,
          certifications: post.user.certifications
              .map((cert) => Certification(
                    title: cert.title,
                    link: cert.link,
                  ))
              .toList(),
          languages: post.user.languages,
          specializations: post.user.specializations,
          socialAccounts: post.user.socialAccounts,
        ),
        title: post.title,
        description: post.content,
        imageUrl: post.img,
        timestamp: DateTime.parse(post.creationDate),
      );
    }).toList();
  }

  Future<void> fetchPosts() async {
    _isLoadingPosts = true;
    notifyListeners();
    String? token = await getUserToken();
    if (token != null) {
      List<FetchPostModel> postsList = await _apiService.getPosts(token);
      _posts = convertPostModelsToPosts(postsList);
    }

    _isLoadingPosts = false;
    notifyListeners();
  }

  Future<void> fetchPlans(PlanProvider planProvider,
      LoginProvider loginProvider, SocialProvider socialProvider) async {
    _isLoadingPlans = true;
    notifyListeners();
    String? token = await getUserToken();
    if (token != null) {
      List<FetchPlanModel> plans = await _apiService.getSharedPlans(token);
      _socialPlans = convertFetchPlanModelsToSocialPlans(plans, false);
      for (int i = 0; i < _socialPlans.length; i++) {
        planProvider.decidePicture(_socialPlans[i].plan);
      }
      planProvider.pickSuggestedPlans(socialProvider, loginProvider);
    }

    _isLoadingPlans = false;
    notifyListeners();
  }

  void createPost(Post ad) async {
    _posts.insert(0, ad);
    notifyListeners();
    String? token = await getUserToken();
    if (token != null) {
      PostModel newPost = PostModel(
        id: "",
        userID: ad.userID,
        title: ad.title,
        content: ad.description,
        img: ad.imageUrl,
        creationDate: ad.timestamp.toString(),
      );
      _apiService.createPost(token, newPost).then((res) {
        _posts[0].id = res;
        notifyListeners();
      });
    }
  }

  void deletePost(Post ad, BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    String? token = await getUserToken();
    if (ad.userID != loginProvider.user.uid) {
      return;
    }
    _posts.removeWhere((element) => element.id == ad.id);
    notifyListeners();
    if (token != null) {
      await _apiService.deletePost(token, ad.id);
    }
  }

  /// Call this AFTER the widget is built (e.g., in a post-frame callback in initState)
  /// so we don't get "notifyListeners during build" or a LateInitializationError for tabController.
  void initializeData(TickerProviderStateMixin tickerProvider, loginProvider,
      planProvider, socialProvider) {
    fetchPosts();
    fetchPlans(planProvider, loginProvider, socialProvider);
    _tabController = TabController(length: 2, vsync: tickerProvider);
    user = loginProvider.appUser;
  }

  void handleClickProfile(BuildContext context, user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SocialPersonalWidget(
          user: user,
        ),
      ),
    );
  }

  void ratePlan(int multiplicationFactor, PlanTile plan) {
    if (plan.rating == 0 && multiplicationFactor == -1) {
      return;
    }
    if (votes[plan.id] != null) {
      if ((multiplicationFactor == 1 && votes[plan.id]![0]) ||
          (multiplicationFactor == -1 && votes[plan.id]![1])) {
        return;
      }
    } else {
      votes[plan.id] = [false, false];
    }
    plan.rating += multiplicationFactor;
    votes[plan.id]?[multiplicationFactor == -1 ? 1 : 0] = true;
    votes[plan.id]?[multiplicationFactor == -1 ? 0 : 1] = false;
  }

  void likePlan(PlanTile plan) async {
    ratePlan(1, plan);
    notifyListeners();
    String? token = await getUserToken();
    if (token != null) {
      await _apiService.like(token, plan.id);
    }
  }

  void dislikePlan(PlanTile plan) async {
    ratePlan(-1, plan);
    notifyListeners();
    String? token = await getUserToken();
    if (token != null) {
      await _apiService.dislike(token, plan.id);
    }
  }

  void clickOnPlan(BuildContext context, PlanTile plan) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanOverviewPage(plan: plan)),
    );
  }

  void addPlanToMyPlans(BuildContext context, PlanTile plan) async {
    PlanProvider planProvider =
        Provider.of<PlanProvider>(context, listen: false);
    planProvider.addSharedPlan(plan);
    notifyListeners();
    String? token = await getUserToken();
    if (token != null) {
      _apiService.addSharedPlan(token, plan.id);
    }
  }

  void showCreatePostDialog(BuildContext context) {
    String title = '';
    String description = '';
    String selectedImage = '';
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0A2A35),
            // Use a Row for the title so we can place an X button on the right
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create Post',
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Post Title',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF1A3A4A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Post Description',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF1A3A4A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) => description = value,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Post Image',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            selectedImage = pickedFile.path;
                          });
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8.0),
                          image: selectedImage.isNotEmpty
                              ? DecorationImage(
                                  image:
                                      Utility.getImageProvider(selectedImage),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: selectedImage.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add_a_photo,
                                        color: Colors.white, size: 40),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Tap to select an image',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFFEA6D13)),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text(
                  'Post',
                  style: TextStyle(color: Color(0xFFEA6D13)),
                ),
                onPressed: () {
                  if (title.trim().isNotEmpty &&
                      description.trim().isNotEmpty) {
                    if (selectedImage.isNotEmpty) {
                      Utility.fileToBase64(selectedImage).then((pic) {
                        createPost(
                          Post(
                            userID: user.id,
                            id: 'ad_${Random().nextInt(10000)}',
                            user: SocialInformation(
                              firstName: user.firstName,
                              lastName: user.lastName,
                              profilePicture: user.profilePicture,
                              decodedProfilePicture:
                                  Utility.base64ToBytes(user.profilePicture),
                              age: user.info.age,
                              gender: user.info.gender,
                              occupation: user.info.occupation,
                              experienceLevel: user.info.experienceLevel,
                              certifications: user.info.certifications
                                  .map((cert) => Certification(
                                        title: cert.title,
                                        link: cert.link,
                                      ))
                                  .toList(),
                              languages: user.info.languages,
                              specializations: user.info.specializations,
                              socialAccounts: user.info.socialAccounts,
                            ),
                            title: title.trim(),
                            description: description.trim(),
                            imageUrl: pic,
                            timestamp: DateTime.now(),
                          ),
                        );
                      });
                    } else {
                      createPost(
                        Post(
                          userID: user.id,
                          id: 'ad_${Random().nextInt(10000)}',
                          user: SocialInformation(
                            firstName: user.firstName,
                            lastName: user.lastName,
                            profilePicture: user.profilePicture,
                            decodedProfilePicture:
                                Utility.base64ToBytes(user.profilePicture),
                            age: user.info.age,
                            gender: user.info.gender,
                            occupation: user.info.occupation,
                            experienceLevel: user.info.experienceLevel,
                            certifications: user.info.certifications
                                .map((cert) => Certification(
                                      title: cert.title,
                                      link: cert.link,
                                    ))
                                .toList(),
                            languages: user.info.languages,
                            specializations: user.info.specializations,
                            socialAccounts: user.info.socialAccounts,
                          ),
                          title: title.trim(),
                          description: description.trim(),
                          imageUrl: "N/A",
                          timestamp: DateTime.now(),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields.'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void sharePlan(PlanTile plan, BuildContext context) async {
    SocialPlan sPlan = SocialPlan(
      plan: plan,
      info: SocialInformation(
        firstName: user.firstName,
        lastName: user.lastName,
        profilePicture: user.profilePicture,
        decodedProfilePicture: Utility.base64ToBytes(user.profilePicture),
        age: user.info.age,
        gender: user.info.gender,
        occupation: user.info.occupation,
        experienceLevel: user.info.experienceLevel,
        certifications: user.info.certifications,
        languages: user.info.languages,
        specializations: user.info.specializations,
        socialAccounts: user.info.socialAccounts,
      ),
    );
    _socialPlans.add(sPlan);
    String? token = await getUserToken();
    notifyListeners();
    if (token != null) {
      await _apiService.sharePlan(token, plan.id);
    }
  }

  void showSelectPlanToShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<PlanProvider>(
          builder: (context, planProvider, child) {
            List<PlanTile> myPlans = planProvider.plans;
            return AlertDialog(
              backgroundColor: const Color(0xFF0A2A35),
              title: const Text('Select a plan to share',
                  style: TextStyle(color: Colors.white)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: myPlans.length,
                  itemBuilder: (context, index) {
                    PlanTile plan = myPlans[index];
                    return ListTile(
                      leading: plan.url.isNotEmpty
                          ? Image.network(
                              plan.url,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.fitness_center,
                              color: Colors.white),
                      title: Text(plan.title,
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        sharePlan(plan, context);
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

  void reset() {
    _isLoadingPlans = false;
    _isLoadingPosts = false;

    // If you need to reset user to a blank state, do so here:
    // user = AppUser(...); // or remove this line if you want to keep `user`

    votes.clear();
    _socialPlans.clear();
    _posts.clear();

    _selectedCategory = 'All';
    _showMyContentOnly = false;

    _tabController?.dispose();
    _tabController = null;

    notifyListeners();
  }

  void showCreateOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A2A35),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.white),
              title: const Text('Share plan',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                showSelectPlanToShareDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign, color: Colors.white),
              title: const Text('Create post',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                showCreatePostDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
