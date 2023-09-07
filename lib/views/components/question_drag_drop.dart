import 'package:flutter/material.dart';

import '../../serializers/question.dart';
import '../../services/code_parser.dart';
import '../../services/code_question_parser.dart';
import '../../views/components/answer_code_draggable.dart';
import '../../views/components/custom_draggable.dart';
import '../../views/fragments/answer_drag_drop_fragment.dart';

class QuestionDragDrop extends StatefulWidget {
  final DragDropQuestion question;
  final void Function(
    Iterable<AnswerDragDropFragmentState> targets,
    bool Function() validate,
  ) onChange;

  const QuestionDragDrop({
    super.key,
    required this.question,
    required this.onChange,
  });

  @override
  State<QuestionDragDrop> createState() => _QuestionDragDropState();
}

class _QuestionDragDropState extends State<QuestionDragDrop> {
  late final Widget questionWidget;
  late final Iterable<GlobalKey<AnswerDragDropFragmentState>> targetKeys;

  Iterable<AnswerDragDropFragmentState> get targets {
    return targetKeys.map((key) => key.currentState!);
  }

  @override
  void initState() {
    super.initState();
    final result = CodeQuestionParser.parser(CodeParser.tokenize(widget.question.question));

    questionWidget = result.$1;
    targetKeys = result.$2;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (final target in targets) {
        target.onChange = () => widget.onChange(targets, validate);
      }
    });
  }

  /// Todo debug circular mismatch with more concise + operator
  void _onChange(DragData currentData, DragData previousData) {
    final data = previousData + currentData;

    for (final target in targets) {
      final targetData = target.data;

      if (targetData == null) continue;

      // Fix when data is not equal to targetData
      // When two there is circular mismatch of data
      if (data == targetData || data.placeholder == targetData.placeholder) target.reset();
    }

    widget.onChange(targets, validate);
  }

  bool validate() {
    bool isValid = true;

    for (final target in targets) {
      target.validate();
      isValid = isValid && target.isCorrect;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        questionWidget,
        Wrap(
          spacing: 16.0,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: widget.question.choices
              .map(
                (choice) => AnswerCodeDraggable(
                  data: DragData(
                    value: choice,
                    isReverse: false,
                  ),
                  onChange: _onChange,
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
