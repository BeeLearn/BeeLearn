import 'package:flutter/material.dart';

import '../../views/components/answer_code_draggable.dart';
import '../../views/components/custom_draggable.dart';
import 'buttons.dart';
import 'custom_drag_target.dart';

enum ValidationState {
  none,
  error,
  success,
}

// Todo make answer drag target not able to resize
// Todo Don't leave hint to users
class AnswerCodeDragTarget extends StatelessWidget {
  final DragData acceptData;
  final ValidationState validationState;
  final void Function(DragData currentData, DragData previousData) onChange;

  const AnswerCodeDragTarget({
    super.key,
    required this.acceptData,
    required this.onChange,
    this.validationState = ValidationState.none,
  });

  static variableDropZone({
    String? data,
    double width = 56,
    double height = 32,
  }) {
    return data == null
        ? Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8.0),
            ),
          )
        : CustomOutlinedButton(
            onTap: () {},
            backgroundColor: Colors.grey[400],
            child: Visibility(
              visible: false,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: Text(data),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return CustomDragTarget(
      onChange: onChange,
      acceptData: acceptData,
      getEmptyWidget: (data) => AnswerCodeDragTarget.variableDropZone(),
      getWidget: (currentData) {
        return AnswerCodeDraggable(
          validationState: validationState,
          data: DragData(
            value: currentData.value,
            isReverse: acceptData.isReverse,
            placeholder: acceptData.placeholder ?? currentData.placeholder,
          ),
          onChange: onChange,
        );
      },
    );
  }
}
