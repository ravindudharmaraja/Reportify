import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:records/pages/location_page.dart';
import 'package:records/pages/login_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:records/pages/user/addSales_page.dart';
import 'package:records/pages/user/addVisits_page.dart';
import 'package:records/pages/user/report_page.dart';
import 'package:records/pages/user/sales_page.dart';
import 'package:records/pages/user/user_profile_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserHomePageState();
  }
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;
  int _currentSelected = 0;
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = '';

    // Determine the title based on the selected index
    switch (_currentIndex) {
      case 0:
        appBarTitle = 'Dashboard';
        break;
      case 1:
        appBarTitle = 'Sales Performence';
        break;
      case 2:
        appBarTitle = 'Sales Activities';
        break;
      case 3:
        appBarTitle = 'Reports';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                0.0,
                1.0
              ],
                  colors: [
                Theme.of(context).primaryColor.withOpacity(0.2),
                Theme.of(context).accentColor.withOpacity(0.5),
              ])),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).accentColor,
                    ],
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/a.png'),
                        radius: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentUser!.displayName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _currentUser?.email
                                ?.split('@')[0]
                                .replaceAll('.', '') ??
                            '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: _drawerIconSize,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: _drawerFontSize),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  size: _drawerIconSize,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(fontSize: _drawerFontSize),
                ),
                onTap: () {
                  _auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                },
              ),
              const SizedBox(height: 320),
              Container(
                padding: const EdgeInsets.all(46),
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/images/splash.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            activeColor: const Color.fromARGB(255, 225, 54, 244),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.bar_chart),
            title: const Text('Sales Performence'),
            activeColor: const Color.fromARGB(255, 182, 64, 251),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.trip_origin),
            title: const Text(
              'Activities',
            ),
            activeColor: const Color.fromARGB(255, 128, 30, 233),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.document_scanner),
            title: const Text(
              'Reports',
            ),
            activeColor: const Color.fromARGB(255, 54, 30, 233),
            textAlign: TextAlign.center,
          ),
        ],
        onItemSelected: (int value) {
          setState(() {
            _currentIndex = value;
            _currentSelected = value;
          });
        },
      ),
      body: _getDrawerItemWidget(_currentSelected),
    );
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const SalesPage();
      case 1:
        return AddSalesPage();
      case 2:
        return AddVisitsPage();
      case 3:
        return FirestoreToCSVPage();

      default:
        return const Text('Error');
    }
  }
}
