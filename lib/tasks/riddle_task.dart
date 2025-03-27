import 'package:flutter/material.dart';

class RiddleTaskWidget extends StatefulWidget {
  final String riddle;
  final String? answer;
  final VoidCallback onComplete;

  const RiddleTaskWidget({super.key, required this.riddle, this.answer, required this.onComplete});

  @override
  State<RiddleTaskWidget> createState() => _RiddleTaskWidgetState();
}

class _RiddleTaskWidgetState extends State<RiddleTaskWidget> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _submit() {
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = widget.answer?.toLowerCase();
    if (correctAnswer != null && userAnswer != correctAnswer) {
      setState(() {
        _errorText = 'Incorrect. Try again.';
      });
    } else {
      widget.onComplete();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Riddle Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.riddle),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Your Answer',
              errorText: _errorText,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
