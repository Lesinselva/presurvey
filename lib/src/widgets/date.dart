import 'package:exex/widgets/icon/gradient_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDateWidget extends StatefulWidget {
  const CurrentDateWidget({super.key});

  @override
  _CurrentDateWidgetState createState() => _CurrentDateWidgetState();
}

class _CurrentDateWidgetState extends State<CurrentDateWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GradientIcon(
              icon: Icons.calendar_month_rounded,
              startColor: Colors.blue,
              endColor: Colors.green),
          const SizedBox(width: 8),
          Text(
            formattedDate,
          ),
        ],
      ),
    );
  }
}
