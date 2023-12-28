import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copdbuddy/pages/patient_mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:copdbuddy/components/my_button.dart';
import 'package:copdbuddy/components/my_textfield.dart';
import 'package:copdbuddy/components/square_tile.dart';
import 'package:flutter/material.dart';

class PatientRegister extends StatefulWidget {
  const PatientRegister({Key? key}) : super(key: key);

  @override
  State<PatientRegister> createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final fullnameController = TextEditingController();
  final ageController = TextEditingController();
  final sextypeController = TextEditingController();
  final docuidController = TextEditingController();

  bool circular = false;

  void registerUser() async {
    setState(() {
      circular = true;
    });
    if (!passwordConfirmed()){
      return;
    }
    try
    {
      firebase_auth.UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: usernameController.text, password: passwordController.text);
      print(userCredential.user?.email);

      String userUid = userCredential.user!.uid;

      firebaseAuth.currentUser?.updateDisplayName(fullnameController.text.trim());

      addUserDetails(userUid, fullnameController.text.trim(), sextypeController.text.trim(), int.parse(ageController.text.trim()), docuidController.text.trim(), usernameController.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
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
  
  Future addUserDetails(String uid, String name, String sex, int age, String docid, String email) async {
    await FirebaseFirestore.instance.collection('patients').doc(uid).set({
      'name' : name,
      'age' : age,
      'sex' : sex,
      'docid' : docid,
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
                const Text(
                  'Welcome to Breathe Buddy',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'
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

                MyTextField(
                  controller: docuidController ,
                  hintText: 'Enter your doctor ID',
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

                const SizedBox(height: 10,),

                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already registered?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Return back to Signin screen',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
