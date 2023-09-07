import 'package:beelearn/serializers/question.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

class QuestionSingleChoice<T extends Choice> extends StatefulWidget {
  final List<T> choices;
  final String Function(T value) getText;
  final void Function(
    T value,
    void Function() onSubmit,
  ) onSelected;
  final void Function(void Function() answer) onInit;

  const QuestionSingleChoice({
    super.key,
    required this.choices,
    required this.getText,
    required this.onInit,
    required this.onSelected,
  });

  @override
  State createState() => _QuestionSingleChoiceState<T>();
}

class _QuestionSingleChoiceState<T extends Choice> extends State<QuestionSingleChoice> {
  int? selectedIndex;
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();

    widget.onInit(_selectAnswers);
  }

  _selectAnswers() {
    setState(() {
      selectedIndex = widget.choices.indexWhere((choice) => choice.isAnswer);
    });

    _updateView();
  }

  _updateView() {
    if (selectedIndex != null) {
      widget.onSelected(
        widget.choices[selectedIndex!],
        () => setState(
          () => isSubmitted = true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.choices.length,
      shrinkWrap: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final Choice choice = widget.choices[index];
        final isSelected = selectedIndex == index;

        return CustomOutlinedButton(
          onTap: () {
            setState(() {
              isSubmitted = false;
              selectedIndex = index;
            });

            _updateView();
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
