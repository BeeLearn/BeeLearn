import 'package:flutter/material.dart';

class ExpandedList extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int, bool) headerBuilder;
  final Widget Function(BuildContext, int) bodyBuilder;

  const ExpandedList({
    Key? key,
    required this.itemCount,
    required this.headerBuilder,
    required this.bodyBuilder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpandedListState();
}

class _ExpandedListState extends State<ExpandedList> {
  late List<bool> expandedItems;

  @override
  void initState() {
    super.initState();
    expandedItems = List.generate(widget.itemCount, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          expandedItems[index] = !isExpanded;
        });
      },
      children: List.generate(widget.itemCount, (index) {
        return ExpansionPanel(
          isExpanded: expandedItems[index],
          canTapOnHeader: true,
          headerBuilder: (context, isExpanded) {
            return widget.headerBuilder(context, index, isExpanded);
          },
          body: widget.bodyBuilder(context, index),
        );
      }),
    );
  }
}
