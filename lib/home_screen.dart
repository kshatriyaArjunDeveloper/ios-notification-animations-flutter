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
    final bool hasItemScrolledFully = index <= (listItemsScrolled);
    // Show full item
    if (hasItemScrolledFully) {
      return NotificationCard(
        notificationId: index,
        text: 'Scroll Info: $listItemsScrolled\nItem Scrolled',
      );
    } else {
      // Hide item
      final bool isGapMoreThenOneItem = (index - listItemsScrolled) > 1;
      if (isGapMoreThenOneItem) {
        return const SizedBox(
          height: 100,
        );
      } else {
        // Show partial item
        double itemScrolled = double.parse(
            ((index - 1 - listItemsScrolled).abs()).toStringAsFixed(2));
        double scale = scaleFactor(itemScrolled);

        return SizedBox(
          height: 100,
          child: UnconstrainedBox(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: heightFactor(itemScrolled) * 100,
              child: FittedBox(
                fit: BoxFit.none,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacityFactor(itemScrolled),
                  child: Transform(
                    transform: Matrix4.identity()..scale(scale, scale),
                    alignment: Alignment.bottomCenter,
                    child: NotificationCard(
                      notificationId: index,
                      text:
                          'Scroll Info: $listItemsScrolled\nItem Scrolled: $itemScrolled',
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  // FUNCTIONS TO MAKE NOTIFICATION ITEM ANIMATE

  double opacityFactor(
    double partiallyScrolled,
  ) {
    double opacity = 1;
    if (partiallyScrolled <= 0.3) {
      opacity = 0.5;
    } else if (partiallyScrolled < 1) {
      opacity = 0.5 + 0.5 * ((partiallyScrolled - 0.3) / 0.7);
    } else {
      return 1;
    }
    return opacity;
  }

  double scaleFactor(
    double partiallyScrolled,
  ) {
    double scale = 0.8;
    if (partiallyScrolled <= 0.3) {
      scale = 0.8;
    } else if (partiallyScrolled < 1) {
      scale = 0.8 + 0.2 * ((partiallyScrolled - 0.3) / 0.7);
    } else {
      return 1;
    }
    return scale;
  }

  double heightFactor(double partiallyScrolled) {
    double scale = 0;
    if (partiallyScrolled <= 0.3) {
      scale = 0;
    } else if (partiallyScrolled < 1) {
      scale = 0.3 + 0.7 * ((partiallyScrolled - 0.3) / 0.7);
    } else {
      return 1;
    }
    return scale;
  }
}
