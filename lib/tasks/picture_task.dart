import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  bool _isSubmitting = false;

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _submitPhoto() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take a photo before checking in.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final uri = Uri.parse('https://example.com/upload'); // Replace with actual upload URL
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('photo', _image!.path),
    );

    final response = await request.send();

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 200) {
      widget.onComplete();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Picture Task',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(widget.instruction),
            const SizedBox(height: 20),
            if (_image != null)
              Column(
                children: [
                  const Text(
                    '✅ Photo captured!',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.file(
                    File(_image!.path),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitPhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Submit Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
