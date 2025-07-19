import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../file_handler.dart';
import 'Post.dart';
import 'SocialProvider.dart';

class PostCard extends StatelessWidget {
  final Post ad;

  const PostCard({
    Key? key,
    required this.ad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socialProvider = Provider.of<SocialProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Colors.white),
      ),
      child: Column(
        children: [
          if (ad.imageUrl != "N/A")
            Image(
              image: Utility.getImageProvider(ad.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                );
              },
            ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: Utility.getImageProvider(ad.user.profilePicture),
            ),
            // We use a Column for the title to add "Name" above ad.title
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temporary placeholder: "Name"
                Text(
                  ad.user.firstName + " " + ad.user.lastName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ad.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                Text(
                  ad.description,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Posted ${timeago.format(ad.timestamp)}',
                  style: const TextStyle(color: Colors.black, fontSize: 12.0),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Icon
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.black),
                  onPressed: () {
                    // Navigate to the user's profile in read-only mode
                    socialProvider.handleClickProfile(context, ad.user);
                  },
                ),
                // Delete Icon (conditionally displayed)
                if (socialProvider.user.id == ad.userID)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, socialProvider);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, SocialProvider socialProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text(
              'Are you sure you want to delete this post? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                socialProvider.deletePost(ad, context);
                // Optionally show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post deleted')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
