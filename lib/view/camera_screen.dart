// ignore_for_file: deprecated_member_use

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
    // Using high resolution for better crop quality
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

      final bytes = await File(photo.path).readAsBytes();
      img.Image? original = img.decodeImage(bytes);

      if (original != null) {
        // Precise square crop from center
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
                // 1. Live Camera Preview
                Positioned.fill(child: CameraPreview(_controller)),

                // 2. Dark Mask Overlay with "Hole"
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7),
                      BlendMode.srcOut,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            backgroundBlendMode: BlendMode.dstOut,
                          ),
                        ),
                        // The "Clear" square
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Teal Border around the "Hole"
                Center(
                  child: Container(
                    width: 252, // Slightly larger than hole to show border
                    height: 252,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // 4. UI Elements (Text & Button)
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Text(
                    widget.isEnglish
                        ? "Center Sample in Box"
                        : "বক্সের মাঝখানে ছবি রাখুন",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _takeAndCropPicture,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.circle,
                          size: 75,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
        },
      ),
    );
  }
}
