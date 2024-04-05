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
      height: 80,
      color: Colors.white,
      allCornerRadius: 16,
      allPadding: 16,
      width: MediaQuery.of(context).size.width - 40,
      child: Text(
        'List Item $notificationId\n$text',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
