import 'package:flutter/material.dart';
import 'package:quickui/quickui.dart';

class NotificationCard extends StatelessWidget {
  final int notificationId;
  final String text;

  const NotificationCard({
    super.key,
    required this.notificationId,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container_(
      height: 100,
      allPadding: 10,
      color: Colors.amberAccent,
      borderColor: Colors.black,
      width: MediaQuery.of(context).size.width,
      child: Text(
        'List Item $notificationId\n$text',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
