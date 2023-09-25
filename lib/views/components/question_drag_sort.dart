import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../serializers/question.dart';
import '../../views/components/buttons.dart';

class QuestionDragSortChoice extends StatefulWidget {
  final List<ReorderChoice> choices;
  final void Function(Function() orderChoices)? onInit;
  final void Function(
    List<ReorderChoice> choices,
    bool Function() onSubmit,
  ) onReorder;

  const QuestionDragSortChoice({
    super.key,
    this.onInit,
    required this.choices,
    required this.onReorder,
  });

  @override
  State<QuestionDragSortChoice> createState() => _QuestionDragSortChoiceState();
}

class _QuestionDragSortChoiceState extends State<QuestionDragSortChoice> {
  bool _isSummited = false;
  late List<ReorderChoice> _choices = [...widget.choices];

  @override
  void initState() {
    super.initState();
    // randomize choices
    _choices.shuffle();
    _onReorder();
    if (widget.onInit != null) {
      widget.onInit!(
        () => setState(
          () => _choices = widget.choices,
        ),
      );
    }
  }

  void _onReorder() {
    widget.onReorder(
      _choices,
      () {
        setState(() => _isSummited = true);
        return _validateChoices();
      },
    );
  }

  bool _validateChoices() {
    for (final [a, b] in IterableZip([widget.choices, _choices])) {
      if (a.position != b.position) return false;
    }

    return true;
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableList(
      itemCount: _choices.length,
      proxyDecorator: _proxyDecorator,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) newIndex -= 1;
          _choices.insert(newIndex, _choices.removeAt(oldIndex));
          if (_isSummited) _isSummited = false;
        });

        _onReorder();
      },
      itemBuilder: (context, index) {
        final choice = _choices[index];
        final isCorrect = widget.choices[index].position == choice.position;

        return ReorderableDragStartListener(
          index: index,
          key: Key(choice.position.toString()),
          child: CustomOutlinedButton(
            backgroundColor: Theme.of(context).colorScheme.surface,
            selected: _isSummited,
            selectedBackgroundColor: _isSummited
                ? isCorrect
                    ? Colors.greenAccent
                    : Colors.redAccent
                : null,
            child: Row(
              children: [
                Expanded(child: Text(choice.name)),
                const Icon(Icons.drag_handle_outlined),
              ],
            ),
          ),
        );
      },
    );
  }
}
