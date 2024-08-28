import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:presurveylist/src/widgets/button_action.dart';

class NumericInputFieldWithIcon extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Widget icon;
  final IconData icons;

  const NumericInputFieldWithIcon({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.icons,
  });

  @override
  _NumericInputFieldWithIconState createState() =>
      _NumericInputFieldWithIconState();
}

class _NumericInputFieldWithIconState extends State<NumericInputFieldWithIcon> {
  late final FocusNode _focusNode;
  Color containerColor = Colors.black;

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
        Row(
          children: [
            Expanded(
              child: Container(
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
                    cursorColor: Colors.black,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter ${widget.label}',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 199, 197, 197),
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${widget.label} is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            ResizableButton(
              defaultHeight: 50,
              defaultWidth: 50,
              pressedHeight: 52,
              pressedWidth: 52,
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: containerColor,
                ),
                child: Icon(
                  widget.icons,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
