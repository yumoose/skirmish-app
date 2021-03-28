import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/validators/auth_validators.dart';
import 'package:skirmish/widgets/dialogs/platform_alert_dialog.dart';

import '../../services/auth_service.dart';

class PasswordResetForm extends StatefulWidget with AuthValidators {
  @override
  _PasswordResetFormState createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final AuthService? _authService = GetIt.instance<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        key: Key('password_reset_form'),
        width: 600,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(),
        ),
      ),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  String get _email => _emailController.text;

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  List<Widget> _buildChildren() {
    String? emailError;
    if (_submitted) {
      widget.emailValidator
          .isValid(_email)
          .fold((error) => emailError = error, (_) {});
    }

    final submitEnabled = !_isLoading && emailError != null;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 24.0,
      ),
      ElevatedButton(
        onPressed: submitEnabled ? _submit : null,
        child:
            _isLoading ? CircularProgressIndicator() : Text('Reset password'),
      ),
      SizedBox(
        height: 16.0,
      ),
      TextButton(
        onPressed: _isLoading
            ? null
            : () => Beamer.of(context).currentLocation.update(
                  (state) => state.copyWith(
                    pathBlueprintSegments: ['/auth'],
                  ),
                ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ];
  }

  TextField _buildEmailTextField() {
    String? emailError;
    if (_submitted) {
      widget.nameValidator
          .isValid(_email)
          .fold((error) => emailError = error, (_) {});
    }

    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'your@email.com',
        enabled: !_isLoading,
        errorText: emailError,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _submit,
      onChanged: (email) => _updateState(),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
      await _authService!.resetPassword(email: _email);

      await PlatformAlertDialog(
        title: 'Password Reset',
        content:
            'Check your email for instructions to complete resetting your password',
        defaultActionText: 'OK',
      ).show(context);

      Beamer.of(context).beamBack();
    } on PlatformException catch (e) {
      await PlatformAlertDialog(
        title: 'Password reset failed',
        content: e.message!,
        defaultActionText: 'OK',
      ).show(context);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateState() {
    setState(() {});
  }
}
