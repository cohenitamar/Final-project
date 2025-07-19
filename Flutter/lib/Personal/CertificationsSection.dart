import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../User/PersonalInformation.dart';
import 'PersonalProvider.dart';

class CertificationsSection extends StatelessWidget {
  final List<Certification> certifications;
  final String parentType;

  const CertificationsSection(
      {Key? key, required this.parentType, required this.certifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );
    final provider = Provider.of<PersonalProvider>(context, listen: true);

    // **Removed the early return here**
    // if (certifications.isEmpty) {
    //   return Text(
    //     'No certifications available.',
    //     style: TextStyle(color: Colors.grey.shade400),
    //   );
    // }

    // Create a list to hold all widgets
    List<Widget> certificationWidgets = [];

    // **Add a message if the certifications list is empty**
    if (certifications.isEmpty) {
      certificationWidgets.add(
        Text(
          'No certifications available.',
          style: TextStyle(color: Colors.grey.shade400),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      // Add the ListView.builder if there are certifications
      certificationWidgets.add(
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: certifications.length,
          itemBuilder: (context, index) {
            Certification cert = certifications[index];
            return Card(
              color: const Color(0xFF0A2A35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey.shade700),
              ),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: const Color(0xFFEA6D13),
                  size: 30.0,
                ),
                title: Text(
                  cert.title,
                  style: labelStyle,
                ),
                trailing: provider.isEditing && parentType == "personal"
                    ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.removeCert(index),
                      )
                    : Icon(Icons.open_in_new, color: Colors.white),
                onTap: () {
                  if (provider.isEditing && parentType == "personal") {
                    provider.updateCert(cert, index, context);
                  } else {
                    provider.showCert(cert, context);
                  }
                },
              ),
            );
          },
        ),
      );
    }

      // Add the "Add Certification" button if in editing mode
      if (provider.isEditing && parentType == "personal") {
        certificationWidgets.add(SizedBox(height: 16.0));
        certificationWidgets.add(
          ElevatedButton.icon(
            onPressed: () => provider.addCert(context),
            icon: Icon(Icons.add),
            label: Text('Add Certification'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              backgroundColor: const Color(0xFFEA6D13),
            ),
          ),
        );
      }


    // Return the column with the list of widgets
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: certificationWidgets,
    );
  }
}
