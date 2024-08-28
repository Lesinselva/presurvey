import 'package:flutter/material.dart';

class FarmerDetailCard extends StatefulWidget {
  final Map<String, String> farmerDetails;

  const FarmerDetailCard({super.key, required this.farmerDetails});

  @override
  _FarmerDetailCardState createState() => _FarmerDetailCardState();
}

class _FarmerDetailCardState extends State<FarmerDetailCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final details = widget.farmerDetails;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${details['First Name']} ${details['Second Name']}',
            ),
            Text(
              'Mobile Number: ${details['Mobile Number']}',
            ),
            if (_isExpanded) ...[
              Text('State: ${details['State']}'),
              Text('Pincode: ${details['Pincode']}'),
              Text('Country: ${details['Country']}'),
              if (details.containsKey('Village'))
                Text('Village: ${details['Village']}'),
              if (details.containsKey('District'))
                Text('District: ${details['District']}'),
            ],
          ],
        ),
      ),
    );
  }
}
