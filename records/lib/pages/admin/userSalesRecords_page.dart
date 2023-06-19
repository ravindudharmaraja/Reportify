import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:records/pages/admin/records_page.dart';

class UserSalesPage extends StatefulWidget {
  final String userId;

  const UserSalesPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserSalesPageState();
  }
}

class _UserSalesPageState extends State<UserSalesPage> {
  List<SalesRecord> salesData = [];
  List<SalesRecord> todaySalesData = [];
  List<SalesRecord> yesterdaySalesData = [];
  List<SalesRecord> monthlySalesData = [];
  List<VisitRecord> todayVisitData = [];
  late String userId;

  @override
  void initState() {
    super.initState();
    final userId = widget.userId;
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

    // Fetch today's visit records

    databaseReference
        .collection('records')
        .doc(userId)
        .collection('visits')
        .doc(currentDate.toString().substring(0, 10))
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          todayVisitData = List<Map<String, dynamic>>.from(doc['visitsData'])
              .map((data) => VisitRecord.fromJson(data))
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sales Page",
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
              ])),
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
                )
              ],
            ),
          )
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
            child: Column(
              children: [
                const SizedBox(height: 3.0),
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
                  height: 140,
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
                          if (monthlySalesData.isNotEmpty &&
                              getCurrentMonthSales(monthlySalesData) > 0)
                            Text(
                              'Monthly Sales Performence: ${getCurrentMonthSales(monthlySalesData)} units',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          if (monthlySalesData.isNotEmpty &&
                              getCurrentMonthSales(monthlySalesData) > 0)
                            const SizedBox(height: 8.0),
                          if (monthlySalesData.isNotEmpty &&
                              getCurrentMonthSales(monthlySalesData) > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _getMonthlyProductTotals()
                                  .map((productTotal) => Text(
                                        '${productTotal.product}: ${productTotal.totalUnits} units',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                      if (monthlySalesData.isEmpty ||
                          getCurrentMonthSales(monthlySalesData) == 0)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.data_exploration,
                                  size: 60.0,
                                  color: Color.fromARGB(199, 244, 67, 54)),
                              Text(
                                'No sales data available for this month.',
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
                Container(
                  height: 140,
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
                          if (monthlySalesData.isNotEmpty &&
                              getCurrentDaySales(monthlySalesData) > 0)
                            Text(
                              'Today Sales Performence: ${getCurrentDaySales(monthlySalesData)} units',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          if (monthlySalesData.isNotEmpty &&
                              getCurrentDaySales(monthlySalesData) > 0)
                            const SizedBox(height: 10.0),
                          if (monthlySalesData.isNotEmpty &&
                              getCurrentDaySales(monthlySalesData) > 0)
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
                      if (monthlySalesData.isEmpty ||
                          getCurrentDaySales(monthlySalesData) == 0)
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

                Container(
                  height: 140,
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
                          if (todayVisitData.isNotEmpty)
                            const Text(
                              "Today's Sales Activities",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          if (todayVisitData.isNotEmpty)
                            const SizedBox(height: 10.0),
                          if (todayVisitData.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                itemCount: todayVisitData.length,
                                itemBuilder: (context, index) {
                                  final visit = todayVisitData[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Number of visits: ${visit.visit}',
                                            style: const TextStyle(
                                                fontSize: 12.0)),
                                        Text('Number of Call: ${visit.call}',
                                            style: const TextStyle(
                                                fontSize: 12.0)),
                                        Text('Vehicle No: ${visit.vehicle}',
                                            style: const TextStyle(
                                                fontSize: 12.0)),
                                        Text('Area: ${visit.area}',
                                            style: const TextStyle(
                                                fontSize: 12.0)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      if (todayVisitData.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.data_exploration,
                                size: 60.0,
                                color: Color.fromARGB(199, 244, 67, 54),
                              ),
                              Text(
                                'No visit data available for today.',
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

                // //monthly sales total
                // const SizedBox(height: 3.0),
                // Container(
                //   height: 120,
                //   width: double.infinity,
                //   margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                //   padding: const EdgeInsets.all(16.0),
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8.0),
                //     gradient: LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //         Theme.of(context).primaryColor,
                //         Theme.of(context).accentColor,
                //       ],
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.1),
                //         spreadRadius: 2,
                //         blurRadius: 10,
                //         offset: const Offset(0, 2),
                //       ),
                //     ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       // Display total sales for the month
                //       const Text(
                //         'Total Sales this Month',
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //           color: Color.fromARGB(255, 216, 215, 215),
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       Text(
                //         'Units ${getCurrentMonthSales(monthlySalesData)}',
                //         style: const TextStyle(
                //           fontSize: 50,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Container(
                  padding: const EdgeInsets.all(10),
                  //align text to center
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    //icon warning

                    '💡 This page provides an interface to view and analyze users sales records and monthly sales performance',
                    style: TextStyle(
                        fontSize: 11,
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

  //get today's sales
  int getCurrentDaySales(List<SalesRecord> salesData) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day + 1);

    return salesData
        .where((sales) =>
            sales.date.isAfter(startOfDay) && sales.date.isBefore(endOfDay))
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

  List<ProductTotal> _getMonthlyProductTotals() {
    Map<String, int> productTotals = {};

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    for (var sale in monthlySalesData) {
      if (sale.date.isAfter(startOfMonth) && sale.date.isBefore(endOfMonth)) {
        if (productTotals.containsKey(sale.product)) {
          productTotals[sale.product] =
              (productTotals[sale.product] ?? 0) + sale.sales;
        } else {
          productTotals[sale.product] = sale.sales;
        }
      }
    }

    return productTotals.entries
        .map((entry) =>
            ProductTotal(product: entry.key, totalUnits: entry.value))
        .toList();
  }
}

class ProductTotal {
  final String product;
  final int totalUnits;

  ProductTotal({required this.product, required this.totalUnits});
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

class VisitRecord {
  final String visit;
  final String call;
  final String vehicle;
  final String area;
  final Timestamp timestamp;

  VisitRecord({
    required this.visit,
    required this.call,
    required this.vehicle,
    required this.area,
    required this.timestamp,
  });

  DateTime get date => timestamp.toDate();

  factory VisitRecord.fromJson(Map<String, dynamic> json) {
    return VisitRecord(
      visit: json['visit'],
      call: json['call'],
      vehicle: json['vehicle'],
      area: json['area'],
      timestamp: json['timestamp'],
    );
  }
}
