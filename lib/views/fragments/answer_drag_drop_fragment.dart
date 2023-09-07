import 'package:beelearn/views/components/custom_draggable.dart';
import 'package:flutter/material.dart';

import '../components/answer_code_drag_target.dart';

class AnswerDragDropFragment extends StatefulWidget {
  final String token;

  const AnswerDragDropFragment({
    super.key,
    required this.token,
  });

  @override
  State<AnswerDragDropFragment> createState() => AnswerDragDropFragmentState();
}

class AnswerDragDropFragmentState extends State<AnswerDragDropFragment> {
  DragData? data;
  ValidationState validationState = ValidationState.none;

  void reset() => setState(() {
        data = null;
        validationState = ValidationState.none;
      });

  void validate() => isCorrect
      ? setState(() => validationState = ValidationState.success)
      : setState(
          () => validationState = ValidationState.error,
        );

  bool get isCorrect => data == null ? false : data?.placeholder == "%${data!.value}%";

  @override
  Widget build(BuildContext context) {
    return AnswerCodeDragTarget(
      validationState: validationState,
      acceptData: DragData(
        value: null,
        isReverse: true,
        placeholder: widget.token,
      ),
      onChange: (currentData, previousData) => setState(
        () {
          data = currentData + previousData;
          validationState = ValidationState.none;
        },
      ),
    );
  }
}
