import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copdbuddy/pages/doctor_homepage.dart';
import 'package:copdbuddy/pages/patient_mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:copdbuddy/components/my_button.dart';
import 'package:copdbuddy/components/my_textfield.dart';
import 'package:copdbuddy/components/square_tile.dart';
import 'package:flutter/material.dart';

class DoctorRegister extends StatefulWidget {
  const DoctorRegister({Key? key}) : super(key: key);

  @override
  State<DoctorRegister> createState() => _DoctorRegisterState();
}

class _DoctorRegisterState extends State<DoctorRegister> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final fullnameController = TextEditingController();
  final ageController = TextEditingController();
  final sextypeController = TextEditingController();

  bool circular = false;

  void registerUser() async {
    setState(() {
      circular = true;
    });
    if (!passwordConfirmed()){
      final snackbar1 = SnackBar(content: Text('Both passwords dont match'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar1);
      return;
    }
    try
    {
      firebase_auth.UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: usernameController.text, password: passwordController.text);
      print(userCredential.user?.email);

      String userUid = userCredential.user!.uid;

      firebaseAuth.currentUser?.updateDisplayName(fullnameController.text.trim());

      addUserDetails(userUid, fullnameController.text.trim(), sextypeController.text.trim(), int.parse(ageController.text.trim()), usernameController.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorHomePage()),
      );

      setState(() {
        circular=false;
      });


    }
    catch(e){
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      setState(() {
        circular=false;
      });
    }
  }

  Future addUserDetails(String uid ,String name, String sex, int age, String email) async {
    await FirebaseFirestore.instance.collection('doctor').doc(uid).set({
      'name' : name,
      'age' : age,
      'sex' : sex,
      'email' : email,
    });
  }

  bool passwordConfirmed(){
    if (passwordController.text.trim() == confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Icon(
                  Icons.vaccines,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Center(
                  child: const Text(
                    'Welcome to CopdBuddy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: fullnameController,
                  hintText: 'Enter your full name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: ageController,
                  hintText: 'Enter your age',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: sextypeController,
                  hintText: 'Enter your sex',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmpasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: registerUser,
                  ButtonText: 'Sign Up',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
