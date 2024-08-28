// import 'package:flutter/material.dart';
// import 'package:country_picker/country_picker.dart';

// class CustomCountryPicker extends StatelessWidget {
//   final void Function(Country) onSelect;

//   const CustomCountryPicker({super.key, required this.onSelect});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select a Country'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               hintText: 'Search',
//             ),
//             onChanged: (value) {},
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: countries.length,
//               itemBuilder: (context, index) {
//                 final country = countries[index];
//                 return ListTile(
//                   title: Text(country.name),
//                   onTap: () {
//                     onSelect(country);
//                     Navigator.of(context).pop();
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
