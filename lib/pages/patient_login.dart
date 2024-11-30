import 'package:copdbuddy/pages/forgot_password.dart';
import 'package:copdbuddy/pages/patient_mainscreen.dart';
import 'package:copdbuddy/pages/patient_register.dart';
import 'package:flutter/material.dart';
import 'package:copdbuddy/components/my_button.dart';
import 'package:copdbuddy/components/my_textfield.dart';
import 'package:copdbuddy/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class PatientLogin extends StatefulWidget {
  const PatientLogin({Key? key}) : super(key: key);

  @override
  State<PatientLogin> createState() => _PatientLoginState();
}

class _PatientLoginState extends State<PatientLogin> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool circular = false;

  void signUserIn() async {
    setState(() {
      circular = true;
    });
    try
        {
          firebase_auth.UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: usernameController.text.trim(), password: passwordController.text.trim());
          print(userCredential.user?.email);
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
                  'Welcome',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'
                  ),
                ),
          
                const SizedBox(height: 25),
          
                // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
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
          
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 25),
          
                // sign in button
                MyButton(
                  onTap: signUserIn,
                  ButtonText: 'Sign In',
                ),
          
                const SizedBox(height: 50),
          
                // not a member? register now
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientRegister()),
                  ) ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

