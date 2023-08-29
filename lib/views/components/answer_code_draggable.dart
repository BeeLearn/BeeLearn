import 'package:beelearn/views/components/answer_code_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'buttons.dart';
import 'custom_draggable.dart';

class AnswerCodeDraggable extends StatefulWidget {
  final String data;
  final bool canResize;

  const AnswerCodeDraggable({
    super.key,
    required this.data,
    this.canResize = true,
  });

  @override
  State<AnswerCodeDraggable> createState() => _AnswerCodeDraggableState();
}

class _AnswerCodeDraggableState extends State<AnswerCodeDraggable> {
  @override
  Widget build(BuildContext context) {
    return CustomDraggable(
      data: widget.data,
      feedback: CustomOutlinedButton(
        onTap: () {},
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : null,
        child: DefaultTextStyle(
          style: GoogleFonts.albertSans(),
          child: Text(
            widget.data,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
        ),
      ),
      childWhenDragging: CustomOutlinedButton(
        onTap: () {},
        backgroundColor: Colors.grey[400],
        child: Visibility(
          visible: false,
          maintainSize: true,
          maintainState: true,
          maintainAnimation: true,
          child: Text(widget.data),
        ),
      ),
      childWhenCompleted: AnswerCodeDragTarget(
        data: widget.canResize ? widget.data : null,
      ),
      getChild: ({required Object data, required DragState state}) {
        return CustomOutlinedButton(
          onTap: () {},
          backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : null,
          child: Text(data as String),
        );
      },
    );
  }
}
