import 'package:flutter/material.dart';

class LoadingScreen {
  static bool isLoading = false;
  static Future<void> show(BuildContext context) async {
    isLoading = true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage('image/Icon/logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            height: 70,
            width: 70,
            child: Stack(
              children: [
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void remove(BuildContext context) {
    if (isLoading) {
      isLoading = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
