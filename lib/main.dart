// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_to_list_in_spreads, unused_field, prefer_final_fields, prefer_const_constructors, use_full_hex_values_for_flutter_colors, unused_element, non_constant_identifier_names, unused_import
import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: HomePage(), debugShowCheckedModeBanner: false);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //ALERT DIALOG
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //EXIT ICON
              IconButton(
                icon:
                    const Icon(Icons.close, color: Color(0xFF1A5319), size: 25),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          //EXIT MESSAGE/
          content: const Text(
            'Are you sure you want to exit?',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
            textAlign: TextAlign.center,
          ),
          //YES BUTTON
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1A5319), width: 1),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text('Yes',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.white)),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),

            // NO BUTTON
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF14AE5C),
                side: const BorderSide(
                    color: Color(0xFF1A5319), width: 1), // Border color
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text('No',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        //SETTINGS ICON
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Color(0xFF1A5319),
              size: 32,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/bblogo.png',
              fit: BoxFit.contain,
              height: 220,
            ),

            //SCAN BUTTON
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilingQuestionsPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF0d522c),
                side: const BorderSide(color: Color(0xFF598757), width: 1),
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 64.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: const Text(
                'SCAN',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),

            //EXIT BUTTON
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                _showExitDialog(context);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF0d522c),
                side: const BorderSide(color: Color(0xFF598757), width: 1),
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 70.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              child: const Text(
                'EXIT',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//INFO PAGE
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: const Center(
        child: Text('Info Page  '),
      ),
    );
  }
}

// CAMERA SCANNER
class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  final textRecognizer = TextRecognizer();
  bool _isInitialized = false;
  bool _isUploading = false;
  bool _isLoading = true;
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
    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmationDialog(context);
        return false;
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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Preview(imageFile: _imageFile!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No image selected."),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}

//PREVIEW PAGE
class Preview extends StatefulWidget {
  final File imageFile;

  const Preview({super.key, required this.imageFile});

  @override
  createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  List<TextBlock> _recognizedBlocks = [];
  double _imageWidth = 1.0;
  double _imageHeight = 1.0;

  @override
  void initState() {
    super.initState();
    _loadImageDimensions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performTextRecognition(context);
    });
  }

  // Load image dimensions for scaling bounding boxes
  Future<void> _loadImageDimensions() async {
    final completer = Completer<ui.Image>();
    final image = Image.file(widget.imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    final uiImage = await completer.future;
    setState(() {
      _imageWidth = uiImage.width.toDouble();
      _imageHeight = uiImage.height.toDouble();
    });
  }

  Future<void> _performTextRecognition(BuildContext context) async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Initialize the TextRecognizer
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);

      // Process the image using ML Kit
      final inputImage = InputImage.fromFile(widget.imageFile);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // Save recognized blocks to state
      setState(() {
        _recognizedBlocks = recognizedText.blocks;
      });

      textRecognizer.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    } finally {
      // Close the dialog
      Navigator.pop(context);
    }
  }

  Future<void> _reuploadPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Preview(imageFile: File(pickedFile.path)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No image selected."),
      ));
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

          // Display recognized text blocks
          if (_recognizedBlocks.isNotEmpty)
            ..._recognizedBlocks.map((block) {
              final rect = block.boundingBox;

              // Scale bounding box coordinates
              final left =
                  rect.left / _imageWidth * MediaQuery.of(context).size.width;
              final top =
                  rect.top / _imageHeight * MediaQuery.of(context).size.height;
              final width =
                  rect.width / _imageWidth * MediaQuery.of(context).size.width;
              final height = rect.height /
                  _imageHeight *
                  MediaQuery.of(context).size.height;

              return Positioned(
                left: left,
                top: top,
                width: width,
                height:
                    height < 20.0 ? 20.0 : height, // Set minimum height to 30
                child: GestureDetector(
                  onTap: () {
                    print('Block text: ${block.text}');
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 20.0, // Minimum height for the box
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), // Box color (white)
                      borderRadius:
                          BorderRadius.circular(3.0), // Rounded corners
                      border: Border.all(
                          color: Colors.white,
                          width: 2), // Border color and width
                    ),
                    child: Center(
                      child: Text(
                        block.text,
                        style: const TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),

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

//PROFILING PAGE

class ProfilingQuestionsPage extends StatefulWidget {
  const ProfilingQuestionsPage({super.key});

  @override
  _ProfilingQuestionsPageState createState() => _ProfilingQuestionsPageState();
}

class _ProfilingQuestionsPageState extends State<ProfilingQuestionsPage> {
  String _age = '';
  String _sex = '';
  String? _selectedHeightRange;
  String? _selectedWeightRange;
  String _healthCondition = '';
  String _noHealthCondition = '';
  int _currentPage = 0;

// lIST OF AGE OPTIONS
  List<String> ageOptions = [
    'Under 18',
    '18-25',
    '26-35',
    '36-50',
    'Above 50',
  ];

// LIST OF HEIGHT OPTIONS
  final List<String> _heightOptions = [
    'Below 150 cm',
    '150-160 cm',
    '161-170 cm',
    '171-180 cm',
    'Above 180 cm'
  ];

// LIST OF WEIGHT OPTIONS
  final List<String> _weightOptions = [
    'Under 50 kg',
    '50-60 kg',
    '61-70 kg',
    '71-80 kg',
    'Above 80 kg'
  ];

  // LIST OF HEALTH CONDITIONS
  List<String> healthConditions = [
    'Yes',
    'No',
  ];

  void _nextPage() {
    if (_currentPage < 4) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _submit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Camera()),
    );
  }

  void _skipToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Camera()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Profiling Questions',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Color(0xff1A5319),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 8, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Basic Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1A5319),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 2, // SHADOW EFFECT
              color: Color(0xffD6EFD8),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PROGRESS INDICATOR
                    SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: (_currentPage + 1) / 5,
                      backgroundColor: Colors.grey.shade300,
                      color: Color(0xff1A5319),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    // AGE SECTION
                    SizedBox(height: 25),
                    if (_currentPage == 0) ...[
                      Center(
                        child: Text(
                          'Please specify your age group.',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      ...ageOptions.map((age) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              age,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                            leading: Radio(
                              value: age,
                              groupValue: _age,
                              onChanged: (value) {
                                setState(() {
                                  _age = value as String;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),

                      // SEX SECTION
                    ] else if (_currentPage == 1) ...[
                      Text(
                        'Could you please specify your sex?',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      //MALE RADIO BUTTON
                      SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            'Male',
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 15),
                          ),
                          leading: Radio(
                            value: 'Male',
                            groupValue: _sex,
                            onChanged: (value) {
                              setState(() {
                                _sex = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      //FEMALE RADIO BUTTON
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            'Female',
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 15),
                          ),
                          leading: Radio(
                            value: 'Female',
                            groupValue: _sex,
                            onChanged: (value) {
                              setState(() {
                                _sex = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      // HEIGHT SECTION
                    ] else if (_currentPage == 2) ...[
                      Center(
                        child: Text(
                          'Please specify your height range.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ..._heightOptions.map((heightRange) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              heightRange,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                            leading: Radio<String>(
                              value: heightRange,
                              groupValue: _selectedHeightRange,
                              onChanged: (value) {
                                setState(() {
                                  _selectedHeightRange = value!;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),

                      // WEIGHT SECTION
                    ] else if (_currentPage == 3) ...[
                      Center(
                        child: Text(
                          'Please specify your weight range.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ..._weightOptions.map((weightRange) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              weightRange,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                            leading: Radio<String>(
                              value: weightRange,
                              groupValue: _selectedWeightRange,
                              onChanged: (value) {
                                setState(() {
                                  _selectedWeightRange = value!;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),

                      // HEALTH CONDITION SECTION
                    ] else if (_currentPage == 4) ...[
                      Center(
                        child: Text(
                          'Do you have any existing health conditions?',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: const Text('Yes'),
                          leading: Radio<String>(
                            value: 'Yes',
                            groupValue: _healthCondition,
                            onChanged: (value) {
                              setState(() {
                                _healthCondition = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: const Text('No'),
                          leading: Radio<String>(
                            value: 'No',
                            groupValue: _healthCondition,
                            onChanged: (value) {
                              setState(() {
                                _healthCondition = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 300,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          enabled: _healthCondition == 'Yes',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            hintText: 'Specify health conditions',
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],

                    // NAVIGATION BUTTONS
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SKIP BUTTON
                        if (_currentPage == 0) ...[
                          //SizedBox(width: 10),
                          TextButton(
                            onPressed: _skipToCamera,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                color: Color(0xff1A5319),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xff1A5319),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                        if (_currentPage > 0)
                          OutlinedButton(
                            onPressed: _previousPage,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Color(0xff1A5319)),
                            ),
                            child: Text(
                              'Previous',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                color: Color(0xff1A5319),
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            bool canProceed = false;
                            switch (_currentPage) {
                              case 0:
                                canProceed = _age.isNotEmpty;
                                break;
                              case 1:
                                canProceed = _sex.isNotEmpty;
                                break;
                              case 2:
                                canProceed = _selectedHeightRange != null;
                                break;
                              case 3:
                                canProceed = _selectedWeightRange != null;
                                break;
                              case 4:
                                canProceed = _healthCondition.isNotEmpty;
                                break;
                            }

                            if (canProceed) {
                              if (_currentPage < 4) {
                                _nextPage();
                              } else {
                                _submit();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please answer the question before proceeding.',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentPage < 4 ? 'Next' : 'Submit',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xff1A5319),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//AFTER SCAN PAGE
class AfterScan extends StatefulWidget {
  final String imagePath;

  const AfterScan({super.key, required this.imagePath});

  @override
  _AfterScanState createState() => _AfterScanState();
}

class _AfterScanState extends State<AfterScan> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  final List<Map<String, String>> suitableIngredients = [
    {
      'name': 'Wheat Flour',
      'description':
          'Wheat flour is a powder made from grinding wheat, commonly used in baked goods.'
    },
    {
      'name': 'Cocoa Powder',
      'description':
          'Cocoa powder is made from cacao beans and is used to give chocolate flavor.'
    },
    {
      'name': 'Sugar',
      'description':
          'Sugar adds sweetness to foods and drinks and can enhance flavor.'
    },
    {
      'name': 'Leavening Agents (Baking Soda)',
      'description':
          'Helps the cookie rise and creates a lighter texture. Sodium bicarbonate is generally harmless when used in small amounts.'
    },
  ];

  final List<Map<String, String>> unsuitableIngredients = [
    {
      'name': 'Palm Oil',
      'description':
          'Palm oil is a type of vegetable oil that is high in saturated fat.'
    },
    {
      'name': 'Salt',
      'description':
          'Salt is used for flavoring but can lead to health issues if consumed excessively.'
    },
  ];

  final List<Map<String, String>> healthTips = [
    {
      'name': 'Whole Wheat Flour',
      'description':
          ' Use whole wheat flour instead of regular wheat flour. It\'s richer in fiber, vitamins, and minerals, supporting better digestion and prolonged energy.'
    },
    {
      'name': 'Unsweetened Cocoa Powder',
      'description':
          'Ensure the cocoa powder is unsweetened to reduce added sugars.'
    },
    {
      'name': 'Natural Sweeteners',
      'description':
          'Replace sugar with natural options like honey, maple syrup, or coconut sugar for a lower glycemic index.'
    },
  ];

  // Exit Dialog
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to go back?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/blogo.png',
                height: 35,
              ),
              const SizedBox(width: 5),
              const Text(
                'BETTER BITES',
                style: TextStyle(
                    color: Color(0xFF02542D),
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
        ),
        body: Stack(
          children: [
            _isLoading
                ? Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: Color(0xFF0d522c),
                      size: 100,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _getTitleForIndex(_selectedIndex)['title'],
                            style: TextStyle(
                              color: _getTitleForIndex(_selectedIndex)['color'],
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildBody(),
                        ),
                      ],
                    ),
                  ),
            Positioned(
              bottom: 20,
              right: 16,
              child: FloatingActionButton(
                onPressed: () async {
                  bool? rescan = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Scan Again?'),
                      content: const Text('Do you want to scan again?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );

                  if (rescan == true) {
                    // Redirect to Camera widget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Camera(),
                      ),
                    );
                  }
                },
                backgroundColor: const Color(0xFF02542D),
                foregroundColor: Colors.white,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0d522c),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/like.svg',
                  color: Colors.white),
              label: 'Suitable',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/unlike.svg',
                width: 23,
                color: Colors.white,
              ),
              label: 'Unsuitable',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/lightbulb.svg',
                  color: Colors.white),
              label: 'Health Tips',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
          ),
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: const IconThemeData(size: 50),
          unselectedIconTheme: const IconThemeData(size: 50),
        ),
      ),
    );
  }

  Map<String, dynamic> _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return {
          'title': 'SUITABLE INGREDIENTS',
          'color': const Color(0xFF0d522c)
        };
      case 1:
        return {
          'title': 'UNSUITABLE INGREDIENTS',
          'color': const Color(0xFF0d522c)
        };
      case 2:
        return {
          'title': 'HEALTH SUGGESTIONS',
          'color': const Color(0xFF0d522c)
        };
      default:
        return {
          'title': 'SUITABLE INGREDIENTS',
          'color': const Color(0xFF0d522c)
        };
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildIngredientsList(suitableIngredients);
      case 1:
        return _buildIngredientsList(unsuitableIngredients);
      case 2:
        return _buildHealthSuggestions();
      default:
        return _buildIngredientsList(suitableIngredients);
    }
  }

  Widget _buildIngredientsList(List<Map<String, String>> ingredients) {
    return ListView.builder(
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            child: ExpansionTile(
              iconColor: const Color(0xFF0d522c),
              title: Text(ingredient['name']!,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d522c))),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(ingredient['description']!,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0d522c))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthSuggestions() {
    return ListView.builder(
      itemCount: healthTips.length,
      itemBuilder: (context, index) {
        final tip = healthTips[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            child: ExpansionTile(
              iconColor: const Color(0xFF0d522c),
              title: Text(tip['name']!,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d522c))),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(tip['description']!,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0d522c))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showScanAgainDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Again'),
          content: const Text('Do you want to scan again?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }
}
