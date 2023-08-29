import 'package:flutter/material.dart';

enum DragState {
  idle,
  started,
  updated,
  completed,
}

class CustomDraggable<T extends Object> extends StatefulWidget {
  final T data;
  final Widget childWhenCompleted;
  final Widget? feedback, childWhenDragging;
  final Function({
    required T data,
    required DragState state,
  }) getChild;

  const CustomDraggable({
    super.key,
    this.feedback,
    this.childWhenDragging,
    required this.data,
    required this.getChild,
    required this.childWhenCompleted,
  });

  @override
  State createState() => _CustomDraggableState<T>();
}

class _CustomDraggableState<T extends Object> extends State<CustomDraggable> {
  DragState _dragState = DragState.idle;

  @override
  Widget build(BuildContext context) {
    final child = widget.getChild(data: widget.data, state: _dragState);

    return _dragState == DragState.completed
        ? widget.childWhenCompleted
        : Draggable<T>(
            data: widget.data as T,
            onDragStarted: () {
              setState(() {
                _dragState = DragState.started;
              });
            },
            onDragUpdate: (details) {
              _dragState = DragState.updated;
            },
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                _dragState = DragState.idle;
              });
            },
            onDragCompleted: () {
              setState(() {
                _dragState = DragState.completed;
              });
            },
            feedback: widget.feedback ?? child,
            childWhenDragging: widget.childWhenDragging,
            child: child,
          );
  }
}
