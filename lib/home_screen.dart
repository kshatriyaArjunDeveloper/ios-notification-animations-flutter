import 'package:flutter/material.dart';
import 'package:quickui/quickui.dart';

import 'notification_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // NOTIFICATION SCROLL VARS
  ScrollController controller = ScrollController();

  /// Height of view above list
  double customUiHeight = 0;

  /// Total list of items in list, includes Custom UI above list
  /// 6 notification + 1 Custom UI
  int listLength = 6;

  // List item height + padding
  final double itemHeight = 100;

  @override
  void initState() {
    super.initState();

    // list length - 1 takes out the Custom UI
    // -1 takes out first visible notification item
    // -0.3 takes out for the second item which is partially visible
    final double totalInvisibleNotifications = listLength - 2.3;

    // Calculate total height of invisible items
    double invisibleItemsTotalHeight = itemHeight * totalInvisibleNotifications;

    // Jump to start from above
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.jumpTo(invisibleItemsTotalHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: const Text('Dynamic Height and Visibility App Bar'),
        ),
        bottomNavigationBar: Container_(
          height: 50,
          color: Colors.white10,
          child: const Center(
            child: Text(
              'Dynamic Height and Visibility Bottom Bar',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            customUiHeight = constraints.maxHeight - itemHeight * (1.3);
            return ListView.builder(
              controller: controller,
              itemCount: listLength,
              reverse: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return _buildListItem(index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildUiAboveList() {
    return Container_(
      height: customUiHeight,
      color: Colors.indigo,
      child: const Center(
        child: Text(
          'Custom Height Indigo Box',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }


  Widget _buildListItem(int index) {
    final bool isFirstItemFromAbove = index == (listLength - 1);

    if (isFirstItemFromAbove) {
      return _buildUiAboveList();
    } else {
      return const NotificationCard();
    }
  }
}
