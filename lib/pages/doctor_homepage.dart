import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copdbuddy/firebase_functions.dart';
import 'package:copdbuddy/pages/createblog.dart';
import 'package:copdbuddy/pages/doctor_patientdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//zsWwigUUQrBTZBhpziAQ

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _buildCurrentPage(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Blog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  int _currentIndex = 0;

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return DoctorDashboardPage();
      case 1:
        return DoctorBlogPage();
      case 2:
        return DoctorProfilePage();
      default:
        return Container(); // Handle additional cases if needed
    }
  }
}

class DoctorDashboardPage extends StatelessWidget {
  // Replace this with Firestore query to get patient data
  // List<Patient> patients = getDummyPatientData();
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();

  @override
  Widget build(BuildContext context) {
    // Sort patients by their total score (descending order)
    // patients.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: Icon(Icons.home),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Patient>>(
          future: _firebaseFunctions.getAllPatientsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Patient> patients = snapshot.data!;

              // Your existing code for sorting and displaying patients
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    Patient patient = patients[index];
                    return PatientCard(patient: patient);
                  },
                ),
              );
            } else {
              return Center(child: Text('No patients found.'));
            }
          },
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final Patient patient;

  PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    Color cardColor = patient.totalScore > 30 ? patient.totalScore >= 35 ? Colors.red : Colors.yellow : Colors.white;
    return Card(
      elevation: 3,
      color: cardColor,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient: ${patient.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 8),
            Text(
              'Total Score: ${patient.totalScore}',
              style: TextStyle(fontSize: 16,fontFamily: 'Poppins'),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle view patient details
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientDetailsPage(patient: patient)),
                    );
                  },
                  child: Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorBlogPage extends StatelessWidget {

  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blog Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: Icon(Icons.document_scanner),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<BlogCard>>(
          future: _firebaseFunctions.getBlogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading blogs'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No blogs available'),
              );
            } else {
              List<BlogCard> blogs = snapshot.data!;
              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  return blogs[index];
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBlogPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final DateTime time;

  BlogCard({required this.id, required this.title, required this.content, required this.time});

  void _launchURL(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontFamily: 'Poppins',fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      RegExp exp = RegExp(r'https?://\S+');
                      Iterable<RegExpMatch> matches = exp.allMatches(content);
                      for (RegExpMatch match in matches) {
                        String url = match.group(0)!;
                        _launchURL(url);
                      }
                    },
                    child: SelectableText(
                      content,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Posted on: ${time.toLocal()}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  bool confirmDeletion = await _showDeleteConfirmationDialog(context);
                  if (confirmDeletion) {
                    if (user?.email == 'nandanigulati@gmail.com' || user?.email == 'testdoctor@gmail.com'){
                      try {
                        // Assuming you have a reference to the Firestore collection
                        final medicinesCollection =
                            FirebaseFirestore.instance.collection('blogs');

                        // Use the document ID from the QueryDocumentSnapshot
                        final medicineDoc = medicinesCollection.doc(id);

                        // Delete the document
                        await medicineDoc.delete();
                      } catch (e) {
                        print('Error deleting medicine: $e');
                      }
                    }
                    else {
                      final snackbar = SnackBar(content: Text('This feature is only available for the doctor'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this blog?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Dismiss dialog without deletion
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    ) ??
        false;
  }
}

class DoctorProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: Icon(Icons.person),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 16),
              Text(
                user != null ? 'Dr. ${user.displayName}' : 'Dr. John Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Specialist in Internal Medicine',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pop(); // Navigate back after logout
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Patient {
  final String id;
  final String name;
  final int totalScore;
  final int age;
  final Map<String, dynamic> copdData;

  // Add other properties based on your patient document structure

  Patient({
    required this.id,
    required this.name,
    required this.totalScore,
    required this.age,
    required this.copdData,
    // Add other properties here
  });

  // Named constructor to create an instance from Firestore data
  factory Patient.fromFirestore(Map<String, dynamic> data, String id, Map<String, dynamic> copd) {
    return Patient(
      id: id,
      name: data['name'] ?? '',
      totalScore: copd['catScore'] ?? 0,
      age: data['age'] ?? 0,
      copdData: copd,
      // Initialize other properties based on your patient document
    );
  }
}
