import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'config/service_configuration.dart';
import 'screens/landing_screen.dart';

void main() {
  ServiceConfiguration.registerServices();

  runApp(MyApp());
}

class LandingLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => ['/'];

  @override
  List<BeamPage> get pages => [
        BeamPage(
          key: ValueKey('landing'),
          child: LandingScreen(),
        ),
      ];
}

class MyApp extends StatelessWidget {
  final BeamLocation initialLocation = LandingLocation();
  final List<BeamLocation> beamLocations = [
    LandingLocation(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerRouterDelegate(
        initialLocation: initialLocation,
        notFoundPage: Scaffold(
          body: Center(
            child: Text('Not found'),
          ),
        ),
      ),
      routeInformationParser: BeamerRouteInformationParser(
        beamLocations: beamLocations,
      ),
    );
  }
}
