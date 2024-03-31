import 'package:flutter/material.dart';
import 'package:quickui/quickui.dart';

class NotificationCard extends StatelessWidget {

  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container_(
      height: 100,
      borderColor: Colors.black,
      color: Colors.white,
      width: MediaQuery.of(context).size.width - 40,
      child: const Center(
        child: Text(
          'List Item',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
