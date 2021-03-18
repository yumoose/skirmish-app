import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/service_configuration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ServiceConfiguration.registerServices();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
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
