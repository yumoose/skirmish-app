import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:skirmish/widgets/forms/email_sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Beamer.of(context).beamBack(),
        ),
      ),
      body: Center(child: EmailSignInForm()),
    );
  }
}
