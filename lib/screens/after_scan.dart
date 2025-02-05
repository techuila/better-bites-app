import 'dart:io';

import 'package:betterbitees/models/food_analysis.dart';
import 'package:betterbitees/repositories/food_analysis_repo.dart';
import 'package:betterbitees/services/food_analysis_service.dart';
import 'package:betterbitees/services/text_recognition_service.dart';
import 'package:betterbitees/screens/camera.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class AfterScan extends StatefulWidget {
  final File? imageFile;
  final FoodAnalysis? foodAnalysis;

  const AfterScan({super.key, this.imageFile, this.foodAnalysis });

  @override
  _AfterScanState createState() => _AfterScanState();
}

class _AfterScanState extends State<AfterScan> {
  final foodAiService =
FoodAnalysisService(foodAnalysisRepo: FoodAnalysisRepo());
  final textRecognition = TextRecognitionService();
  int _selectedIndex = 0;
  bool _isLoading = true;
  FoodAnalysis foodAnalysisResponse = FoodAnalysis(
    title: '',
    suitableIngredients: [],
    unsuitableIngredients: [],
    healthTips: [],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.foodAnalysis != null) {
        setState(() {
          foodAnalysisResponse = widget.foodAnalysis!;
          _isLoading = false;
        });
      } else {
        _performTextAndFoodAnalysis();
      }
    });
  }

  Future<void> _performTextAndFoodAnalysis() async {
    textRecognition.recognizeText(context, widget.imageFile!,
        (recognizedText, error) async {
      if (error != null) {
        Navigator.of(context).pop(true);
        return;
      }

      await foodAiService.analyzeFood(recognizedText!, widget.imageFile!,
          (foodAnalysisResponse) {
        setState(() {
          this.foodAnalysisResponse = foodAnalysisResponse;
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvoked,
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
                            foodAnalysisResponse.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF0d522c),
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                    // Check again if the widget is still mounted
                    if (context.mounted) {
                      // Redirect to Camera widget
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Camera(),
                        ),
                      );
                    }
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
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              label: 'Suitable',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/unlike.svg',
                width: 23,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              label: 'Unsuitable',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/lightbulb.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
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
        return _buildIngredientsList(foodAnalysisResponse.suitableIngredients);
      case 1:
        return _buildIngredientsList(
            foodAnalysisResponse.unsuitableIngredients);
      case 2:
        return _buildHealthSuggestions(foodAnalysisResponse.healthTips);
      default:
        return _buildIngredientsList(foodAnalysisResponse.suitableIngredients);
    }
  }

  Widget _buildIngredientsList(List<Item> ingredients) {
    return ListView.builder(
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            child: ExpansionTile(
              iconColor: const Color(0xFF0d522c),
              title: Text(ingredient.name,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d522c))),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(ingredient.description,
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

  Widget _buildHealthSuggestions(List<Item> healthTips) {
    return ListView.builder(
      itemCount: healthTips.length,
      itemBuilder: (context, index) {
        final tip = healthTips[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            child: ExpansionTile(
              iconColor: const Color(0xFF0d522c),
              title: Text(tip.name,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d522c))),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(tip.description,
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

  // Exit Dialog
  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    debugPrint('hello popped: $didPop ===============================');
    if (didPop) {
      return;
    }
    await showDialog(
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
    );
  }

  //void _showScanAgainDialog(BuildContext context) {
  //  showDialog(
  //    context: context,
  //    builder: (BuildContext context) {
  //      return AlertDialog(
  //        title: const Text('Scan Again'),
  //        content: const Text('Do you want to scan again?'),
  //        actions: [
  //          TextButton(
  //            onPressed: () {
  //              Navigator.of(context).pop();
  //            },
  //            child: const Text('Cancel'),
  //          ),
  //          TextButton(
  //            onPressed: () {
  //              Navigator.of(context).pop();
  //            },
  //            child: const Text('Proceed'),
  //          ),
  //        ],
  //      );
  //    },
  //  );
  //}
}
