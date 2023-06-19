import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:records/common/theme_helper.dart';

class AddVisitsPage extends StatefulWidget {
  @override
  _AddVisitsPageState createState() => _AddVisitsPageState();
}

class _AddVisitsPageState extends State<AddVisitsPage> {
  final TextEditingController _visitController = TextEditingController();
  final TextEditingController _callController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  List<Map<String, dynamic>> salesData = [];

  void _submitForm2() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final currentDate = DateTime.now();
    final databaseReference = FirebaseFirestore.instance;

    final document = await databaseReference
        .collection('sales')
        .doc(userId)
        .collection(currentDate.toString().substring(0, 10))
        .doc('Visits')
        .get();

    if (document.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already submitted a visit record for today'),
        ),
      );
    } else {
      await databaseReference
          .collection('records')
          .doc(userId)
          .collection('visits')
          .doc(currentDate.toString().substring(0, 10))
          .set({
        'userId': userId,
        'visitsData': salesData.map((data) {
          return {
            'visit': data['visit'],
            'call': data['call'],
            'vehicle': data['vehicle'],
            'area': data['area'],
            'timestamp': Timestamp.now(),
          };
        }).toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visit data submitted')),
      );
    }
  }

  void _submitForm1() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    final currentDate = DateTime.now();
    final databaseReference = FirebaseDatabase.instance.reference();

    final salesRef = databaseReference
        .child('records')
        .child(email!.split('@')[0].replaceAll('.', ''))
        .child('visits')
        .child(currentDate.toString().substring(0, 10));

    salesRef.set({
      'userId': email,
      'visitsData': salesData.map((data) {
        return {
          'visit': data['visit'],
          'call': data['call'],
          'vehicle': data['vehicle'],
          'area': data['area'],
          'timestamp': ServerValue.timestamp,
        };
      }).toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visit data submitted')),
    );
  }

  // Define a function to add the visits data to the list
  void _addVisitsData() {
    setState(() {
      salesData.add({
        'visit': _visitController.text,
        'call': _callController.text,
        'vehicle': _vehicleController.text,
        'area': _areaController.text,
      });
      _visitController.clear();
      _callController.clear();
      _vehicleController.clear();
      _areaController.clear();
    });
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add Sales Activities:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _visitController,
                    decoration: ThemeHelper().textInputDecoration(
                        'Number of Visits', 'Enter your Visits'),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _callController,
                    decoration: ThemeHelper().textInputDecoration(
                        'Number of Calls', 'Enter Number of Calls'),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _vehicleController,
                    decoration: ThemeHelper().textInputDecoration(
                        'Vehicle Number', 'Enter The Vehicle Number'),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _areaController,
                    decoration: ThemeHelper()
                        .textInputDecoration('Area', 'Enter The Area'),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: _addVisitsData,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          //icon no.1

                          'Add Activities Data'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Sales Activities:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: salesData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Visit ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Number of Visits: ${salesData[index]['visit']} | Number of Calls: ${salesData[index]['call']} | Vehicle Number: ${salesData[index]['vehicle']} | Area: ${salesData[index]['area']}',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: salesData.isEmpty
                          ? null
                          : () {
                              _submitForm2();
                              _submitForm1();
                              // _clearData();
                            },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          'Submit'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    //align text to center
                    alignment: Alignment.bottomCenter,
                    child: const Text(
                      //icon warning
                      '💡 Input visit records by providing the number of visits, number of calls, vehicle number, and the area visited.',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(153, 103, 103, 103)),
                      //align text to center
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Define a function to clear the visits data
  void _clearData() {
    setState(() {
      salesData.clear();
    });
  }
}
