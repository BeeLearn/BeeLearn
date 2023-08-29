import 'package:beelearn/views/components/buttons.dart';
import 'package:flutter/material.dart';

class QuestionDragSortChoice<T> extends StatefulWidget {
  final List<T> items;
  final String Function(dynamic value)? getKey;
  final String Function(dynamic value) getText;
  final void Function(int oldIndex, int newIndex) onReorder;

  const QuestionDragSortChoice({
    super.key,
    this.getKey,
    required this.items,
    required this.onReorder,
    required this.getText,
  });

  @override
  State<QuestionDragSortChoice> createState() => _QuestionDragSortChoiceState();
}

class _QuestionDragSortChoiceState extends State<QuestionDragSortChoice> {
  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
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
      itemCount: widget.items.length,
      proxyDecorator: proxyDecorator,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: widget.onReorder,
      itemBuilder: (context, index) {
        final value = widget.items[index];

        return ReorderableDragStartListener(
          index: index,
          key: Key(
            widget.getKey != null ? widget.getKey!(value) : "$index",
          ),
          child: CustomOutlinedButton(
            preventGesture: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(child: Text(widget.getText(value))),
                const Icon(Icons.drag_handle_outlined),
              ],
            ),
          ),
        );
      },
    );
  }
}
