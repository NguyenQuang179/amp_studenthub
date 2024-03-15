import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputScreen extends StatelessWidget {
  final String initialText;

  const InputScreen({Key? key, required this.initialText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _descriptionController =
        TextEditingController(text: initialText);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Description'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter description...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Pass the text back to the previous screen
                Navigator.pop(context, _descriptionController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
