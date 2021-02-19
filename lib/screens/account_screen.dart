import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/models/player.dart';
import 'package:skirmish/services/auth_service.dart';
import 'package:skirmish/widgets/dialogs/platform_alert_dialog.dart';

class AccountScreen extends StatelessWidget {
  final _authService = GetIt.instance<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Beamer.of(context).beamBack(),
        ),
      ),
      body: StreamBuilder(
        stream: _authService.currentPlayer,
        builder: (BuildContext context, AsyncSnapshot<Player> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            final player = snapshot.data;

            return Center(
              child: accountActions(context, player),
            );
          } else {
            return Text('Failed to load account details');
          }
        },
      ),
    );
  }

  Widget accountActions(BuildContext context, Player player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              player.name ?? 'Name not set',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 48),
            TextButton(
              key: Key('auth_log_out'),
              child: Text(
                'Log out',
              ),
              style: TextButton.styleFrom(primary: Colors.redAccent),
              onPressed: () async => await _showLogoutDialog(
                context,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
          title: 'Log out',
          content: 'Are you sure you want to log out?',
          customActions: [
            PlatformAlertDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            PlatformAlertDialogAction(
              key: Key('confirm_log_out'),
              child: Text('Log out'),
              danger: true,
              onPressed: () async {
                final navigator = Navigator.of(context);

                navigator.pop();
                await _authService.signOut();

                if (navigator.canPop()) {
                  navigator.pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
