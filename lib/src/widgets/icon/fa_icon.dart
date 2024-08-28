import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GradientFaIcon extends StatelessWidget {
  final IconData iconData;
  final double size;

  const GradientFaIcon({super.key, required this.iconData, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.green
        ], // Replace with your gradient colors
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: FaIcon(
        iconData,
        size: size,
        color:
            Colors.white, // The icon color will be overridden by the gradient
      ),
    );
  }
}
