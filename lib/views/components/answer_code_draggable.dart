import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../views/app_theme.dart';
import 'answer_code_drag_target.dart';
import 'buttons.dart';
import 'custom_draggable.dart';

class AnswerCodeDraggable extends StatelessWidget {
  final DragData data;
  final ValidationState validationState;
  final void Function(DragData data, DragData previousData) onChange;

  const AnswerCodeDraggable({
    super.key,
    required this.data,
    required this.onChange,
    this.validationState = ValidationState.none,
  });

  bool get isValidated {
    switch (validationState) {
      case ValidationState.error:
      case ValidationState.success:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDraggable(
      data: data,
      // Ignore this for now
      onChange: (details, currentData) {},
      feedback: CustomOutlinedButton(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : null,
        // Flutter reset style when dragging, set text-style
        child: DefaultTextStyle(
          style: GoogleFonts.albertSans(),
          child: Text(
            data.value!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
      ),
      childWhenDragging: AnswerCodeDragTarget.variableDropZone(data: data.value),
      childWhenCompleted: AnswerCodeDragTarget(
        onChange: onChange,
        acceptData: data,
        validationState: validationState,
      ),
      getChild: (dragData, dragState) {
        return CustomOutlinedButton(
          selected: isValidated,
          selectedBackgroundColor: AppTheme.getValidationColor(validationState),
          backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : null,
          child: Text(dragData.value!),
        );
      },
    );
  }
}
