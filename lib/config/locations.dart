import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:skirmish/screens/landing_screen.dart';

abstract class Locations {
  static final BeamLocation initialLocation = LandingLocation();
  static final List<BeamLocation> beamLocations = [
    LandingLocation(),
  ];
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
