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
      height: 90,
      allPadding: 12,
      horizontalMargin: 10,
      bottomMargin: 10,
      color: Colors.teal,
      borderColor: Colors.white,
      allCornerRadius: 20,
      width: MediaQuery.of(context).size.width - 20,
      child: Text(
        'List Item $notificationId\n$text',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
