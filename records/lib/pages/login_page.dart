// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:records/common/theme_helper.dart';
import 'package:records/pages/admin/home_page.dart';
import 'package:records/pages/user/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'widgets/header_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final secureStorage = FlutterSecureStorage();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final userRole = userDoc.get('role');
      if (userRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else if (userRole == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.fingerprint),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    const Text(
                      'Reportify',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Sign in to your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 70.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextField(
                              controller: _emailController,
                              decoration: ThemeHelper().textInputDecoration(
                                  'User Name', 'Enter your user name'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Password', 'Enter your password'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              onPressed: signIn,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      // Sign in user with Firebase authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final String uid = userCredential.user!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userRole = userDoc.get('role');

      // Save user role in secure storage
      await secureStorage.write(key: 'userRole', value: userRole);

      if (userRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else if (userRole == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Invalid user role'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign In Failed'),
              content: const Text('User not found'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign In Failed'),
              content: const Text('Incorrect password'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
