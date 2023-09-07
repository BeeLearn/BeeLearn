import 'package:flutter/material.dart';

enum DragState {
  idle,
  started,
  updated,
  completed,
}

@immutable
class DragData {
  final String? value;
  final bool isReverse;
  final String? placeholder;

  const DragData({
    this.value,
    this.placeholder,
    required this.isReverse,
  });

  operator +(DragData other) {
    return DragData(
      value: value,
      isReverse: isReverse,
      placeholder: other.placeholder ?? placeholder,
    );
  }

  @override
  bool operator ==(other) {
    return other is DragData && other.runtimeType == runtimeType && value == other.value && placeholder == other.placeholder;
  }

  @override
  String toString() {
    return "DragData(isReverse=$isReverse,value=$value,placeholder=$placeholder)";
  }

  @override
  int get hashCode => Object.hashAll([value, placeholder]);
}

class CustomDraggable extends StatefulWidget {
  final DragData data;
  final Widget childWhenCompleted;
  final Widget feedback, childWhenDragging;
  final Function(DragData data, DragState state) getChild;
  final void Function(DragState state, DragData currentData) onChange;

  const CustomDraggable({
    super.key,
    required this.data,
    required this.getChild,
    required this.feedback,
    required this.onChange,
    required this.childWhenDragging,
    required this.childWhenCompleted,
  });

  @override
  State createState() => _CustomDraggableState();
}

class _CustomDraggableState extends State<CustomDraggable> {
  DragState _dragState = DragState.idle;

  @override
  Widget build(BuildContext context) {
    final child = widget.getChild(widget.data, _dragState);

    return _dragState == DragState.completed
        ? widget.childWhenCompleted
        : Draggable<DragData>(
            data: widget.data,
            onDragStarted: () {
              setState(() => _dragState = DragState.started);

              widget.onChange(DragState.started, widget.data);
            },
            onDragUpdate: (details) {
              setState(() => _dragState = DragState.updated);

              widget.onChange(DragState.updated, widget.data);
            },
            onDraggableCanceled: (velocity, offset) {
              setState(() => _dragState = DragState.idle);

              widget.onChange(DragState.idle, widget.data);
            },
            onDragCompleted: () {
              setState(() => _dragState = DragState.completed);

              widget.onChange(DragState.completed, widget.data);
            },
            child: child,
            feedback: widget.feedback,
            childWhenDragging: widget.childWhenDragging,
          );
  }
}
