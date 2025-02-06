import 'package:betterbitees/repositories/profiling_repo.dart';
import 'package:betterbitees/screens/camera.dart';
import 'package:betterbitees/screens/info.dart';
import 'package:betterbitees/screens/profiling.dart';
import 'package:betterbitees/services/profiling_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  final ProfilingService profilingService = ProfilingService(
    profilingRepo: ProfilingRepo(),
  );

  HomePage({super.key});

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
              onPressed: () async {
                final profile = await profilingService.getProfile();

                if (profile == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilingQuestionsPage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Camera()),
                  );
                }
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
