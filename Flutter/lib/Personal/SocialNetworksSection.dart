import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PersonalProvider.dart';

class SocialNetworksSection extends StatelessWidget {
  final Map<String, String> socialAccounts;
  final String parentType;

  const SocialNetworksSection(
      {Key? key, required this.parentType, required this.socialAccounts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonalProvider>(context, listen: true);
    final TextStyle labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );

    // Define the list of widgets
    List<Widget> networkCards = socialAccounts.entries.map((entry) {
      String network = entry.key;
      String url = entry.value;

      return Card(
        color: const Color(0xFF0A2A35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey.shade700),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Image.asset(
            provider.getSocialIcon(network),
            width: 30.0,
            height: 30.0,
            fit: BoxFit.contain,
          ),
          title: Text(
            network,
            style: labelStyle,
          ),
          trailing: provider.isEditing && parentType == "personal"
              ? IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.removeNetwork(network),
                )
              : Icon(Icons.open_in_new, color: Colors.white),
          onTap: provider.isEditing && parentType == "personal"
              ? () => provider.updateNetwork(network, url, context)
              : () => provider.launchURL(url, context),
        ),
      );
    }).toList();

    // Add a message if the list is empty
    if (networkCards.isEmpty) {
      networkCards.add(
        Card(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No social networks linked.',
              style: TextStyle(color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Add the "Add Social Network" card if in editing mode
    if (provider.isEditing && parentType == "personal") {
      networkCards.add(
        Card(
          color: const Color(0xFF0A2A35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.grey.shade700),
          ),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () => provider.addNetwork(context),
            icon: Icon(Icons.add),
            label: Text('Add Social Network'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEA6D13),
              minimumSize: Size(double.infinity, 48),
            ),
          ),
        ),
      );
    }

    // Return the column with the list of network cards
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: networkCards,
    );
  }


}
