import 'package:flutter/material.dart';

class CountryPickerField extends StatefulWidget {
  final TextEditingController controller;
  final Widget icon;
  final void Function(BuildContext context) showCountryPicker;
  final ValueChanged<bool> onCountrySelected;

  const CountryPickerField({
    super.key,
    required this.controller,
    required this.icon,
    required this.showCountryPicker,
    required this.onCountrySelected,
  });

  @override
  CountryPickerFieldState createState() => CountryPickerFieldState();
}

class CountryPickerFieldState extends State<CountryPickerField> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();

    _isSelected = widget.controller.text.isNotEmpty;
  }

  void updateSelection(bool isSelected) {
    setState(() {
      _isSelected = isSelected;
    });
    widget.onCountrySelected(isSelected);
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
            const Text('Country'),
          ],
        ),
        GestureDetector(
          onTap: () {
            widget.showCountryPicker(context);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: _isSelected ? Colors.black : Colors.white,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.controller.text.isEmpty
                      ? 'Select your Country'
                      : widget.controller.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.controller.text.isEmpty
                        ? const Color.fromARGB(255, 199, 197, 197)
                        : Colors.black,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
