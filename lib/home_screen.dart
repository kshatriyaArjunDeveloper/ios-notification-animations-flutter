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

  /// Total list items that are scrolled
  double listItemsScrolled = 1.35;

  /// Height of view above list
  double customUiHeight = 0;

  /// Total list of items in list, includes Custom UI above list
  /// 6 notification + 1 Custom UI
  int listLength = 6 + 1;

  // List item height + padding
  final double itemHeight = 80 + 12;
  final double ratioScrolledExtra = 0.35;

  @override
  void initState() {
    super.initState();

    double invisibleItemsTotalHeight =
        itemHeight * (listLength - 1) - itemHeight * 0.6;
    _addNotificationListListener();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            customUiHeight = constraints.maxHeight;
            return ListView.builder(
              controller: controller,
              itemCount: listLength,
              padding: EdgeInsets.only(
                bottom: itemHeight * 0.4,
              ),
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
    final double height =
        customUiHeight - (itemHeight * (1 + ratioScrolledExtra));
    return Container_(
      height: height,
      color: Colors.indigo,
      child: const Center(
        child: Text(
          'Custom UI above list',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // FUNCTIONS TO HANDLE NOTIFICATION LIST SCROLL

  void _addNotificationListListener() {
    controller.addListener(() {
      setState(() {
        listItemsScrolled = (controller.offset / itemHeight) + 1.35;
        print('Controller offset: ${controller.offset}');
        print('Items Scrolled: $listItemsScrolled');
      });
    });
  }

  // FUNCTIONS TO BUILD NOTIFICATION ITEM

  Widget _buildListItem(int index) {
    final bool isFirstItem = index == 0;

    if (isFirstItem) {
      return _buildUiAboveList();
    } else {
      return _buildAnimatingNotificationItem(
        index,
      );
    }
  }

  Widget _buildAnimatingNotificationItem(
    int index,
  ) {
    final bool isFirstItem = index == 1;
    late final double scale;
    late final double opacity;
    late final double height;

    final bool hasItemScrolledFully = index <= (listItemsScrolled - 1);
    if (hasItemScrolledFully) {
      scale = 1;
      opacity = 1;
      height = itemHeight;
    } else {
      final bool isGapMoreThenOneItem = (index - listItemsScrolled) > 1;
      if (isGapMoreThenOneItem) {
        scale = 0;
        opacity = 0;
        height = 0;
      } else {
        double partiallyScrolled = (index - 1 - listItemsScrolled).abs();

        scale = isFirstItem ? 1.0 : scaleFactor(partiallyScrolled);
        opacity = isFirstItem ? 1.0 : opacityFactor(partiallyScrolled);
        height = isFirstItem
            ? itemHeight
            : heightFactor(partiallyScrolled) * itemHeight;
      }
    }

    return SizedBox(
      height: itemHeight,
      child: UnconstrainedBox(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: height,
          child: FittedBox(
            fit: BoxFit.none,
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 1,
              child: Transform(
                transform: Matrix4.identity()..scale(scale, scale),
                alignment: Alignment.bottomCenter,
                child: Padding_(
                  bottomPadding: 12,
                  child: buildItemContent(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemContent(int index) {
    return NotificationCard(
      notificationId: index,
    );
  }

  // FUNCTIONS TO MAKE NOTIFICATION ITEM ANIMATE

  double scaleFactor(
    double partiallyScrolled,
  ) {
    double scale = 0;
    if (partiallyScrolled < 0.7) {
      scale = 0.9;
    } else if (partiallyScrolled < 1.4) {
      scale = 0.9 + 0.1 * ((partiallyScrolled - 0.7) / 0.7);
    } else {
      return 1;
    }
    return scale;
  }

  double heightFactor(double partiallyScrolled) {
    double scale = 0;
    if (partiallyScrolled <= 0.34) {
      scale = 0.1;
    } else if (partiallyScrolled < 0.9) {
      scale = 0.1 + 0.7 * ((partiallyScrolled - 0.34) / 0.56);
    } else if (partiallyScrolled < 1.4) {
      scale = 0.8 + 0.2 * ((partiallyScrolled - 0.9) / 0.5);
    } else {
      return 1;
    }
    return scale;
  }

  double opacityFactor(
    double partiallyScrolled,
  ) {
    double opacity = 1;
    if (partiallyScrolled <= 0.34) {
      opacity = 0;
    } else if (partiallyScrolled < 0.9) {
      opacity = 0.2 + 0.3 * ((partiallyScrolled - 0.34) / 0.56);
    } else if (partiallyScrolled < 1.4) {
      opacity = 0.5 + 0.5 * ((partiallyScrolled - 0.9) / 0.5);
    } else {
      return 1;
    }
    return opacity;
  }
}
