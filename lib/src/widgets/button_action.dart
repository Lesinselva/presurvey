import 'package:flutter/material.dart';

class ResizableButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? defaultWidth;
  final double? defaultHeight;
  final double? pressedWidth;
  final double? pressedHeight;
  final bool enabled;
  final Color? color;

  const ResizableButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.defaultWidth,
    this.defaultHeight,
    this.pressedWidth,
    this.pressedHeight,
    this.enabled = true,
    this.color,
  });

  @override
  _ResizableButtonState createState() => _ResizableButtonState();
}

class _ResizableButtonState extends State<ResizableButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) {
          setState(() {
            _isPressed = true;
          });
        }
      },
      onTapUp: (_) {
        if (widget.enabled) {
          setState(() {
            _isPressed = false;
          });
          widget.onPressed();
        }
      },
      onTapCancel: () {
        if (widget.enabled) {
          setState(() {
            _isPressed = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: _isPressed ? widget.pressedWidth : widget.defaultWidth,
        height: _isPressed ? widget.pressedHeight : widget.defaultHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: widget.enabled && _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
          color: widget.enabled
              ? widget.color ?? Colors.black
              : const Color.fromARGB(255, 219, 219, 219),
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
