import 'package:copdbuddy/pages/doctor_homepage.dart';
import 'package:copdbuddy/pages/doctor_register.dart';
import 'package:copdbuddy/pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:copdbuddy/components/my_button.dart';
import 'package:copdbuddy/components/my_textfield.dart';

class DoctorLogin extends StatefulWidget {
  const DoctorLogin({Key? key}) : super(key: key);

  @override
  State<DoctorLogin> createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    try {
      if (usernameController.text.trim() == 'testdoctor@gmail.com' || usernameController.text.trim() == 'nandanigulati@gmail.com') {
        firebase_auth.UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
                email: usernameController.text.trim(),
                password: passwordController.text.trim());
        print(userCredential.user?.email);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorHomePage()),
        );
      } else {
        final snackbar1 = SnackBar(
            content: Text('There is no doctor with this registered email'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar1);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                  Icons.medical_services,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
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

                const SizedBox(
                  height: 50,
                ),

                // InkWell(
                //   onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => DoctorRegister()),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         'Not a member?',
                //         style: TextStyle(color: Colors.grey[700]),
                //       ),
                //       const SizedBox(width: 4),
                //       const Text(
                //         'Register now',
                //         style: TextStyle(
                //           color: Colors.blue,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
