import 'package:flutter/material.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;

  const PrimaryButton({
    required this.child,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      child: child,
    );
  }
}
