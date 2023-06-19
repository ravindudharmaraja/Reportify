// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/theme_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password, _name, _category;
  final List<String> categories = [
    'Back Office',
    'Front Office',
    'Sales',
    'MT'
  ];

  @override
  void initState() {
    super.initState();
    _category = categories[0]; // Initialize _category with the first category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add User",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                const Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Name field
                    TextFormField(
                      decoration: ThemeHelper()
                          .textInputDecoration("Name", "Enter Name"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (input) => _name = input!,
                    ),

                    // Email field
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: ThemeHelper().textInputDecoration(
                          "E-mail address", "Enter your email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                      onSaved: (input) => _email = input!,
                    ),

                    // Password field
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: ThemeHelper()
                          .textInputDecoration("Password", "Enter password"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (input.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input!,
                      obscureText: true,
                    ),

                    // Category dropdown
                    const SizedBox(height: 20.0),
                    InputDecorator(
                      decoration: ThemeHelper().textInputDecoration(
                          "Categories", "Select User Category"),
                      isEmpty: _category == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _category,
                          isDense: true,
                          onChanged: (String? value) {
                            setState(() {
                              _category = value!;
                            });
                          },
                          items: categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Register button
                    const SizedBox(height: 20.0),
                    Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        onPressed: () {
                          register();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            'Add User'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Privacy message
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: const Text(
                        '💡 The user add page allows you to securely create new user accounts by providing their name, email, and password. Privacy and confidentiality are prioritized.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(153, 103, 103, 103),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserCredential? userCredential;
      try {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } catch (e) {
        print('Error creating user: $e');
      }

      if (userCredential != null && userCredential.user != null) {
        // User registration successful, proceed with saving additional data
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _name,
            'email': _email,
            'role': 'user',
            'category': _category,
          });

          // Show success message or navigate to another screen
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('User registered successfully.'),
                actions: <Widget>[
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
        } catch (e) {
          // Show error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(e.toString()),
                actions: <Widget>[
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
      }
    }
  }
}
