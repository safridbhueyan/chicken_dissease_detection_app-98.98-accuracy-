import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:murgi_care/view/camera_screen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:image_cropper/image_cropper.dart'; // Added this

class DiseaseProvider extends ChangeNotifier {
  File? _image;
  List<dynamic>? _outputs;
  bool _loading = false;
  Interpreter? _interpreter;
  List<String>? _labels;

  bool _isEnglish = false;
  bool get isEnglish => _isEnglish;
  File? get image => _image;
  List<dynamic>? get outputs => _outputs;
  bool get loading => _loading;

  DiseaseProvider() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      final labelData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }

  void reset() {
    _image = null;
    _outputs = null;
    _loading = false;
    notifyListeners();
  }

  // --- Main Pick Image Logic ---
  Future<void> pickImage(ImageSource source, BuildContext context) async {
    File? initialFile;

    if (source == ImageSource.camera) {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      initialFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CameraScanScreen(cameras: cameras, isEnglish: _isEnglish),
        ),
      );
    } else {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) initialFile = File(pickedFile.path);
    }

    if (initialFile == null) return;

    // --- APPLY CROP TO BOTH SOURCES ---
    final croppedFile = await _cropImage(initialFile.path);
    if (croppedFile == null) return;

    _image = File(croppedFile.path);
    _loading = true;
    notifyListeners();

    await _processImage(_image!);
  }

  // --- Unified Cropping Helper ---
  Future<CroppedFile?> _cropImage(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      // Force the aspect ratio to be square
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: _isEnglish ? 'Crop Sample' : 'ক্রপ করুন',
          toolbarColor: Colors.teal,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true, // User MUST crop in a square
          hideBottomControls:
              true, // Makes the UI cleaner since they can't change ratio
        ),
        IOSUiSettings(
          title: _isEnglish ? 'Crop Sample' : 'ক্রপ করুন',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
  }

  Future<void> _processImage(File file) async {
    try {
      if (_interpreter == null) {
        await _loadModel();
        if (_interpreter == null)
          throw Exception("Interpreter not initialized");
      }

      final imageData = await file.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageData);
      if (originalImage == null) throw Exception("Failed to decode image");

      img.Image resizedImage = img.copyResize(
        originalImage,
        width: 224,
        height: 224,
      );

      var input = Float32List(1 * 224 * 224 * 3);
      var buffer = Float32List.view(input.buffer);
      int pixelIndex = 0;
      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          var pixel = resizedImage.getPixel(x, y);
          buffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
          buffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
          buffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
        }
      }

      var output = List.filled(
        1 * _labels!.length,
        0.0,
      ).reshape([1, _labels!.length]);
      _interpreter!.run(input.reshape([1, 224, 224, 3]), output);

      List<double> probabilities = List<double>.from(output[0]);
      int bestIndex = 0;
      double maxProb = -1.0;
      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          bestIndex = i;
        }
      }

      _outputs = [
        {'label': _labels![bestIndex], 'confidence': maxProb},
      ];
    } catch (e) {
      debugPrint("Error processing image: $e");
      _outputs = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}
