import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/services/auth_service.dart';

import '../mocks/services/mock_auth_service.dart';

class WidgetLocation extends BeamLocation {
  final Widget widget;

  WidgetLocation(this.widget);

  @override
  List<BeamPage> pagesBuilder(BuildContext context) => [
        BeamPage(
          key: ValueKey('widget'),
          child: widget,
        ),
      ];

  @override
  List<String> get pathBlueprints => ['/'];
}

// Used to wrap a widget in a material app with some common configuration for
// navigation to test widgets in an application-like environment
abstract class AppUnderTestHelper {
  static Future prepare() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final _getIt = GetIt.instance;
    _getIt.allowReassignment = true;

    final mockAuthService = MockAuthService();
    _getIt.registerLazySingleton<AuthService>(() => mockAuthService);
  }
}
