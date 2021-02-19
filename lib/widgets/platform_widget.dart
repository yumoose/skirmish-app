import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isIOS) {
      return buildCupertinoWidget(context);
    }

    return buildMaterialWidget(context);
  }
}
