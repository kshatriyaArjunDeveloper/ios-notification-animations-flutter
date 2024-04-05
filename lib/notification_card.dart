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
      color: Colors.white,
      borderColor: Colors.black,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'List Item $notificationId\n$text',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
