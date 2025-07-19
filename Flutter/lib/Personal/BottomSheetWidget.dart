import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A2A35),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.file_copy, color: Colors.white),
                title: Text('Pick from Device',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context, 'file');
                },
              ),
              ListTile(
                leading: Icon(Icons.link, color: Colors.white),
                title: Text('Enter URL', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context, 'url');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
