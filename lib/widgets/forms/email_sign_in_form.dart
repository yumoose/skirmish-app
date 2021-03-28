import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/widgets/dialogs/platform_alert_dialog.dart';

import '../../services/auth_service.dart';
import '../../validators/auth_validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with AuthValidators {
  final bool registration;

  EmailSignInForm({Key? key, this.registration = false}) : super(key: key);

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final AuthService? _authService = GetIt.instance<AuthService>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userTagController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _userTagFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _userName => _userNameController.text;
  String get _userTag => _userTagController.text;
  String get _password => _passwordController.text;

  bool _submitted = false;
  bool _isLoading = false;

  EmailSignInFormType? _formType;

  @override
  void initState() {
    super.initState();

    _formType = widget.registration
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Key('email_sign_in_form'),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(16.0),
        child: AutofillGroup(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _userTagController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _userNameFocusNode.dispose();
    _userTagFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  RichText _switchFormRichText() {
    final leadingText = _formType == EmailSignInFormType.signIn
        ? 'Need an account?'
        : 'Have an account?';
    final actionText =
        _formType == EmailSignInFormType.signIn ? 'Register' : 'Sign in';

    final linkStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Theme.of(context).primaryColor);

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: <TextSpan>[
          TextSpan(text: leadingText),
          TextSpan(text: '  '),
          TextSpan(
            text: actionText,
            style: linkStyle,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildren() {
    final submitText =
        _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';

    final showPasswordReset = _formType == EmailSignInFormType.signIn;
    final submitEnabled = !_isLoading && _email.isNotEmpty;

    return [
      _buildEmailTextField(),
      if (_formType == EmailSignInFormType.register) ...[
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Container(
                child: _buildTagTextField(),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Container(
                child: _buildNameTextField(),
              ),
            ),
          ],
        ),
      ],
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 24.0),
      SizedBox(
        height: 50.0,
        child: ElevatedButton(
          key: Key('auth_submit'),
          onPressed: submitEnabled ? _submit : null,
          child: _isLoading
              ? CircularProgressIndicator()
              : Text(
                  submitText,
                  style: TextStyle(fontSize: 20.0),
                ),
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      TextButton(
        key: Key('auth_form_switch'),
        onPressed: _isLoading ? null : _toggleFormType,
        child: _switchFormRichText(),
      ),
      if (showPasswordReset)
        TextButton(
          key: Key('password_reset_button'),
          onPressed: _isLoading
              ? null
              : () async => Beamer.of(context).currentLocation.update(
                    (state) => state.copyWith(
                      pathBlueprintSegments: ['auth', 'password_reset'],
                    ),
                  ),
          child: Text(
            'Forgot your password?',
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
      widget.emailValidator
          .isValid(_email)
          .fold((error) => emailError = error, (_) {});
    }

    return TextField(
      key: Key('email_field'),
      controller: _emailController,
      autofillHints: _isLoading ? null : [AutofillHints.email],
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
      onEditingComplete: _emailEditingComplete,
      onChanged: (_) => _updateState(),
    );
  }

  void _emailEditingComplete() {
    widget.emailValidator.isValid(_email).fold(
          (_) => FocusScope.of(context).requestFocus(_emailFocusNode),
          (_) => FocusScope.of(context).requestFocus(
            _formType == EmailSignInFormType.signIn
                ? _passwordFocusNode
                : _userNameFocusNode,
          ),
        );
  }

  TextField _buildNameTextField() {
    String? nameError;
    if (_submitted) {
      widget.nameValidator
          .isValid(_email)
          .fold((error) => nameError = error, (_) {});
    }

    return TextField(
      key: Key('name_field'),
      controller: _userNameController,
      autofillHints: _isLoading ? null : [AutofillHints.givenName],
      focusNode: _userNameFocusNode,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Alex Wins',
        enabled: !_isLoading,
        errorText: nameError,
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      onEditingComplete: _givenNameEditingComplete,
      onChanged: (_) => _updateState(),
    );
  }

  void _givenNameEditingComplete() {
    widget.nameValidator.isValid(_userName).fold(
          (_) => FocusScope.of(context).requestFocus(_userNameFocusNode),
          (_) => FocusScope.of(context).requestFocus(_userTagFocusNode),
        );
  }

  TextField _buildTagTextField() {
    String? userTagError;
    if (_submitted) {
      widget.nameValidator
          .isValid(_userTag)
          .fold((error) => userTagError = error, (_) {});
    }

    return TextField(
      key: Key('player_tag_field'),
      controller: _userTagController,
      autofillHints: _isLoading ? null : [AutofillHints.familyName],
      focusNode: _userTagFocusNode,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Player Tag',
        hintText: 'Mr.l33t',
        enabled: !_isLoading,
        errorText: userTagError,
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      onEditingComplete: _userTagEditingComplete,
      onChanged: (_) => _updateState(),
    );
  }

  void _userTagEditingComplete() {
    widget.nameValidator.isValid(_userTag).fold(
          (_) => FocusScope.of(context).requestFocus(_userTagFocusNode),
          (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
        );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      key: Key('password_field'),
      controller: _passwordController,
      autofillHints: _isLoading
          ? null
          : _formType == EmailSignInFormType.signIn
              ? [AutofillHints.password]
              : [AutofillHints.newPassword],
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        enabled: !_isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _submit(),
      onChanged: (_) => _updateState(),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
      if (_formType == EmailSignInFormType.signIn) {
        await _authService!.signInWithEmailAndPassword(
          _email,
          _password,
        );

        Beamer.of(context).beamBack();
      } else if (_formType == EmailSignInFormType.register) {
        final auth = _authService!;

        await auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
          name: _userName,
          tag: _userTag,
        );

        _toggleFormType();
      }
    } catch (e) {
      final errorText = _formType == EmailSignInFormType.signIn
          ? 'Sign in failed'
          : 'Registration failed';

      await PlatformAlertDialog(
        key: Key('auth_action_failed_dialog'),
        title: errorText,
        content: e.toString(),
        defaultActionText: 'OK',
      ).show(context);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        _passwordController.clear();
      }
    }
  }

  void _toggleFormType() {
    if (mounted) {
      setState(() {
        _submitted = false;
        _formType = _formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register
            : EmailSignInFormType.signIn;
        _emailFocusNode.requestFocus();
      });
    }
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }
}
