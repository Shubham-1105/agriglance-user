import 'package:flutter/material.dart';
import 'navigation_bar_web.dart';

class Home extends StatelessWidget {
  final Widget child;
  Home({@required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          NavigationBarWeb(),
          Expanded(
            child: child,
          )

        ],
      ),
    );
  }
}
