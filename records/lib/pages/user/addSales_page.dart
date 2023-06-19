import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:records/common/theme_helper.dart';

class AddSalesPage extends StatefulWidget {
  @override
  _AddSalesPageState createState() => _AddSalesPageState();
}

class _AddSalesPageState extends State<AddSalesPage> {
  final TextEditingController _salesController = TextEditingController();

  // Define variables to store the sales data and selected product
  String selectedProduct = 'FTTH';
  int sales = 0;
  List<Map<String, dynamic>> salesData = [];

  // Define a function to handle the form submission
  void _submitForm2() async {
    // Get the current user ID
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // Get the current date
    final currentDate = DateTime.now();
    // Create a reference to the Firestore database
    final databaseReference = FirebaseFirestore.instance;

    // Check if the user has already submitted a sales record for the current day
    final document = await databaseReference
        .collection('sales')
        .doc(userId)
        .collection(currentDate
            .toString()
            .substring(0, 10)) // use date part of datetime as doc id
        .doc('sales')
        .get();

    if (document.exists) {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('You have already submitted a sales record for today')),
      );
    } else {
      // Add the sales data as a new document to the 'sales' collection with the current date as the document ID
      await databaseReference
          .collection('records')
          .doc(userId)
          .collection('sales')
          .doc(currentDate.toString().substring(0, 10))
          .set({
        'userId': userId,
        'salesData': salesData.map((data) {
          return {
            'product': data['product'],
            'sales': data['sales'],
            'timestamp': Timestamp.now(),
          };
        }).toList(),
      });

      // Show a confirmation message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sales data submitted')),
      );
    }
  }

  // Define a function to handle the form submission
  void _submitForm1() async {
    // Get the current user ID
    final email = FirebaseAuth.instance.currentUser!.email;
    // Get the current date
    final currentDate = DateTime.now();
    // Create a reference to the Realtime Database
    final databaseReference = FirebaseDatabase.instance.reference();

    // Get the reference to the specific sales record
    final salesRef = databaseReference
        .child('records')
        .child(email!.split('@')[0].replaceAll('.', ''))
        .child('sales')
        .child(currentDate.toString().substring(0, 10));

    // Add the sales data as a new record in the Realtime Database
    salesRef.set({
      'userId': email,
      'salesData': salesData.map((data) {
        return {
          'product': data['product'],
          'sales': data['sales'],
          'timestamp': ServerValue
              .timestamp, // Use ServerValue.timestamp for the timestamp
        };
      }).toList(),
    });

    // Show a confirmation message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sales data submitted')),
    );
  }

  // Define a function to update the selected product
  void _updateProduct(String? product) {
    setState(() {
      selectedProduct = product ?? '';
    });
  }

  // Define a function to update the sales data
  void _updateSales(String value) {
    setState(() {
      sales = int.tryParse(value) ?? 0;
    });
  }

  // Define a function to add the sales data to the list
  void _addSalesData() {
    salesData.add({
      'product': selectedProduct,
      'sales': sales,
    });
    _salesController.clear();
    // Reset the form
    _updateProduct('FTTH');
    _updateSales('');
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
                    'Select the product:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: DropdownButtonFormField<String>(
                            value: selectedProduct,
                            onChanged: _updateProduct,
                            // ignore: prefer_const_literals_to_create_immutables
                            items: [
                              const DropdownMenuItem(
                                value: 'FTTH',
                                child: Text('FTTH'),
                              ),
                              const DropdownMenuItem(
                                value: 'LTE',
                                child: Text('LTE'),
                              ),
                              const DropdownMenuItem(
                                value: 'Peo TV',
                                child: Text('Peo TV'),
                              ),
                              const DropdownMenuItem(
                                value: 'Fixed Broadband',
                                child: Text('Fixed Broadband'),
                              ),
                              const DropdownMenuItem(
                                value: 'M-SIM',
                                child: Text('M-SIM'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _salesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Sales',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: _updateSales,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: _addSalesData,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          'Add Sales Data'.toUpperCase(),
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
                    'Sales Data:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  DataTable(
                    columns: const [
                      DataColumn(
                        label: Text('Product'),
                      ),
                      DataColumn(
                        label: Text('Sales'),
                      ),
                    ],
                    rows: salesData
                        .map((data) => DataRow(
                              cells: [
                                DataCell(Text(data['product'])),
                                DataCell(Text(data['sales'].toString())),
                              ],
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      onPressed: () {
                        _submitForm1();
                        _submitForm2();
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

                      '💡 Input sales records by selecting a product from the dropdown menu and entering the quantity sold. The sale date will be automatically generated.',
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
}
