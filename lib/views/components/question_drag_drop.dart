import 'dart:developer';

import 'package:beelearn/views/components/custom_draggable.dart';
import 'package:beelearn/views/fragments/answer_drag_drop_fragment.dart';
import 'package:flutter/material.dart';

import '../../serializers/question.dart';
import '../../services/code_parser.dart';
import '../../services/code_question_parser.dart';
import '../../views/components/answer_code_draggable.dart';

class QuestionDragDrop extends StatefulWidget {
  final DragDropQuestion question;

  const QuestionDragDrop({
    super.key,
    required this.question,
  });

  @override
  State<QuestionDragDrop> createState() => _QuestionDragDropState();
}

class _QuestionDragDropState extends State<QuestionDragDrop> {
  late final Widget questionWidget;
  late final List<GlobalKey<AnswerDragDropFragmentState>> targetKeys;

  @override
  void initState() {
    super.initState();
    final result = CodeQuestionParser.parser(CodeParser.tokenize(widget.question.question));

    questionWidget = result.$1;
    targetKeys = result.$2;
  }

  void _onChange(DragData currentData, DragData previousData) {
    final data = previousData + currentData;

    for (final key in targetKeys) {
      final targetData = key.currentState?.data;
      if (targetData == null) continue;

      if (data == targetData) key.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        questionWidget,
        FilledButton(
          onPressed: () {
            log(targetKeys.length.toString());
            for (final key in targetKeys) {
              try {
                log(key.currentState!.data.toString());
                key.currentState?.validate();
              } catch (error, stackTrace) {
                log("Fucked", error: error, stackTrace: stackTrace);
              }
            }
          },
          child: const Text("Validate"),
        ),
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
