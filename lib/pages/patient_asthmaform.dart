import 'package:flutter/material.dart';
import 'package:copdbuddy/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AsthmaForm extends StatefulWidget {
  const AsthmaForm({Key? key}) : super(key: key);

  @override
  State<AsthmaForm> createState() => _AsthmaFormState();
}

class _AsthmaFormState extends State<AsthmaForm> {
  // Values for storing slider values
  double sliderValue1 = 1.0;
  double sliderValue2 = 1.0;
  double sliderValue3 = 1.0;
  double sliderValue4 = 1.0;
  double sliderValue5 = 1.0;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fill the Asthma form',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildQuestion('1. During the last 4 weeks, how much of the time has your asthma kept you from getting as much done at work, school or home?', sliderValue1, (value) {
                setState(() {
                  sliderValue1 = value;
                });
              }),
              Text('1-All of the time'),
              Text('2-Most of the time'),
              Text('3-Some of the time'),
              Text('4-A little of the time'),
              Text('5-None of the time'),
              SizedBox(height: 16,),
              buildQuestion('2. During the last 4 weeks, how often have you had shortness of breath?', sliderValue2, (value) {
                setState(() {
                  sliderValue2 = value;
                });
              }),
              Text('1-All of the time'),
              Text('2-Most of the time'),
              Text('3-Some of the time'),
              Text('4-A little of the time'),
              Text('5-None of the time'),
              SizedBox(height: 16,),
              buildQuestion('3. During the last 4 weeks, how often have your asthma symptoms (wheezing, coughing, shortness of breath, chest tightness or pain) woken you up at night or earlier than usual in the morning?', sliderValue3, (value) {
                setState(() {
                  sliderValue3 = value;
                });
              }),
              Text('1-All of the time'),
              Text('2-Most of the time'),
              Text('3-Some of the time'),
              Text('4-A little of the time'),
              Text('5-None of the time'),
              SizedBox(height: 16,),
              buildQuestion('4. During the last 4 weeks, how often have you used your rescue inhaler or nebuliser medication (such as Salbutamol)?', sliderValue4, (value) {
                setState(() {
                  sliderValue4 = value;
                });
              }),
              Text('1-All of the time'),
              Text('2-Most of the time'),
              Text('3-Some of the time'),
              Text('4-A little of the time'),
              Text('5-None of the time'),
              SizedBox(height: 16,),
              buildQuestion('5. How would you rate your asthma control during the last 4 weeks?', sliderValue5, (value) {
                setState(() {
                  sliderValue5 = value;
                });
              }),
              Text('1-All of the time'),
              Text('2-Most of the time'),
              Text('3-Some of the time'),
              Text('4-A little of the time'),
              Text('5-None of the time'),
              SizedBox(height: 16,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add logic to save or process the slider values
          User? user = _auth.currentUser;
          if (user!= null){
            await _firebaseFunctions.uploadAsthmaForm(user.uid, sliderValue1, sliderValue2, sliderValue3, sliderValue4, sliderValue5);
            await _firebaseFunctions.storeasthmadata(user.uid, sliderValue1, sliderValue2, sliderValue3, sliderValue4, sliderValue5);
          }
          // For example, you can print them
          print('Slider Values: $sliderValue1, $sliderValue2, $sliderValue3, $sliderValue4, $sliderValue5');
          Navigator.of(context).pop();
        },
        child: Text('Submit'),
      ),
    );
  }

  Widget buildQuestion(String question, double sliderValue, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        Slider(
          value: sliderValue,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: onChanged,
          label: sliderValue.toString() ?? '1',
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
