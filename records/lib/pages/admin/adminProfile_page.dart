import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:records/pages/widgets/header_widget.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminProfilePageState();
  }
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = _auth.currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help & Support",
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
          // Container(
          //   margin: const EdgeInsets.only( top: 16, right: 16,),
          //   child: Stack(
          //     children: <Widget>[
          //       const Icon(Icons.notifications),
          //       Positioned(
          //         right: 0,
          //         child: Container(
          //           padding: const EdgeInsets.all(1),
          //           decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
          //           constraints: const BoxConstraints( minWidth: 12, minHeight: 12, ),
          //           child: const Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
          //         ),
          //       )
          //     ],
          //   ),
          // )
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
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      //square
                                      //'assets/images/logo.png'
                                      Container(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/splash.png',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
          
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              const ListTile(
                                                leading: Icon(Icons.person),
                                                title: Text("Name"),
                                                subtitle: Text("Ravindu Dharmaraja"),
                                              ),
                                              const ListTile(
                                                contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 4),
                                                leading: Icon(Icons.my_location),
                                                title: Text("Location"),
                                                subtitle: Text("Sri Lanka"),
                                              ),
                                              const ListTile(
                                                leading: Icon(Icons.email),
                                                title: Text("Email"),
                                                subtitle: Text(
                                                    "ravindudharmaraja00@gmail.com"),
                                              ),
                                              const ListTile(
                                                leading: Icon(Icons.phone),
                                                title: Text("Phone"),
                                                subtitle: Text("+94 78 737 9991"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
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
                            "If you encounter any errors or issues, please don't hesitate to contact me using the provided contact details above. I'll be happy to assist you and help resolve any problems you may be facing. Thank you.",
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
  }
}
