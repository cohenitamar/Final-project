import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Social/SocialProvider.dart';

class FABWidget extends StatelessWidget {


  const FABWidget({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialProvider>(context,listen: false);

    return FloatingActionButton(
      onPressed:()=> provider.showCreateOptionsDialog(context),
      backgroundColor: const Color(0xFFEA6D13),
      child: Icon(Icons.add),
    );
  }
}
