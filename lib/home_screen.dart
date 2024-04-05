import 'package:flutter/material.dart';
import 'package:quickui/quickui.dart';

import 'notification_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // UI VARS
  late final double screenHeight;
  double listItemsScrolled = 0;

  // NOTIFICATION SCROLL VARS
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add listener to the controller
    controller.addListener(() {
      setState(() {
        listItemsScrolled =
            double.parse((controller.offset / 100).toStringAsFixed(2));
        print('Controller offset: ${controller.offset}');
        print('Items Scrolled: $listItemsScrolled');
      });
    });
  }

  @override
  void didChangeDependencies() {
    try {
      screenHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    } catch (e) {
      print('Error: $e');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          controller: controller,
          itemCount: 20,
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
      height: screenHeight,
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
      text: 'Scroll Info: $listItemsScrolled',
    );
  }
}
