import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpandedList extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int, bool) headerBuilder;
  final Widget Function(BuildContext, int) bodyBuilder;
  final SharedPreferences sharedPreferences;
  final String Function(int) generateKey;

  const ExpandedList({
    Key? key,
    required this.generateKey,
    required this.sharedPreferences,
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

    expandedItems = List.generate(widget.itemCount, (index) {
      return widget.sharedPreferences.getBool(widget.generateKey(index)) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        final state = !isExpanded;

        setState(() {
          expandedItems[index] = state;
          widget.sharedPreferences.setBool(widget.generateKey(index), state);
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
