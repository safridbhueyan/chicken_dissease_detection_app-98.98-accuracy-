import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img; // Use your existing import

class CameraScanScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool isEnglish;
  const CameraScanScreen({
    super.key,
    required this.cameras,
    required this.isEnglish,
  });

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takeAndCropPicture() async {
    try {
      await _initializeControllerFuture;
      final XFile photo = await _controller.takePicture();

      // Load image bytes
      final bytes = await File(photo.path).readAsBytes();
      img.Image? original = img.decodeImage(bytes);

      if (original != null) {
        // Calculate crop for center square
        int size = original.width < original.height
            ? original.width
            : original.height;
        int x = (original.width - size) ~/ 2;
        int y = (original.height - size) ~/ 2;

        img.Image cropped = img.copyCrop(
          original,
          x: x,
          y: y,
          width: size,
          height: size,
        );

        // Save cropped image back to file path
        final croppedFile = File(photo.path)
          ..writeAsBytesSync(img.encodeJpg(cropped));
        if (mounted) Navigator.pop(context, croppedFile);
      }
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(child: CameraPreview(_controller)),
                // The Crop Overlay
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Text instruction
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Text(
                    widget.isEnglish
                        ? "Center the sample in the box"
                        : "বক্সের মাঝখানে স্যাম্পলটি রাখুন",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Capture Button
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _takeAndCropPicture,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lens,
                          size: 70,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
