import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:skirmish/config/themes.dart';

class Scenario {
  final Widget widget;
  final String name;
  final Future<void> Function(Key) onCreate;

  Scenario({
    required this.widget,
    required this.name,
    required this.onCreate,
  });
}

abstract class GoldensHelper {
  static Future matchesWidget(
    WidgetTester tester,
    Widget widget,
    String widgetName,
  ) async {
    final builder = GoldenBuilder.column(
      bgColor: Colors.white,
    )..addScenario('Default', widget);

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(
        theme: SkirmishTheme.light,
      ),
    );

    await screenMatchesGolden(tester, widgetName);
  }

  static Future matchesScreen(
    WidgetTester tester,
    String widgetName,
    List<Scenario> scenarios,
  ) async {
    await Future.forEach(scenarios, (Scenario scenario) async {
      final builder = DeviceBuilder(bgColor: Colors.black)
        ..overrideDevicesForAllScenarios(devices: [
          Device.phone,
          Device.iphone11,
          Device.tabletPortrait,
          Device.tabletLandscape,
        ]);

      builder.addScenario(
        widget: scenario.widget,
        name: scenario.name,
        onCreate: scenario.onCreate,
      );

      await tester.pumpDeviceBuilder(
        builder,
        wrapper: materialAppWrapper(
          theme: SkirmishTheme.light,
        ),
      );

      await screenMatchesGolden(
        tester,
        '$widgetName ${scenario.name}',
      );
    });
  }
}
