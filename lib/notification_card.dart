import 'package:flutter/material.dart';
import 'package:quickui/quickui.dart';

class NotificationCard extends StatelessWidget {
  final int notificationId;

  const NotificationCard({
    super.key,
    required this.notificationId,
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
        'Notification $notificationId',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
