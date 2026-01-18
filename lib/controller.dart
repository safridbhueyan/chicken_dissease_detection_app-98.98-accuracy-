import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class DiseaseProvider extends ChangeNotifier {
  File? _image;
  List? _outputs;
  bool _loading = false;

  File? get image => _image;
  List? get outputs => _outputs;
  bool get loading => _loading;

  DiseaseProvider() {
    _loading = true;
    loadModel().then((value) {
      _loading = false;
      notifyListeners();
    });
  }

  // 1. Load the TFLite model
  Future loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // 2. Pick Image
  Future pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) return;

    _image = File(pickedFile.path);
    _loading = true;
    notifyListeners();

    await classifyImage(_image!);
  }

  // 3. Classify
  Future classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    _outputs = output;
    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
