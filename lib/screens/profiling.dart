import 'package:betterbitees/repositories/profiling_repo.dart';
import 'package:betterbitees/screens/camera.dart';
import 'package:betterbitees/services/profiling_service.dart';
import 'package:flutter/material.dart';

class ProfilingQuestionsPage extends StatefulWidget {
  const ProfilingQuestionsPage({super.key});

  @override
  _ProfilingQuestionsPageState createState() => _ProfilingQuestionsPageState();
}

class _ProfilingQuestionsPageState extends State<ProfilingQuestionsPage> {
  final ProfilingService profilingService =
      ProfilingService(profilingRepo: ProfilingRepo());
  String _age = '';
  String _sex = '';
  String? _selectedHeightRange;
  String? _selectedWeightRange;
  String _healthCondition = '';
  int _currentPage = 0;

// lIST OF AGE OPTIONS
  List<String> ageOptions = [
    "title:" "Please specify your age group.",
    'Under 18',
    '18-25',
    '26-35',
    '36-50',
    'Above 50',
  ];

// LIST OF HEIGHT OPTIONS
  final List<String> _heightOptions = [
    "title:" "What is your height?",
    'Below 150 cm',
    '150-160 cm',
    '161-170 cm',
    '171-180 cm',
    'Above 180 cm'
  ];

// LIST OF WEIGHT OPTIONS
  final List<String> _weightOptions = [
    "title:" "What is your weight?",
    'Under 50 kg',
    '50-60 kg',
    '61-70 kg',
    '71-80 kg',
    'Above 80 kg'
  ];

  // LIST OF HEALTH CONDITIONS
  List<String> healthConditions = [
    "title:" "Do you have any health conditions?",
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

  Future<void> _submit() async {
    await profilingService.saveProfile(
        age: _age,
        gender: _sex,
        height: _selectedHeightRange!,
        weight: _selectedWeightRange!,
        healthCondition: _healthCondition);
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
          'Profiling Survey',
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
                      })

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
                      }),

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
                      }),

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
