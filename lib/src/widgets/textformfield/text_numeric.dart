import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Widget icon;
  final int maxLength;

  const NumericInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.maxLength,
  });

  @override
  _NumericInputFieldState createState() => _NumericInputFieldState();
}

class _NumericInputFieldState extends State<NumericInputField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            widget.icon,
            const SizedBox(width: 8),
            Text(widget.label),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _focusNode.hasFocus ? Colors.black : Colors.white,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              maxLength: widget.maxLength,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: 'Enter your ${widget.label}',
                hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 199, 197, 197),
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
              onTap: () {
                // Handle onTap if needed
              },
            ),
          ),
        ),
      ],
    );
  }
}
