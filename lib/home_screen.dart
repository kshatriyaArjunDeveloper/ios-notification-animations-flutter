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
  double listItemsScrolled = 0;

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

    // list length - 1 takes out the Custom UI
    // -1 takes out first visible notification item
    // ratioScrolledExtra takes out the scrolled item
    // 0.4 for last item animation
    final double totalInvisibleNotifications =
        listLength - 1 - 1 - ratioScrolledExtra + 0.4;

    // Calculate total height of invisible items
    // itemHeight * 0.4 is extra padding for completing last item animation
    // itemHeight * (listLength - 1) is total height of all items except first
    double invisibleItemsTotalHeight = itemHeight * totalInvisibleNotifications;

    // Jump to start from above
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.jumpTo(invisibleItemsTotalHeight);
    });

    _addNotificationListListener(
      invisibleItemsTotalHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: _buildAppBar(),
        bottomNavigationBar: _buildBottomNav(),
        body: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            customUiHeight = constraints.maxHeight;
            return ListView.builder(
              controller: controller,
              itemCount: listLength,
              reverse: true,
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
        customUiHeight - (itemHeight * (1 + ratioScrolledExtra)) - 10;
    return Container_(
      height: height,
      bottomMargin: 10,
      color: Colors.indigo,
      child: const Center(
        child: Text(
          'Custom UI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
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

  // FUNCTIONS TO HANDLE NOTIFICATION LIST SCROLL

  void _addNotificationListListener(
    double invisibleItemsTotalHeight,
  ) {
    double scrolledDownwards = 0;
    controller.addListener(() {
      setState(() {
        double totalScrolled = (invisibleItemsTotalHeight - controller.offset);
        scrolledDownwards = totalScrolled > 0 ? totalScrolled : 0;
        // Calculating scroll ratio after initial setup
        final double afterInitialScroll = scrolledDownwards / itemHeight;
        // +1 because of first list item and + ratioScrolledExtra for secondList
        listItemsScrolled = afterInitialScroll + 1 + ratioScrolledExtra;
        // Rounding off to 2 decimal places
        listItemsScrolled = double.parse(listItemsScrolled.toStringAsFixed(2));
        print('Items Scrolled: $listItemsScrolled');
      });
    });
  }

  // FUNCTIONS TO BUILD NOTIFICATION ITEM

  Widget _buildListItem(int index) {
    final bool isFirstItemFromAbove = index == (listLength - 1);

    if (isFirstItemFromAbove) {
      return _buildUiAboveList();
    } else {
      return _buildAnimatingNotificationItem(
        index,
      );
    }
  }

  Widget _buildAnimatingNotificationItem(int index) {
    final bool isFirstItem = index == (listLength - 2);
    int reverseIndex = listLength - index - 1;
    late final double scale;
    late final double opacity;
    late final double height;

    late final String text;

    final bool hasItemScrolledFully = reverseIndex <= (listItemsScrolled - 1);
    if (hasItemScrolledFully) {
      scale = 1;
      opacity = 1;
      height = itemHeight;
      text = '';
    } else {
      final bool isGapMoreThenOneItem = (reverseIndex - listItemsScrolled) > 1;
      if (isGapMoreThenOneItem) {
        scale = 0;
        opacity = 0;
        height = 0;
        text = '';
      } else {
        double partiallyScrolled = (reverseIndex - 1 - listItemsScrolled).abs();

        scale = isFirstItem ? 1.0 : scaleFactor(partiallyScrolled);
        opacity = isFirstItem ? 1.0 : opacityFactor(partiallyScrolled);
        height = isFirstItem
            ? itemHeight
            : heightFactor(partiallyScrolled) * itemHeight;
        text = '';
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
              opacity: opacity,
              child: Transform(
                transform: Matrix4.identity()..scale(scale, scale),
                alignment: Alignment.bottomCenter,
                child: Padding_(
                  bottomPadding: 12,
                  child: buildItemContent(
                    reverseIndex,
                    text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemContent(
    int index,
    String text,
  ) {
    return NotificationCard(
      notificationId: index,
      text: '',
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
