import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skirmish/widgets/platform_widget.dart';
import 'package:universal_platform/universal_platform.dart';

class PlatformAlertDialog extends PlatformWidget {
  @override
  final Key key;

  PlatformAlertDialog({
    this.key,
    @required this.title,
    @required this.content,
    this.defaultActionText = 'OK',
    this.defaultActionColor,
    this.cancelActionText,
    this.customActions,
    this.isLoading = false,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null || customActions.isNotEmpty);

  final String title;
  final String content;
  final String defaultActionText;
  final Color defaultActionColor;
  final String cancelActionText;
  final List<PlatformAlertDialogAction> customActions;
  final bool isLoading;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: isLoading ? CircularProgressIndicator() : Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: isLoading ? CircularProgressIndicator() : Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    if (customActions != null) return customActions;

    final actions = <Widget>[];

    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          danger: true,
          child: Text(cancelActionText),
        ),
      );
    }

    actions.add(PlatformAlertDialogAction(
      onPressed: () => Navigator.of(context).pop(true),
      child: Text(
        defaultActionText,
        style: TextStyle(color: defaultActionColor),
      ),
    ));

    return actions;
  }

  Future<bool> show(BuildContext context) async {
    return UniversalPlatform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(context: context, builder: (context) => this);
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({
    this.key,
    this.child,
    this.onPressed,
    this.danger = false,
  });

  @override
  final Key key;
  final Widget child;
  final VoidCallback onPressed;
  final bool danger;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: danger ? TextButton.styleFrom(primary: Colors.redAccent) : null,
      child: child,
    );
  }
}
