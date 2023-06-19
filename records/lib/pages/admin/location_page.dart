import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
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
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                ),
                Card(
                  child: Opacity(
                    opacity: 0.9, // Set the desired opacity value here
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
        );
      }),
    );
  }
}
