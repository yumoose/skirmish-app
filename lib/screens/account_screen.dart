import 'package:flutter/material.dart';
import 'package:skirmish/models/player.dart';
import 'package:skirmish/services/auth_service.dart';
import 'package:skirmish/services/player_service.dart';
import 'package:skirmish/utils/dependency_injection.dart';
import 'package:skirmish/widgets/dialogs/platform_alert_dialog.dart';

class AccountScreen extends StatelessWidget {
  final _authService = injected<AuthService>();
  final _playerService = injected<PlayerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: StreamBuilder<Player?>(
        stream: _playerService.playerStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            final player = snapshot.data!;

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
            Text('Signed in as'),
            SizedBox(height: 24),
            Text(
              player.tag,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              player.name,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 48),
            TextButton(
              key: Key('auth_log_out'),
              style: TextButton.styleFrom(primary: Colors.redAccent),
              onPressed: () async => await _showLogoutDialog(
                context,
              ),
              child: Text(
                'Log out',
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            PlatformAlertDialogAction(
              key: Key('confirm_log_out'),
              danger: true,
              onPressed: () async {
                final navigator = Navigator.of(context);

                navigator.pop();
                await _authService.signOut();

                if (navigator.canPop()) {
                  navigator.pop();
                }
              },
              child: Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}
