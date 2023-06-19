import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:records/pages/admin/userAdd_page.dart';
import 'package:records/pages/admin/userSalesRecords_page.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String category;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.category,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      category: data['category'],
    );
  }
}

class ViewRecordsPage extends StatefulWidget {
  const ViewRecordsPage({Key? key})
      : super(key: key); // Add the super constructor with the key parameter

  @override
  _ViewRecordsPageState createState() => _ViewRecordsPageState();
}

class _ViewRecordsPageState extends State<ViewRecordsPage> {
  List<String> categories = [
    'All',
    'Back Office',
    'Front Office',
    'Sales',
    'MT',
  ];
  String selectedCategory = 'Sales';

  void handleUserSelection(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSalesPage(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Text(
                        'Categories: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue ?? 'All';
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('category',
                          isEqualTo: selectedCategory == 'All'
                              ? null
                              : selectedCategory)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<User> users = snapshot.data!.docs
                        .map((doc) => User.fromFirestore(doc))
                        .toList();

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        User user = users[index];
                        Color itemColor;
                        if (index == 0) {
                          itemColor = Color.fromARGB(255, 100, 5, 232)
                              .withOpacity(0.5); // First item color: yellow
                        } else if (index == 1) {
                          itemColor = Color.fromARGB(255, 100, 5, 232)
                              .withOpacity(0.4); // Second item color: gray
                        } else if (index == 2) {
                          itemColor = Color.fromARGB(255, 100, 5, 232)
                              .withOpacity(0.2); // Third item color: brown
                        } else {
                          itemColor = Colors.grey.withOpacity(
                              0.6); // Rest of the items: white with opacity
                        }
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: itemColor,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(user.name),
                              subtitle: Text(
                                  user.email.split('@')[0].replaceAll('.', '')),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          onTap: () {
                            handleUserSelection(user.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          _addUser();
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _addUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}
