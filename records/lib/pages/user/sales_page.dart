import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:records/pages/login_page.dart';
import 'package:records/pages/user/addSales_page.dart';
import 'package:records/pages/user/user_profile_page.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SalesPageState();
  }
}

class _SalesPageState extends State<SalesPage> {
  List<SalesRecord> salesData = [];
  List<SalesRecord> yesterdaySalesData = [];
  List<SalesRecord> monthlySalesData = [];

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final currentDate = DateTime.now();
    final yesterdayDate = currentDate.subtract(const Duration(days: 1));

    final databaseReference = FirebaseFirestore.instance;

    databaseReference
        .collection('records')
        .doc(userId)
        .collection('sales')
        .doc(currentDate.toString().substring(0, 10))
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          salesData = List<Map<String, dynamic>>.from(doc['salesData'])
              .map((data) => SalesRecord.fromJson(data))
              .toList();
        });
      }
    });
    // Fetch yesterday's records
    databaseReference
        .collection('records')
        .doc(userId)
        .collection('sales')
        .doc(yesterdayDate.toString().substring(0, 10))
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          yesterdaySalesData = List<Map<String, dynamic>>.from(doc['salesData'])
              .map((data) => SalesRecord.fromJson(data))
              .toList();
        });
      }
    });

    // Fetch monthly records
    databaseReference
        .collection('records')
        .doc(userId)
        .collection('sales')
        .get()
        .then((querySnapshot) {
      final List<SalesRecord> allSalesData = [];

      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          final List<Map<String, dynamic>> salesData =
              List<Map<String, dynamic>>.from(doc['salesData']);

          salesData.forEach((data) {
            allSalesData.add(SalesRecord.fromJson(data));
          });
        }
      });

      setState(() {
        monthlySalesData = allSalesData;
      });
    });
  }

  @override

  // Define a function to handle the form submission
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  Future<void> _getUser() async {
    _user = _auth.currentUser;
    setState(() {});
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
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color.fromARGB(255, 255, 254, 254),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (salesData.isNotEmpty &&
                              getTodaysSales(salesData) > 0)
                            Text(
                              'Today\'s Sales: ${getTodaysSales(salesData)} units',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          if (salesData.isNotEmpty &&
                              getTodaysSales(salesData) > 0)
                            const SizedBox(height: 8.0),
                          if (salesData.isNotEmpty &&
                              getTodaysSales(salesData) > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: salesData
                                  .map((sales) => Text(
                                        '${sales.product}: ${sales.sales} units',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                      if (salesData.isEmpty || getTodaysSales(salesData) == 0)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.data_exploration,
                                  size: 60.0,
                                  color: Color.fromARGB(199, 244, 67, 54)),
                              Text(
                                'No sales data available for today.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 3.0),
                Container(
                  height: 150,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color.fromARGB(255, 255, 254, 254),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (yesterdaySalesData.isNotEmpty &&
                              getYesterdaySales(yesterdaySalesData) > 0)
                            Text(
                              'Yesterday\'s Sales: ${getYesterdaySales(yesterdaySalesData)} units',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          if (yesterdaySalesData.isNotEmpty &&
                              getYesterdaySales(yesterdaySalesData) > 0)
                            const SizedBox(height: 8.0),
                          if (yesterdaySalesData.isNotEmpty &&
                              getYesterdaySales(yesterdaySalesData) > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: yesterdaySalesData
                                  .map((sales) => Text(
                                        '${sales.product}: ${sales.sales} units',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                      if (yesterdaySalesData.isEmpty ||
                          getYesterdaySales(yesterdaySalesData) == 0)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.data_exploration,
                                  size: 60.0,
                                  color: Color.fromARGB(199, 244, 67, 54)),
                              Text(
                                'No sales data available for Yesterday.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                //monthly sales total
                const SizedBox(height: 3.0),
                Container(
                  height: 120,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).accentColor,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display total sales for the month
                      const Text(
                        'Total Sales this Month',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 216, 215, 215),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Units ${getCurrentMonthSales(monthlySalesData)}',
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  //align text to center
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    //icon warning
                    '💡 Sales records by providing the number of sales you achived',
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
        );
      }),
    );
  }

  int getTodaysSales(List<SalesRecord> salesData) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return salesData
        .where((sales) =>
            DateTime(sales.date.year, sales.date.month, sales.date.day)
                .isAtSameMomentAs(today))
        .fold(0, (sum, sales) => sum + sales.sales);
  }

  //get yesterday sales
  int getYesterdaySales(List<SalesRecord> salesData) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return salesData
        .where((sales) =>
            DateTime(sales.date.year, sales.date.month, sales.date.day)
                .isAtSameMomentAs(yesterday))
        .fold(0, (sum, sales) => sum + sales.sales);
  }

  //get last 30 days sales
  int getCurrentMonthSales(List<SalesRecord> salesData) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return salesData
        .where((sales) =>
            sales.date.isAfter(startOfMonth) && sales.date.isBefore(endOfMonth))
        .fold(0, (sum, sales) => sum + sales.sales);
  }
}

class SalesRecord {
  final String product;
  final int sales;
  final Timestamp timestamp;

  SalesRecord({
    required this.product,
    required this.sales,
    required this.timestamp,
  });

  DateTime get date => timestamp.toDate();

  factory SalesRecord.fromJson(Map<String, dynamic> json) {
    return SalesRecord(
      product: json['product'],
      sales: json['sales'],
      timestamp: json['timestamp'],
    );
  }
}
