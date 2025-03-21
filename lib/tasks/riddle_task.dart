import 'package:flutter/material.dart';

class RiddleTaskWidget extends StatelessWidget {
  final String riddle;
  final VoidCallback onComplete;

  const RiddleTaskWidget({super.key, required this.riddle, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Riddle Task'),
      content: Text(riddle),
      actions: [
        TextButton(
          onPressed: onComplete,
          child: const Text('Solved'),
        ),
      ],
    );
  }
}