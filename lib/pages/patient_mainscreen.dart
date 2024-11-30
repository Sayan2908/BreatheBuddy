import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copdbuddy/components/gradientcard.dart';
import 'package:copdbuddy/firebase_functions.dart';
import 'package:copdbuddy/pages/doctor_homepage.dart';
import 'package:copdbuddy/pages/patient_AddMedicinePage.dart';
import 'package:copdbuddy/pages/patient_asthmaform.dart';
import 'package:copdbuddy/pages/patient_copdform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _getBody(),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(20),
          height: size.width * .155,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width * .024),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(
                  () {
                    _currentIndex = index;
                  },
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    margin: EdgeInsets.only(
                      bottom: index == _currentIndex ? 0 : size.width * .029,
                      right: size.width * .0422,
                      left: size.width * .0422,
                    ),
                    width: size.width * .128,
                    height: index == _currentIndex ? size.width * .014 : 0,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                  ),
                  Icon(
                    listOfIcons[index],
                    size: size.width * .076,
                    color: index == _currentIndex
                        ? Colors.orangeAccent
                        : Colors.black38,
                  ),
                  SizedBox(height: size.width * .03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.medical_information,
    Icons.read_more,
    Icons.person_rounded,
  ];

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _getFormsScene();
      case 1:
        return _getMedicinesScene();
      case 2:
        return _getBlogsScene();
      case 3:
        return _getProfileScene();
      default:
        return Container();
    }
  }

  Widget _getFormsScene() {
    DateTime? selectedDate;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FormsScreen()),
                  ),
              child: GradientCard(
                  text: 'Fill up the Copd Form',
                  imagePath: "patient-coughing.png")),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AsthmaForm()),
            ),
            child: Container(
              height: 75,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Fill up Asthma form",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () async {
              // Show date picker
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
              );

              // If a date is chosen, update the state and upload to Firestore
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });

                // Add your logic to upload to Firestore
                await _firebaseFunctions.uploadToFirestore(
                    selectedDate!, _auth.currentUser?.uid ?? '');
              }
            },
            child: Text('Schedule Next Appointment'),
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() async {
    return _showLogoutConfirmationDialog();
  }

  Future<bool> _showLogoutConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logout Confirmation'),
              content: Text('Are you sure you want to logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User clicked No
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User clicked Yes
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

// Create dummy data for medicines
//   List<Medicine> dummyMedicines = [
//     Medicine(
//         name: 'Medicine 1',
//         timeOfDay: TimeOfDay(hour: 8, minute: 0)), // Morning
//     Medicine(
//         name: 'Medicine 2',
//         timeOfDay: TimeOfDay(hour: 18, minute: 0)), // Evening
//     // Add more medicines as needed
//   ];

// Create a widget to display medicines
  Widget _getMedicinesScene() {
    User? user = _auth.currentUser;
    String userId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medicines',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: Icon(Icons.medical_information),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Medicine>>(
          future: FirebaseFunctions().getMedicines(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No medicines available.'));
            } else {
              // Sort medicines based on scheduled time
              List<Medicine> medicines = snapshot.data!
                ..sort((a, b) =>
                    a.timeOfDay.hour * 60 +
                    a.timeOfDay.minute -
                    (b.timeOfDay.hour * 60 + b.timeOfDay.minute));

              return ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  return _buildMedicineCard(medicines[index]);
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
            MaterialPageRoute(
                builder: (context) => AddMedicinePage(userId: userId)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicineCard(Medicine medicine) {
    // Get the current time
    User? user = _auth.currentUser;
    String userId = user?.uid ?? '';
    DateTime now = DateTime.now();
    TimeOfDay currentTime = TimeOfDay.fromDateTime(now);

    // Convert the scheduled time to DateTime
    DateTime scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      medicine.timeOfDay.hour,
      medicine.timeOfDay.minute,
    );

    // Check if the scheduled time is in the past, present, or future
    Color cardColor;
    if (now.isAfter(scheduledDateTime)) {
      // Time has passed, set card to green
      cardColor = Colors.green[400] ?? Colors.greenAccent;
    } else if (now.isBefore(scheduledDateTime)) {
      // Time is yet to come, set card to yellow accent
      cardColor = Colors.yellow[200] ?? Colors.yellowAccent;
    } else {
      // Time is now, set card to default color (you can choose another color)
      cardColor = Colors.white;
    }

    return Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        color: cardColor,
        child: ListTile(
          title: Text(
            medicine.name,
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          subtitle: Text('Time of Day: ${_formatTime2(medicine.timeOfDay)}'),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                bool confirmDeletion = await _showDeleteConfirmationDialog();
                if (confirmDeletion) {
                  try {
                    // Assuming you have a reference to the Firestore collection
                    final medicinesCollection = FirebaseFirestore.instance
                        .collection('patients/$userId/medicines');

                    // Use the document ID from the QueryDocumentSnapshot
                    final medicineDoc = medicinesCollection.doc(medicine.id);

                    // Delete the document
                    await medicineDoc.delete();

                    // Refresh the UI (rebuild widget)
                    setState(() {});
                  } catch (e) {
                    print('Error deleting medicine: $e');
                  }
                }
              }),
        ));
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete this medicine?'),
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

  String _formatTime2(TimeOfDay timeOfDay) {
    return '${timeOfDay.hourOfPeriod}:${timeOfDay.minute} ${timeOfDay.period.toString().split('.')[1]}';
  }

  Widget _getBlogsScene() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blogs',
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
    );
  }

  Widget _getProfileScene() {
    User? user = _auth.currentUser;
    String userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
      body: Center(
        child: FutureBuilder<String>(
          future: _firebaseFunctions.fetchAppointmentDate(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while the data is being fetched
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Show an error message if there's an error
              return Text('Error: ${snapshot.error}');
            } else {
              // Display the profile information
              String appointDate = snapshot.data ?? '';

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    user != null
                        ? user.displayName ?? 'User Name'
                        : 'User Name',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user != null
                        ? user.email ?? 'user@example.com'
                        : 'user@example.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text('Next Appointment: ${appointDate.substring(0, 10)}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Handle logout logic here
                      await _auth.signOut();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text('Logout'),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

// Define a Medicine class to represent each medicine
class Medicine {
  final String id;
  final String name;
  final TimeOfDay timeOfDay;

  Medicine({required this.id, required this.name, required this.timeOfDay});
}

void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));
