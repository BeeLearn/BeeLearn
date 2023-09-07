import 'package:beelearn/serializers/question.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

class QuestionMultipleChoice<T extends Choice> extends StatefulWidget {
  final List<T> choices;
  final String Function(T value) getText;
  final void Function() onReset;
  final void Function(
    List<T> value,
    void Function() onSubmit,
  ) onSelected;

  final void Function(void Function() answer) onInit;

  const QuestionMultipleChoice({
    super.key,
    required this.onInit,
    required this.choices,
    required this.getText,
    required this.onReset,
    required this.onSelected,
  });

  @override
  State createState() => _QuestionMultipleChoiceState<T>();
}

class _QuestionMultipleChoiceState<T extends Choice> extends State<QuestionMultipleChoice> {
  bool _isSubmitted = false;
  List<int> _selectedIndexes = [];

  Iterable<Choice> get _correctChoices => widget.choices.where((choice) => choice.isAnswer);

  @override
  void initState() {
    super.initState();

    widget.onInit(_selectAnswers);
  }

  void _selectAnswers() {
    setState(() {
      _selectedIndexes = _correctChoices.map((choice) => widget.choices.indexOf(choice)).toList();
    });

    _updateView();
  }

  void _updateView() {
    if (_selectedIndexes.isEmpty) widget.onReset();

    if (_selectedIndexes.length >= _correctChoices.length) {
      widget.onSelected(
        _selectedIndexes.map((index) => widget.choices[index]).toList(),
        () => setState(
          () => _isSubmitted = true,
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
        final isSelected = _selectedIndexes.contains(index);

        return CustomOutlinedButton(
          onTap: () {
            setState(() {
              _isSubmitted = false;
              if (isSelected) {
                _selectedIndexes.remove(index);
              } else {
                _selectedIndexes.add(index);
              }
            });

            _updateView();
          },
          selected: isSelected,
          selectedBackgroundColor: isSelected && _isSubmitted
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
