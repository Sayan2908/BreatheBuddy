import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class PatientGraphPage extends StatefulWidget {
  final String userId;
  final String name;

  const PatientGraphPage({Key? key, required this.userId, required this.name}) : super(key: key);

  @override
  _PatientGraphPageState createState() => _PatientGraphPageState();
}

class _PatientGraphPageState extends State<PatientGraphPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _records = [];
  List<Map<String, dynamic>> _asthmarecords = [];
  String height = '',sex = 'human';
  int age = 0;

  @override
  void initState() {
    super.initState();
    // Fetch patient's records when the page is initialized
    _fetchPatientRecords();
  }

  Future<void> _fetchPatientRecords() async {
    try {
      DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 90));
      // Fetch records for the specified patient ID
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('patients')
          .doc(widget.userId)
          .collection('records')
          .where('date', isGreaterThanOrEqualTo: thirtyDaysAgo)
          .orderBy('date', descending: true)
          .get();

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.userId)
          .get();

      QuerySnapshot<Map<String, dynamic>> querySnapshot2 = await _firestore
          .collection('patients')
          .doc(widget.userId)
          .collection('asthmarecords')
          .where('date', isGreaterThanOrEqualTo: thirtyDaysAgo)
          .orderBy('date', descending: true)
          .get();

      // Store records in the local list
      _records = querySnapshot.docs.map((doc) => doc.data()).toList();
      _asthmarecords = querySnapshot2.docs.map((doc) => doc.data()).toList();
      height = documentSnapshot['docid'] ?? "0";
      age = documentSnapshot['age'] ?? 0;
      sex = documentSnapshot['sex'] ?? "human";

      // Update the UI
      setState(() {});
    } catch (e) {
      print('Error fetching patient records: $e');
    }
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();

    final sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow(['Height: ${height}','Age : $age','Sex : $sex']);
    sheet.appendRow(['Date', 'Cough Tendency', 'Phlegm Amount', 'Chest Tightness', 'Breathlessness', 'Activity Limitation', 'Less Confidence', 'Less Sound Sleep', 'Low Energy', 'CAT Score', 'SpO2', 'PEFR Value', 'Heart Rate', 'Inhaler taken' /* Add other fields here */]);

    // Add data
    for (var record in _records) {
      DateTime date = (record['date'] as Timestamp).toDate();
      sheet.appendRow([date.toString(), record['coughTendency'], record['phlegmAmount'], record['chestTightness'], record['breathlessness'], record['activityLimitation'], record['confidenceLevel'], record['sleepQuality'], record['energyLevel'], record['catScore'], record['spO2Level'], record['PEFRValue'], record['heartRate'], record['inhalerTaken']/* Add other fields here */]);
    }

    sheet.appendRow([]);
    sheet.appendRow([]);
    sheet.appendRow([]);
    sheet.appendRow(['Asthma Form']);
    sheet.appendRow(['Date','Asthma disrupting work','Breath shortness','Sleep Deprivation','Inhaler medication','Asthma Control']);

    for (var record in _asthmarecords) {
      DateTime date = (record['date'] as Timestamp).toDate();
      sheet.appendRow([date.toString(),record['asthmawork'],record['breathshortness'],record['asthmasleep'],record['inhalerusage'],record['asthmacontrol']]);
    }

    // Get the local directory using path_provider
    Directory? appDocDir = await getExternalStorageDirectory();

    try {
      // Get the Downloads directory using path_provider
      Directory? downloadsDir = await getDownloadsDirectory();

      if (downloadsDir != null) {
        // Generate the file path in the Downloads folder
        String filePath = '${downloadsDir.path}/${widget.name}_patient.xlsx';

        // Get Excel file bytes
        List<int> excelBytes = excel.encode() ?? [];

        // Save the file
        await File(filePath).writeAsBytes(excelBytes);

        OpenFile.open(filePath);

        // Provide feedback to the user (optional)
        print('Excel file saved at: $filePath');
      } else {
        print('Error getting Downloads directory');
      }
    } catch (e) {
      print('Error exporting to Excel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Get patient details throughout the last month',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _records.isNotEmpty
                  ? ElevatedButton(
                onPressed: _exportToExcel,
                child: Text('Export to Excel'),
              )
                  : Text('No records available for this patient.'),
            ],
          ),
        ),
      ),
    );
  }
}
