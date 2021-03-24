import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';

import 'app.dart';
import 'config/service_configuration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServiceConfiguration.registerServices();
  await findSystemLocale();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'en_NZ';

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          throw snapshot.error!;
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return SkirmishApp();
        }

        return CircularProgressIndicator();
      },
    );
  }
}
