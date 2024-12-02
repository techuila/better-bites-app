import 'dart:async';
import 'dart:io';

import 'package:betterbitees/services/food_ai_service.dart';
import 'package:betterbitees/ui/after_scan.dart';
import 'package:betterbitees/ui/camera.dart';
import 'package:betterbitees/ui/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Preview extends StatefulWidget {
  final File imageFile;

  const Preview({super.key, required this.imageFile});

  @override
  createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  final foodAiService = FoodAiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performTextRecognition(context, _analyzeFood);
    });
  }

  Future<void> _analyzeFood(BuildContext context, String ingredients) async {
    final payload = {'ingredients': ingredients};

    try {
      final foodAnalysisResponse = await foodAiService.analyzeFood(payload);

      if (context.mounted) {
        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AfterScan(
              imagePath: widget.imageFile.path,
              foodAnalysisResponse: foodAnalysisResponse,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing food: $e')),
        );
      }
    }
  }

  Future<void> _performTextRecognition(
      BuildContext context, Function callback) async {
    // Show the loading dialog
    showLoadingDialog(context);

    try {
      // Initialize the TextRecognizer
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      // Process the image using ML Kit
      final inputImage = InputImage.fromFile(widget.imageFile);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      textRecognizer.close();

      if (context.mounted) {
        // Perform the callback
        await callback(context, recognizedText.text);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      }
    } finally {
      if (context.mounted) {
        closeLoadingDialog(context);
      }
    }
  }

  Future<void> _reuploadPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Preview(imageFile: File(pickedFile.path)),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No image selected."),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Stack(children: [
                  Opacity(
                      opacity: 0.5,
                      child: Image.file(
                        widget.imageFile,
                        fit: BoxFit.cover,
                      ))
                ])),
          ),

          // Back Button
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Camera()),
                );
              },
            ),
          ),

          // Upload Image Button
          Positioned(
            bottom: 30,
            left: 50,
            child: IconButton(
              icon: const Icon(
                Icons.image,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () => _reuploadPhoto(context),
            ),
          ),

          // Scan Button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(Icons.camera, color: Colors.black),
                onPressed: () async {
                  //await Future.delayed(const Duration(seconds: 2));
                  //Navigator.push(
                  //  context,
                  //  MaterialPageRoute(
                  //    builder: (context) =>
                  //        AfterScan(imagePath: imageFile.path),
                  //  ),
                  //);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
