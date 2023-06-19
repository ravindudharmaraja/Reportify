import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:records/pages/widgets/header_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalNumberOfUsers = 0;
  int totalNumberOfSales = 0;

  @override
  void initState() {
    super.initState();
    fetchTotalNumberOfUsers();
    fetchTotalNumberOfSales();
  }

  void fetchTotalNumberOfUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      totalNumberOfUsers = snapshot.docs.length;
    });
  }

  void fetchTotalNumberOfSales() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final snapshot =
        await FirebaseFirestore.instance.collectionGroup('records').get();

    setState(() {
      totalNumberOfSales = snapshot.docs.length;
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
            child: Stack(
              children: [
                const SizedBox(
                  height: 100,
                  child: HeaderWidget(100, false, Icons.house_rounded),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 4.0),
                            ),
                            Card(
                              child: Opacity(
                                opacity:
                                    0.8, // Set the desired opacity value here
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      // Square
                                      Container(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/splash.png',
                                          width: 160,
                                          height: 100,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      //add image under.jpg
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 4.0),
                            ),
                            Card(
                              child: Opacity(
                                opacity:
                                    0.9, // Set the desired opacity value here
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      // Square
                                      Container(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/under.jpg',
                                          width: 300,
                                          height: 200,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        //align text to center
                        alignment: Alignment.bottomCenter,
                        child: const Text(
                          //icon warning
                          '⚠'
                          "We apologize for the inconvenience. This page is currently under development and not available for use. Our team is working hard to bring you a better experience. Thank you.",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(153, 103, 103, 103)),
                          //align text to center
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           'Total Number of Users: $totalNumberOfUsers',
    //           style: TextStyle(fontSize: 20),
    //         ),
    //         SizedBox(height: 16),
    //         Text(
    //           'Total Number of Sales: $totalNumberOfSales',
    //           style: TextStyle(fontSize: 20),
    //         ),
    //       ],
    //     ),
    //   ),
  }
}
