import 'dart:io';

import 'package:betterbitees/ui/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  Future<void> recognizeText(BuildContext context, File imageFile,
      Future<void> Function(BuildContext, String) callback) async {
    // Show the loading dialog
    showLoadingDialog(context);

    try {
      // Initialize the TextRecognizer
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      // Process the image using ML Kit
      final inputImage = InputImage.fromFile(imageFile);
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
}
