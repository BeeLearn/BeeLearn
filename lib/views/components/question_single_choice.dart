import 'package:beelearn/serializers/question.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

class QuestionSingleChoice<T extends Choice> extends StatefulWidget {
  final List<T> items;
  final String Function(T value) getText;
  final void Function(
    T value,
    void Function() onSubmit,
  ) onSelected;

  const QuestionSingleChoice({
    super.key,
    required this.items,
    required this.getText,
    required this.onSelected,
  });

  @override
  State createState() => _QuestionSingleChoiceState<T>();
}

class _QuestionSingleChoiceState<T extends Choice> extends State<QuestionSingleChoice> {
  int? selectedIndex;
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      shrinkWrap: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final Choice choice = widget.items[index];
        final isSelected = selectedIndex == index;

        return CustomOutlinedButton(
          onTap: () {
            setState(() {
              isSubmitted = false;
              selectedIndex = index;
            });

            widget.onSelected(
              widget.items[index],
              () => setState(
                () => isSubmitted = true,
              ),
            );
          },
          selected: isSelected,
          selectedBackgroundColor: isSelected && isSubmitted
              ? choice.isAnswer
                  ? Colors.greenAccent
                  : Colors.redAccent
              : null,
          child: Center(
            child: Text(
              widget.getText(choice),
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
