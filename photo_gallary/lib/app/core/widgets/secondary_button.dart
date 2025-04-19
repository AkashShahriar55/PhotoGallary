import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;

  const SecondaryButton({
    required this.child,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onTap,
      child: child,
    );
  }
}
