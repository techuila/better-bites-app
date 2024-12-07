import 'dart:io';

import 'package:betterbitees/ui/after_scan.dart';
import 'package:betterbitees/ui/history.dart';
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
                      icon: const Icon(Icons.history, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryPage()));
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
                          onPressed: () {
                            _capturePhoto(context);
                          },
                          child: const Icon(Icons.camera, color: Colors.black),
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

  Future<void> _capturePhoto(BuildContext context) async {
    if (!_cameraController.value.isInitialized || _isUploading) return;

    try {
      // Capture the image
      final XFile imageFile = await _cameraController.takePicture();

      // Save the captured image to the `_imageFile` variable
      setState(() {
        _imageFile = File(imageFile.path);
      });

      if (_imageFile != null) {
        // Pass the captured image to the text recognition service
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AfterScan(imageFile: _imageFile!),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to capture image.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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
              builder: (context) => AfterScan(imageFile: _imageFile!),
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
