import 'package:flutter/material.dart';

class ActivityTaskWidget extends StatelessWidget {
  final String taskDescription;
  final VoidCallback onComplete;

  const ActivityTaskWidget({super.key, required this.taskDescription, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Activity Task'),
      content: Text(taskDescription),
      actions: [
        TextButton(
          onPressed: onComplete,
          child: const Text('Complete'),
        ),
      ],
    );
  }
}