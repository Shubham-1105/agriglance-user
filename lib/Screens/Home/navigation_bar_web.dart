import 'dart:ui';

import 'package:flutter/material.dart';
import '../../routes.dart';

class NavigationBarWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
              onTap: () {
                navKey.currentState.pushNamed(routeTests);
              },
              child: Text(
                "Tests",
                style: TextStyle(fontSize: 20.0),
              )),
          SizedBox(
            width: 100.0,
          ),
          GestureDetector(
              onTap: () {
                navKey.currentState.pushNamed(routeMaterials);
              },
              child: Text(
                "Materials ",
                style: TextStyle(fontSize: 20.0),
              )),
          SizedBox(
            width: 100.0,
          ),
          GestureDetector(
              onTap: () {
                navKey.currentState.pushNamed(routeQnA);
              },
              child: Text(
                "QnA",
                style: TextStyle(fontSize: 20.0),
              )),
          SizedBox(
            width: 100.0,
          ),
          GestureDetector(
              onTap: () {
                  navKey.currentState.pushNamed(routeJobs);
              },
              child: Text(
                "Jobs",
                style: TextStyle(fontSize: 20.0),
              )),
        ],
      ),
    );
  }
}
