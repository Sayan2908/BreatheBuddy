import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copdbuddy/pages/doctor_graphdetails.dart';
import 'package:copdbuddy/pages/doctor_homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  PatientDetailsPage({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details', style: TextStyle(color: Colors.white,fontFamily: 'Poppins'),),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${patient.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Age: ${patient.age}'),
              SizedBox(height: 8),
              Text('Total Score: ${patient.totalScore}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'COPD Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildCOPDDataDetails(patient.copdData),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientGraphPage(userId: patient.id, name: patient.name)),
                  ) ,
                  child: Text('Get More Details'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCOPDDataDetails(Map<String, dynamic> copdData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Cough Tendency: ', '${copdData['coughTendency']}'),
          _buildDetailRow('Phlegm Amount: ', '${copdData['phlegmAmount']}'),
          _buildDetailRow('Chest Tightness: ', '${copdData['chestTightness']}'),
          _buildDetailRow('Breathlessness: ', '${copdData['breathlessness']}'),
          _buildDetailRow('Activity : ', '${copdData['activityLimitation']}'),
          _buildDetailRow('Confidence Level: ', '${copdData['confidenceLevel']}'),
          _buildDetailRow('Sleep Quality: ', '${copdData['sleepQuality']}'),
          _buildDetailRow('Energy Level: ', '${copdData['energyLevel']}'),
          _buildDetailRow('CAT Score: ', '${copdData['catScore']}'),
          _buildDetailRow('spO2 Level: ', '${copdData['spO2Level']}'),
          _buildDetailRow('mMRC Grade: ', '${copdData['mMRCGrade']}'),
          _buildDetailRow('Heart Rate: ', '${copdData['heartRate']}'),
          _buildDetailRow('PEFR Value: ', '${copdData['PEFRValue']}'),
          _buildDetailRow('Inhaler Taken: ', '${copdData['inhalerTaken']}'),
          _buildDetailRow('Breathing Exercises Done: ', '${copdData['breathingExercisesDone']}'),
          _buildDetailRow('Timestamp: ', copdData['timestamp'] is Timestamp ? DateFormat('yyyy-MM-dd HH:mm:ss').format(copdData['timestamp'].toDate()) : '${(copdData['timestamp'] as Timestamp).toDate()}'),
          SizedBox(height: 16,),
          _buildDetailRow('Last 4 weeks how much asthma prevented: ', '${copdData['asthmawork'] ?? 'No data for asthma'}'),
          _buildDetailRow('Last 4 weeks shortness of breath: ', '${copdData['breathshortness'] ?? 'No data for asthma'}'),
          _buildDetailRow('How often have your asthma symptoms woken from sleep: ', '${copdData['asthmasleep'] ?? 'No data for asthma'}'),
          _buildDetailRow('How often have you used your rescue inhaler or nebuliser medication: ', '${copdData['inhalerusage'] ?? 'No data for asthma'}'),
          _buildDetailRow('Asthma control: ', '${copdData['asthmacontrol'] ?? 'No data for asthma'}'),
          _buildDetailRow('Asthma Score', '${copdData['asthmascore'] ?? 'No data for asthma'}'),
          SizedBox(height: 16,),

        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            width: 200,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
