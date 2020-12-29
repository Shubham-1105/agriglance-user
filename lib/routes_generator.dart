import 'package:flutter/material.dart';
import 'routes.dart';
import 'Screens/Test/test_home.dart';
import 'Screens/Materials/materials_home.dart';
import 'Screens/Qna/qna_home.dart';
import 'Screens/Jobs/jobs_home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeTests:
        return MaterialPageRoute(builder: (_) => TestHome());
        break;
      case routeQnA:
        return MaterialPageRoute(builder: (_) => QnaHome());
        break;

      case routeMaterials:
        return MaterialPageRoute(builder: (_) => MaterialsHome());
        break;
      case routeJobs:
        return MaterialPageRoute(builder: (_) => JobsHome());
        break;
    }
  }
}