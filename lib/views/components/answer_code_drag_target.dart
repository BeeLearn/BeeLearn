import 'package:beelearn/views/components/answer_code_draggable.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';
import 'custom_drag_target.dart';

// Todo make answer drag target not able to resize
// Todo Don't leave hint to users
class AnswerCodeDragTarget extends StatefulWidget {
  final String? data;
  final bool canResize;

  const AnswerCodeDragTarget({
    super.key,
    this.data,
    this.canResize = true,
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
  State<AnswerCodeDragTarget> createState() => _AnswerCodeDragTargetState();
}

class _AnswerCodeDragTargetState extends State<AnswerCodeDragTarget> {
  @override
  Widget build(BuildContext context) {
    return CustomDragTarget<String>(
      getEmptyWidget: (data) => AnswerCodeDragTarget.variableDropZone(
        data: data.isNotEmpty ? data[0] : null,
      ),
      getWidget: (data) => AnswerCodeDraggable(
        data: data,
        canResize: widget.canResize,
      ),
    );
  }
}
