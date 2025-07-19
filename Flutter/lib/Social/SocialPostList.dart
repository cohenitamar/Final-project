import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PostCard.dart';
import 'Post.dart';
import 'SocialProvider.dart'; // Assuming you're using Provider

class SocialPostsList extends StatelessWidget {
  const SocialPostsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socialProvider = Provider.of<SocialProvider>(context, listen: true);

    if (socialProvider.isLoadingPosts) {
      // If still loading, show a loading indicator
      return const Center(child: CircularProgressIndicator());
    }

    if (socialProvider.posts.isEmpty) {
      return const Center(
        child: Text(
          'There are no posts.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }


    return ListView.builder(
      itemCount: socialProvider.posts.length,
      itemBuilder: (context, index) {
        Post ad = socialProvider.posts[index];
        return PostCard(ad: ad); // Refactor _buildAdvertisementCard into AdvertisementCard widget
      },
    );
  }
}
