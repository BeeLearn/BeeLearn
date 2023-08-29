import 'package:flutter/material.dart';

import 'buttons.dart';

class QuestionSingleChoice<T> extends StatefulWidget {
  final List<T> items;
  final String Function(dynamic value) getText;
  final void Function(dynamic value) onSelected;

  const QuestionSingleChoice({
    super.key,
    required this.items,
    required this.getText,
    required this.onSelected,
  });

  @override
  State createState() => _QuestionSingleChoiceState();
}

class _QuestionSingleChoiceState extends State<QuestionSingleChoice> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      shrinkWrap: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final value = widget.items[index];

        return CustomOutlinedButton(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });

            widget.onSelected(widget.items[index]);
          },
          selected: selectedIndex == index,
          child: Center(
            child: Text(
              widget.getText(value),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}
