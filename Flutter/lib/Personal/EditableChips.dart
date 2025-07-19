import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PersonalProvider.dart'; // Assuming you are using Provider for state management

class EditableChips extends StatelessWidget {
  final List<String> items;
  final Function(String) onAdd;
  final Function(String) onDelete;

  const EditableChips({
    Key? key,
    required this.items,
    required this.onAdd,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonalProvider>(context, listen: true);

    return Wrap(
      spacing: 8.0,
      children: [
        ...items.map((item) => Chip(
          label: Text(item),
          deleteIcon: Icon(Icons.close),
          onDeleted: () {
            onDelete(item);
          },
        )),
        ActionChip(
          label: Icon(Icons.add),
          onPressed: () async {
            String? newItem = await provider.showTextInputDialog(context);
            if (newItem != null && newItem.isNotEmpty) {
              onAdd(newItem);
            }
          },
        ),
      ],
    );
  }
}
