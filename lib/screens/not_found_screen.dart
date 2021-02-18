import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not found'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Beamer.of(context).beamBack(),
        ),
      ),
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
