import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skirmish/screens/account_screen.dart';
import 'package:skirmish/screens/auth/password_reset_screen.dart';
import 'package:skirmish/screens/auth/sign_in_screen.dart';
import 'package:skirmish/screens/landing_screen.dart';
import 'package:skirmish/screens/leagues/league_screen.dart';
import 'package:skirmish/screens/leagues_screen.dart';
import 'package:skirmish/screens/not_found_screen.dart';

abstract class Locations {
  static final Widget notFoundScreen = NotFoundScreen();
  static final BeamLocation initialLocation = LandingLocation();

  static final List<BeamLocation> beamLocations = [
    LandingLocation(),
    AuthLocation(),
    AccountLocation(),
    LeaguesLocation(),
  ];
}

class LandingLocation extends BeamLocation {
  LandingLocation() : super(pathBlueprint: '/');

  @override
  List<String> get pathBlueprints => ['/'];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) => [
        BeamPage(
          key: ValueKey('landing'),
          child: LandingScreen(),
        ),
      ];
}

class AuthLocation extends BeamLocation {
  AuthLocation({String? pathBlueprint = '/auth'})
      : super(
          pathBlueprint: pathBlueprint,
        );

  @override
  List<String> get pathBlueprints => [
        '/auth/',
        '/auth/password_reset/',
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) => [
        ...LandingLocation().pagesBuilder(context),
        if (pathSegments.contains('auth'))
          BeamPage(
            key: ValueKey('auth'),
            child: SignInScreen(),
          ),
        if (pathSegments.contains('password_reset'))
          BeamPage(
            key: ValueKey('password-reset'),
            child: PasswordResetScreen(),
          ),
      ];
}

class PasswordResetLocation extends AuthLocation {
  PasswordResetLocation() : super(pathBlueprint: '/auth/password_reset');
}

class AccountLocation extends BeamLocation {
  AccountLocation() : super(pathBlueprint: '/account');

  @override
  List<String> get pathBlueprints => ['/account/'];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) => [
        ...LandingLocation().pagesBuilder(context),
        if (pathSegments.contains('account'))
          BeamPage(
            key: ValueKey('account'),
            child: AccountScreen(),
          ),
      ];
}

class LeaguesLocation extends BeamLocation {
  LeaguesLocation() : super(pathBlueprint: '/leagues');
  LeaguesLocation.leagues() : super(pathBlueprint: '/leagues');

  LeaguesLocation.league({
    required String leagueId,
  }) : super(pathBlueprint: '/leagues/$leagueId');

  @override
  List<String> get pathBlueprints => [
        '/leagues/:leagueId',
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) => [
        ...LandingLocation().pagesBuilder(context),
        if (pathSegments.contains('leagues'))
          BeamPage(
            key: ValueKey('leagues'),
            child: LeaguesScreen(),
          ),
        if (pathParameters.containsKey('leagueId'))
          BeamPage(
            key: ValueKey('league'),
            child: LeagueScreen(leagueId: pathParameters['leagueId']!),
          ),
      ];
}
