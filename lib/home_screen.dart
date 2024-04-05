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
  final double itemHeight = 100;

  /// Height of view above list
  double customUiHeight = 0;

  // NOTIFICATION SCROLL VARS
  ScrollController controller = ScrollController();
  double listItemsScrolled = 0;
  final listLength = 20;

  @override
  void initState() {
    super.initState();

    // list length - 1 takes out the Custom UI
    // ratioScrolledExtra takes out the scrolled item
    final double totalInvisibleNotifications = listLength - 1;

    // Calculate total height of invisible items
    // itemHeight * (listLength - 1) is total height of all items except first
    double invisibleItemsTotalHeight = itemHeight * totalInvisibleNotifications;

    // Jump to start from above
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.jumpTo(invisibleItemsTotalHeight);
    });

    // Add listener to the controller
    double scrolledDownwards = 0;

    controller.addListener(() {
      setState(() {
        double totalScrolled = (invisibleItemsTotalHeight - controller.offset);
        scrolledDownwards = totalScrolled > 0 ? totalScrolled : 0;

        // Calculating scroll ratio after initial setup
        final double afterInitialScroll = scrolledDownwards / itemHeight;
        listItemsScrolled = afterInitialScroll;

        // Rounding off to 2 decimal places
        listItemsScrolled = double.parse(listItemsScrolled.toStringAsFixed(2));

        print('Controller offset: ${controller.offset}');
        print('Items Scrolled: $listItemsScrolled');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        bottomNavigationBar: _buildBottomNav(),
        body: LayoutBuilder(builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          customUiHeight = constraints.maxHeight;
          return ListView.builder(
            controller: controller,
            padding: EdgeInsets.zero,
            reverse: true,
            itemCount: listLength,
            itemBuilder: (context, index) {
              return _buildListItem(index);
            },
          );
        }),
      ),
    );
  }

  Container_ _buildBottomNav() {
    return Container_(
      height: 50,
      color: Colors.lightBlue,
      child: const Center(
        child: Text(
          'Bottom Nav',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Notification List'),
    );
  }

  Widget _buildListItem(int index) {
    final bool isFirstItemFromAbove = index == (listLength - 1);

    if (isFirstItemFromAbove) {
      return _buildUiAboveList();
    } else {
      return _buildItemContent(
        index,
      );
    }
  }

  Widget _buildUiAboveList() {
    return Container_(
      height: customUiHeight - 10,
      bottomMargin: 10,
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
    int reverseIndex = listLength - index - 1;

    final bool hasItemScrolledFully = reverseIndex <= (listItemsScrolled);
    // Show full item
    if (hasItemScrolledFully) {
      return NotificationCard(
        notificationId: reverseIndex,
        text: 'Scroll Info: $listItemsScrolled\nItem Scrolled',
      );
    } else {
      // Hide item
      final bool isGapMoreThenOneItem = (reverseIndex - listItemsScrolled) > 1;
      if (isGapMoreThenOneItem) {
        return SizedBox(
          height: itemHeight,
        );
      } else {
        // Show partial item
        double itemScrolled = double.parse(
            ((reverseIndex - 1 - listItemsScrolled).abs()).toStringAsFixed(2));
        double scale = scaleFactor(itemScrolled);

        return SizedBox(
          height: itemHeight,
          child: UnconstrainedBox(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: heightFactor(itemScrolled) * itemHeight,
              child: FittedBox(
                fit: BoxFit.none,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacityFactor(itemScrolled),
                  child: Transform(
                    transform: Matrix4.identity()..scale(scale, scale),
                    alignment: Alignment.bottomCenter,
                    child: NotificationCard(
                      notificationId: reverseIndex,
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
