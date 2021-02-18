import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'config/locations.dart';

class SkirmishApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerRouterDelegate(
        initialLocation: Locations.initialLocation,
        notFoundPage: Locations.notFoundScreen,
      ),
      routeInformationParser: BeamerRouteInformationParser(
        beamLocations: Locations.beamLocations,
      ),
    );
  }
}
