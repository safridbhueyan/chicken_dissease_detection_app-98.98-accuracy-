import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

// Image processing
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DiseaseProvider extends ChangeNotifier {
  File? _image;
  List? _outputs;
  bool _loading = false;

  File? get image => _image;
  List? get outputs => _outputs;
  bool get loading => _loading;

  bool _isEnglish = false;
  bool get isEnglish => _isEnglish;

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }

  DiseaseProvider() {
    _loading = true;
    loadModel().then((_) {
      _loading = false;
      notifyListeners();
    });
  }

  // 1️⃣ Load model
  Future loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      debugPrint("Model loaded successfully");
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  // 2️⃣ Pick image
  Future pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return;

    _image = File(pickedFile.path);
    _loading = true;
    notifyListeners();

    await classifyImage(_image!);
  }

  // 3️⃣ Classify image
  Future classifyImage(File image) async {
    final File processedImage = await _preprocessImage(image);

    final output = await Tflite.runModelOnImage(
      path: processedImage.path,
      numResults: 3,
      threshold: 0.2,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    _outputs = output;
    debugPrint(output.toString());

    _loading = false;
    notifyListeners();
  }

  // 🔥 PREPROCESS = ORIENTATION FIX → CENTER CROP → RESIZE (224x224)
  Future<File> _preprocessImage(File file) async {
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return file;

    // Fix camera orientation
    image = img.bakeOrientation(image);

    // Center crop (very important for Teachable Machine)
    final int cropSize = image.width < image.height
        ? image.width
        : image.height;

    final int xOffset = (image.width - cropSize) ~/ 2;
    final int yOffset = (image.height - cropSize) ~/ 2;

    img.Image cropped = img.copyCrop(
      image,
      x: xOffset,
      y: yOffset,
      width: cropSize,
      height: cropSize,
    );

    // Resize to 224x224
    img.Image resized = img.copyResize(
      cropped,
      width: 224,
      height: 224,
      interpolation: img.Interpolation.linear,
    );

    final tempDir = await getTemporaryDirectory();
    final processedFile = File(
      p.join(
        tempDir.path,
        'processed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    );

    await processedFile.writeAsBytes(img.encodeJpg(resized, quality: 100));

    return processedFile;
  }

  void reset() {
    _image = null;
    _outputs = null;
    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
