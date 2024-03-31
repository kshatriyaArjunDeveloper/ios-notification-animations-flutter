import 'package:flutter/material.dart';
import 'package:quickui/quickui.dart';

import 'notification_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return _buildListItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    final bool isFirstItem = index == 0;

    if (isFirstItem) {
      return _buildUiAboveList();
    } else {
      return _buildItemContent(
        index,
      );
    }
  }

  Widget _buildUiAboveList() {
    return Container_(
      height: 600,
      color: Colors.indigo,
      child: const Center(
        child: Text(
          'Custom UI, List Item 0',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildItemContent(int index) {
    return NotificationCard(
      notificationId: index,
    );
  }
}
