import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copdbuddy/pages/doctor_homepage.dart';
import 'package:copdbuddy/pages/patient_mainscreen.dart';
import 'package:flutter/src/material/time.dart';

class FirebaseFunctions {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<BlogCard>> getBlogs() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore.collection('blogs').orderBy('time', descending: true).limit(30).get();
      print(querySnapshot.docs);

      List<BlogCard> blogs = querySnapshot.docs.map((doc) {
        // Assuming your 'blogs' collection has 'title' and 'content' fields
        String title = doc['title'];
        String content = doc['description'];
        DateTime time1 = (doc['time'] as Timestamp).toDate();

        return BlogCard(
          title: title,
          content: content,
          time: time1,
          // Add other fields if necessary
        );
      }).toList();

      return blogs;
    } catch (e) {
      // Handle errors as needed
      print("Error fetching blogs: $e");
      return [];
    }
  }

  Future<void> submitFormData({
    required String userId,
    required int coughTendency,
    required int phlegmAmount,
    required int chestTightness,
    required int breathlessness,
    required int activityLimitation,
    required int confidenceLevel,
    required int sleepQuality,
    required int energyLevel,
    required double spO2Level,
    required int mMRCGrade,
    required int heartRate,
    required double pefrValue,
    required bool inhalerTaken,
    required bool breathingExercisesDone,
  }) async {
    try {

      final int catScore = coughTendency + phlegmAmount + chestTightness + breathlessness + activityLimitation + confidenceLevel + sleepQuality + energyLevel;
      // Create a timestamp for the submission
      final timestamp = FieldValue.serverTimestamp();

      // Create a reference to the user's forms collection
      final formsCollection = _firebaseFirestore.collection('patients/$userId/forms');

      // Create a new form document with the timestamp as the document ID
      final formDoc = formsCollection.doc(timestamp.toString());

      // Set the form data
      await formDoc.set({
        'coughTendency': coughTendency,
        'phlegmAmount': phlegmAmount,
        'chestTightness': chestTightness,
        'breathlessness': breathlessness,
        'activityLimitation': activityLimitation,
        'confidenceLevel': confidenceLevel,
        'sleepQuality': sleepQuality,
        'energyLevel': energyLevel,
        'catScore' : catScore,
        'spO2Level': spO2Level,
        'mMRCGrade': mMRCGrade,
        'heartRate': heartRate,
        'PEFRValue': pefrValue,
        'inhalerTaken': inhalerTaken,
        'breathingExercisesDone': breathingExercisesDone,
        'timestamp': timestamp,
      });

      // Optionally, you can return some response or handle success here
      print('Form data submitted successfully');
    } catch (e) {
      // Handle errors as needed
      print('Error submitting form data: $e');
    }
  }

  Future<List<Patient>> getAllPatientsData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> patientQuery =
      await _firebaseFirestore.collection('patients').get();
      print(patientQuery.docs);
      print('Fetched patient data: ${patientQuery.docs}');

      List<Patient> patients = await Future.wait(patientQuery.docs.map((patientDoc) async {
        String patientId = patientDoc.id;
        Map<String, dynamic> patientData = patientDoc.data() ?? {};

        // Get COPD data for each patient
        Map<String, dynamic> copdData = await getCopdData(patientId);
        print('Fetched COPD data for patient $patientId: $copdData');

        // Return a Patient instance with both patient details and COPD data
        return Patient.fromFirestore(patientData, patientId, copdData);
      }));

      return patients;
    } catch (e) {
      // Handle errors as needed
      print('Error fetching all patients data: $e');
      return [];
    }
  }


  Future<Map<String, dynamic>> getCopdData(String patientId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> copdDocs =
      await _firebaseFirestore.collection('patients/$patientId/forms').get();

      // Check if there are any documents
      if (copdDocs.docs.isNotEmpty) {
        // Assuming you only expect one document, use the first one
        DocumentSnapshot<Map<String, dynamic>> copdDoc = copdDocs.docs.first;

        // Access the data using copdDoc.data()
        Map<String, dynamic> copdData = copdDoc.data() ?? {};
        return copdData;
      } else {
        // No documents found
        print('No COPD data found for patient $patientId');
        return {};
      }
    } catch (e) {
      // Handle errors as needed
      print('Error fetching COPD data: $e');
      return {};
    }
  }

  Future<void> addMedicine(String userId, String medicine, TimeOfDay selectedTime) async {
    try {
      // Reference to the medicines collection for the specific user
      CollectionReference medicinesCollection = _firebaseFirestore.collection('patients/$userId/medicines');

      // Add medicine details to the collection
      await medicinesCollection.add({
        'name': medicine,
        'timeOfDay': {
          'hour': selectedTime.hour,
          'minute': selectedTime.minute,
        },
      });
    } catch (e) {
      // Handle errors as needed
      print('Error adding medicine: $e');
    }
  }

  Future<List<Medicine>> getMedicines(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore.collection('patients/$userId/medicines').get();

      List<Medicine> medicines = querySnapshot.docs.map((doc) {
        return Medicine(
          name: doc['name'] ?? '',
          timeOfDay: _convertToTimeOfDay(doc['timeOfDay']),
        );
      }).toList();

      return medicines;
    } catch (e) {
      print('Error fetching medicines: $e');
      return [];
    }
  }

  TimeOfDay _convertToTimeOfDay(Map<String, dynamic> data) {
    int hour = data['hour'];
    int minute = data['minute'];
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> storeUserDate({
    required String userId,
    required int coughTendency,
    required int phlegmAmount,
    required int chestTightness,
    required int breathlessness,
    required int activityLimitation,
    required int confidenceLevel,
    required int sleepQuality,
    required int energyLevel,
    required double spO2Level,
    required int mMRCGrade,
    required int heartRate,
    required double pefrValue,
    required bool inhalerTaken,
    required bool breathingExercisesDone,
  }) async {
    try {

      final int catScore = coughTendency + phlegmAmount + chestTightness + breathlessness + activityLimitation + confidenceLevel + sleepQuality + energyLevel;
      // Create a timestamp for the submission
      final timestamp = FieldValue.serverTimestamp();

      // Create a new record document
      await _firebaseFirestore.collection('patients').doc(userId).collection('records').add({
        'coughTendency': coughTendency,
        'phlegmAmount': phlegmAmount,
        'chestTightness': chestTightness,
        'breathlessness': breathlessness,
        'activityLimitation': activityLimitation,
        'confidenceLevel': confidenceLevel,
        'sleepQuality': sleepQuality,
        'energyLevel': energyLevel,
        'catScore' : catScore,
        'spO2Level': spO2Level,
        'mMRCGrade': mMRCGrade,
        'heartRate': heartRate,
        'PEFRValue': pefrValue,
        'inhalerTaken': inhalerTaken,
        'breathingExercisesDone': breathingExercisesDone,
        'date': timestamp,
      });

      print('Form data submitted successfully!');
    } catch (e) {
      print('Error submitting form data: $e');
    }
  }

}
