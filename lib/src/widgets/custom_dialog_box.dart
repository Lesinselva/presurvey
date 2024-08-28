import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String description;
  final String firstButtonLabel;
  final IconData firstButtonIcon;
  final Color? firstButtonIconColor;
  final Color firstButtonColor;
  final Color? firstButtonTextColor;
  final VoidCallback firstButtonAction;
  final String secondButtonLabel;
  final IconData secondButtonIcon;
  final Color? secondButtonIconColor;
  final Color secondButtonColor;
  final Color? secondButtonTextColor;
  final VoidCallback secondButtonAction;

  const CustomDialogBox({
    super.key,
    this.icon,
    required this.title,
    required this.description,
    required this.firstButtonLabel,
    required this.firstButtonIcon,
    required this.firstButtonColor,
    required this.firstButtonAction,
    required this.secondButtonLabel,
    required this.secondButtonIcon,
    required this.secondButtonColor,
    required this.secondButtonAction,
    this.firstButtonTextColor,
    this.secondButtonTextColor,
    this.firstButtonIconColor,
    this.secondButtonIconColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(),
      title: Column(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 38,
              color: iconColor ?? Colors.black,
            ),
          Text(title, style: const TextStyle(fontSize: 22)),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 28),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: firstButtonAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: firstButtonColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        firstButtonIcon,
                        color: firstButtonIconColor ?? Colors.black,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        firstButtonLabel,
                        style: TextStyle(
                          color: firstButtonTextColor ?? Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: secondButtonAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: secondButtonColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        secondButtonIcon,
                        color: secondButtonIconColor ?? Colors.black,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        secondButtonLabel,
                        style: TextStyle(
                          color: secondButtonTextColor ?? Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
