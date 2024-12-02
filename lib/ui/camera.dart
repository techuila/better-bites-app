import 'dart:io';

import 'package:betterbitees/ui/after_scan.dart';
import 'package:betterbitees/ui/preview.dart';
import 'package:betterbitees/ui/profiling.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isInitialized = false;
  bool _isUploading = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[0],
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isInitialized
            ? Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width:
                                  _cameraController.value.previewSize!.height,
                              height:
                                  _cameraController.value.previewSize!.width,
                              child: CameraPreview(_cameraController),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Top Buttons
                  Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        _showExitConfirmationDialog(context);
                      },
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.flash_on, color: Colors.white),
                      onPressed: () async {
                        // Toggle Flash Mode
                        FlashMode currentMode =
                            _cameraController.value.flashMode;
                        FlashMode nextMode = currentMode == FlashMode.torch
                            ? FlashMode.off
                            : FlashMode.torch;
                        await _cameraController.setFlashMode(nextMode);
                        setState(() {});
                      },
                    ),
                  ),

                  // Bottom Bar (Capture/Scan, Upload Image, Switch Camera)
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () {
                            _uploadPhoto(context);
                          },
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.camera, color: Colors.black),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AfterScan(
                                        imagePath: '',
                                      )),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.switch_camera,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () async {
                            // Switch Camera Button
                            int nextCameraIndex = (_cameras.indexOf(
                                        _cameraController.description) +
                                    1) %
                                _cameras.length;
                            _cameraController = CameraController(
                              _cameras[nextCameraIndex],
                              ResolutionPreset.high,
                            );
                            await _cameraController.initialize();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Are you sure you want to exit scanning?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //No button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Yes button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilingQuestionsPage()),
                      );
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadPhoto(BuildContext context) async {
    if (_isUploading) return;
    setState(() {
      _isUploading = true;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Preview(imageFile: _imageFile!),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("No image selected."),
          ));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $e"),
        ));
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
