import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FirestoreToCSVPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        height: constraints.maxHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              ),
              Card(
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/under.jpg',
                            width: 300,
                            height: 200,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            // Add your logic for the button onPressed event here
                          },
                          child: const Text('Export Firestore to CSV'),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Tip: 💡 Make sure you have the necessary permissions to access Firestore data and save files to the device.',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}



//   Future<void> exportFirestoreDataToCSV(BuildContext context) async {
//     final CollectionReference collectionRef =
//         FirebaseFirestore.instance.collection('records');

//     // Fetch the data from Firestore
//     QuerySnapshot querySnapshot = await collectionRef.get();

//     // Convert Firestore data to CSV format
//     List<List<dynamic>> csvData = [
//       ['Field 1', 'Field 2', 'Field 3'] // CSV header
//     ];

//     querySnapshot.docs.forEach((doc) {
//       // Add data from each document to the CSV list
//       List<dynamic> rowData = [
//         doc['field1'],
//         doc['field2'],
//         doc['field3'],
//       ];
//       csvData.add(rowData);
//     });

//     // Convert CSV data to a string
//     String csvString = const ListToCsvConverter().convert(csvData);

//     // Get the device's documents directory
//     Directory? documentsDir = await getExternalStorageDirectory();
//     String documentsPath = documentsDir!.path;

//     // Save CSV file
//     File csvFile = File('$documentsPath/firestore_data.csv');
//     await csvFile.writeAsString(csvString);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Firestore Data Exported'),
//           content: Text('Firestore data has been exported as a CSV file.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

