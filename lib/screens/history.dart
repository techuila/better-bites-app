import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:betterbitees/screens/after_scan.dart';
import 'package:betterbitees/repositories/food_analysis_repo.dart';
import 'package:betterbitees/services/food_analysis_service.dart';
import 'package:betterbitees/models/food_analysis.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final foodAnalysisService =
      FoodAnalysisService(foodAnalysisRepo: FoodAnalysisRepo());
  List<Future<FoodAnalysis>> foodList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      foodAnalysisService.getAll().then((foodList) {
         setState(() {
          this.foodList = foodList;
        });
      });
    });
  }

  // create a gallery of images using the card widget and divide them by date (today, yesterday, last week, last month and last 3 months, etc..)
  // the images should be shown before each title, after clicking the image, it should redirect to the afterscan page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.builder(
        itemCount: foodList.length,
        itemBuilder: (context, index) {
          return FutureBuilder<FoodAnalysis>(
            future: foodList[index],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final foodAnalysis = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  child: Card(
                    child: ListTile(
                      title: Text(foodAnalysis.title),
                      onTap: () {
                        Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => AfterScan(imageFile: null, foodAnalysis: foodAnalysis),
                         ),
                         );
                      },
                    ),
                  )
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
