import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureTaskWidget extends StatefulWidget {
  final String instruction;
  final VoidCallback onComplete;

  const PictureTaskWidget({super.key, required this.instruction, required this.onComplete});

  @override
  State<PictureTaskWidget> createState() => _PictureTaskWidgetState();
}

class _PictureTaskWidgetState extends State<PictureTaskWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Picture Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.instruction),
          const SizedBox(height: 10),
          if (_image != null) const Text('Photo captured!'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _takePhoto,
          child: const Text('Take Photo'),
        ),
      ],
    );
  }
}