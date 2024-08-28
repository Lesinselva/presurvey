import 'package:flutter/material.dart';

class CosContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CosContainer({
    required this.child,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        // boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.grey)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
