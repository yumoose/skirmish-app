import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localisations.dart';
import 'package:skirmish/config/themes.dart';
import 'package:skirmish/config/locations.dart';

class SkirmishApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.applicationTitle ?? 'Skirmish',
      theme: SkirmishTheme.light,
      darkTheme: SkirmishTheme.dark,
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerRouterDelegate(
        beamLocations: Locations.beamLocations,
        notFoundPage: BeamPage(
          key: ValueKey('not-found'),
          child: Locations.notFoundScreen,
        ),
      ),
      routeInformationParser: BeamerRouteInformationParser(),
    );
  }
}
