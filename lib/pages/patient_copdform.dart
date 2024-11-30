import 'package:copdbuddy/components/dialogbox.dart';
import 'package:copdbuddy/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({Key? key}) : super(key: key);

  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  int _currentStep = 0;
  List<int?> _scaleAnswers = List.generate(8, (index) => 1);
  double? _decimalAnswer1 = 0;
  double? _decimalAnswer2 = 0;
  int? _integerAnswer = 0;
  double? _decimalAnswer3 = 0;
  bool _stringAnswer1 = false;
  bool _stringAnswer2 = false;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showConsultationDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) => ConsultationDialog(message: message),
    );
  }

  void _showTestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success!'),
        content: Text('Form Data Submitted you can close this page press the back button at the top of the screen'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fill the COPD form',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            // Handle submit logic
            // You can access all the collected data here
            print('Scale Answers: $_scaleAnswers');
            print('Decimal Answer 1: $_decimalAnswer1');
            print('Decimal Answer 2: $_decimalAnswer2');
            print('String Answer 1: $_stringAnswer1');
            print('String Answer 2: $_stringAnswer2');
          }
        },
        onStepTapped: (step) => setState(() {
          _currentStep = step;
        }),
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
          if (_currentStep == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controlsDetails.onStepContinue,
                  child: Text('Next'),
                ),
              ],
            );
          } else if (_currentStep == 3) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controlsDetails.onStepCancel,
                  child: Text('Back'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    User? user = _auth.currentUser;
                    if (user!=null){

                      await _firebaseFunctions.submitFormData(userId: user.uid, coughTendency: _scaleAnswers[0] ?? 1, phlegmAmount: _scaleAnswers[1] ?? 1, chestTightness: _scaleAnswers[2] ?? 1, breathlessness: _scaleAnswers[3] ?? 1, activityLimitation: _scaleAnswers[4] ?? 1, confidenceLevel: _scaleAnswers[5] ?? 1, sleepQuality: _scaleAnswers[6] ?? 1, energyLevel: _scaleAnswers[7] ?? 1, spO2Level: _decimalAnswer1 ?? 0, mMRCGrade: _decimalAnswer2 !=null ? _decimalAnswer2!.round() : 0,heartRate: _integerAnswer ?? 0, pefrValue: _decimalAnswer3 ?? 0, inhalerTaken: _stringAnswer1, breathingExercisesDone: _stringAnswer2);
                      await _firebaseFunctions.storeUserDate(userId: user.uid, coughTendency: _scaleAnswers[0] ?? 1, phlegmAmount: _scaleAnswers[1] ?? 1, chestTightness: _scaleAnswers[2] ?? 1, breathlessness: _scaleAnswers[3] ?? 1, activityLimitation: _scaleAnswers[4] ?? 1, confidenceLevel: _scaleAnswers[5] ?? 1, sleepQuality: _scaleAnswers[6] ?? 1, energyLevel: _scaleAnswers[7] ?? 1, spO2Level: _decimalAnswer1 ?? 0, mMRCGrade: _decimalAnswer2 !=null ? _decimalAnswer2!.round() : 0,heartRate: _integerAnswer ?? 0, pefrValue: _decimalAnswer3 ?? 0, inhalerTaken: _stringAnswer1, breathingExercisesDone: _stringAnswer2);
                      int sum = _scaleAnswers.fold(0, (acc, value) => acc + (value ?? 0));
                      if ((_integerAnswer! > 120 || _integerAnswer! < 60) && _decimalAnswer1! < 92 && sum > 35){
                        _showConsultationDialog('Please Consult doctor your Heart Rate level is not normal and spO2 is low and CAT score concerning. '
                            'Your data has been submitted press back button at the top of the screen');
                      }
                      else if ((_integerAnswer! > 120 || _integerAnswer! < 60) && _decimalAnswer1! < 92){
                        _showConsultationDialog('Please Consult doctor your Heart Rate level is not normal and spO2 is low. '
                            'Your data has been submitted press back button at the top of the screen');
                      }
                      else if (_integerAnswer! > 120 || _integerAnswer! < 60){
                        _showConsultationDialog('Please Consult doctor your Heart Rate level is not normal. '
                            'Your data has been submitted press back button at the top of the screen');
                      }
                      else if (_decimalAnswer1! < 92) {
                        _showConsultationDialog('Please Consult doctor your spO2 level is lower than safety level. '
                            'Your data has been submitted press back button at the top of the screen');
                      }
                      else if (sum > 30 && sum <= 35) {
                        _showConsultationDialog('Please Consult doctor your CAT Score is quite high. '
                            'Your data has been submitted press back button at the top of the screen');
                      } else if (sum > 35) {
                        _showConsultationDialog('Immediately Consult doctor your CAT Score is concerning. '
                            'Your data has been submitted press back button at the top of the screen');
                      }
                      print(_integerAnswer);
                      _showTestDialog();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controlsDetails.onStepCancel,
                  child: Text('Back'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: controlsDetails.onStepContinue,
                  child: Text('Next'),
                ),
              ],
            );
          }
        },


        steps: [
          Step(
            isActive: _currentStep>=0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            title: Text('Section 1'),
            content: Column(
              children: _buildScaleQuestions(),
            ),
          ),
          Step(
            isActive: _currentStep>=1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            title: Text('Section 2'),
            content: Column(
              children: _buildDecimalQuestions(),
            ),
          ),
          Step(
            isActive: _currentStep>=2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            title: Text('Section 3'),
            content: Column(
              children: _buildStringQuestions(),
            ),
          ),
          Step(
            isActive: _currentStep>=3,
            title: Text('Submit'),
            content: _buildSubmitSection(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScaleQuestions() {
    double width = MediaQuery.of(context).size.width;
    List<Widget> questions = [];
    List<String> scaleQuestions = [
      'What is your tendency to cough? (the lower the better)',
      'How much phlegm in the chest?',
      'Is there chest tightness? (lower the better)',
      'How often do you experience breathlessness?',
      'To what extent are your activities limited at home?',
      'How low confident do you feel in leaving home? (lower the score better you are)',
      'How less sound sleep do you have? (lower means better sound sleep)',
      'How low energy are you feeling? (lower the score better)',
    ];

    List<String> scaleLeftSuggestion = [
      'I never cough',
      'I have no phlegm in my chest',
      'No chest tightness',
      'Walking up a hill or flight no breathlessness',
      'Not limited activities at home',
      'Confident leaving my home',
      'I sleep soundly',
      'Have lots of energy',
    ];

    List<String> scaleRightSuggestion = [
      'Cough all the time',
      'Lot of phlegm (mucus)',
      'Feeling of chest tightness',
      'Hill climbing or flight causes breathlessness',
      'Very limited activities at home',
      'Not confident leaving my home',
      'Cant sleep soundly',
      'No energy at all',
    ];

    for (int i = 0; i < 8; i++) {
      questions.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${i + 1}: ${scaleQuestions[i]}',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
            ),
            Slider(
              value: _scaleAnswers[i]?.toDouble() ?? 1.0,
              onChanged: (value) {
                setState(() {
                  _scaleAnswers[i] = value.round();
                });
              },
              min: 1,
              max: 5,
              divisions: 4,
              label: _scaleAnswers[i]?.toString() ?? '1',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.3,
                    child: Text(
                        '${scaleLeftSuggestion[i]}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                    )
                ),
                Container(
                  width: width*0.3,
                    child: Text(
                        '${scaleRightSuggestion[i]}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                    )
                )
              ],
            ),
            SizedBox(height: 20,)
          ],
        ),
      );
    }
    return questions;
  }

  List<Widget> _buildDecimalQuestions() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1: What is your spO2 level?(range: 1 to 100)',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                _decimalAnswer1 = double.tryParse(value);
              });
            },
          ),
        ],
      ),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('2: What is your mMRC grade? (range: 0 to 4)',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),),
            SizedBox(height: 10,),
            Image.asset(
              "assets/mmrc.png",
            ),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _decimalAnswer2 = double.tryParse(value);
                });
              },
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('3: What is your heart rate?',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                _integerAnswer = int.tryParse(value);
              });
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('4: What is your PEFR value? [If it is lower than 50% of your normal please consult doctor]',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                _decimalAnswer3 = double.tryParse(value);
              });
            },
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildStringQuestions() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1: Did you take your inhaler?',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: _stringAnswer1,
                onChanged: (value) {
                  setState(() {
                    _stringAnswer1 = value! ? true : false;
                  });
                },
              ),
              Text('Yes'),
              Radio<bool>(
                value: false,
                groupValue: _stringAnswer1,
                onChanged: (value) {
                  setState(() {
                    _stringAnswer1 = value! ? false : true;
                  });
                },
              ),
              Text('No'),
            ],
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('2: Did you do your breathing exercises?',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: _stringAnswer2,
                onChanged: (value) {
                  setState(() {
                    _stringAnswer2 = value! ? true : false;
                  });
                },
              ),
              Text('Yes'),
              Radio<bool>(
                value: false,
                groupValue: _stringAnswer2,
                onChanged: (value) {
                  setState(() {
                    _stringAnswer2 = value! ? false : true;
                  });
                },
              ),
              Text('No'),
            ],
          ),
        ],
      ),
    ];
  }


  Widget _buildSubmitSection() {
    return Column(
      children: [
        Text('Scale Answers: $_scaleAnswers'),
        Text('spO2 value: $_decimalAnswer1'),
        Text('mMrc grade: $_decimalAnswer2'),
        Text('Heart Rate: $_integerAnswer'),
        Text('PEFR Value: $_decimalAnswer3'),
        Text('Inhaler taken: $_stringAnswer1'),
        Text('Breathing Exercises done: $_stringAnswer2'),
      ],
    );
  }
}
