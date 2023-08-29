import 'package:flutter/material.dart';

class CustomDragTarget<T extends Object> extends StatefulWidget {
  final Widget Function(dynamic data) getWidget;
  final Widget Function(List<dynamic> data) getEmptyWidget;

  const CustomDragTarget({
    super.key,
    required this.getWidget,
    required this.getEmptyWidget,
  });

  @override
  State createState() => _CustomDragTargetState<T>();
}

class _CustomDragTargetState<T extends Object> extends State<CustomDragTarget> {
  T? acceptedData;
  bool hasData = false;

  @override
  Widget build(BuildContext context) {
    return hasData
        ? widget.getWidget(acceptedData)
        : DragTarget<T>(
            onWillAccept: (data) => true,
            onAccept: (T data) {
              setState(() {
                acceptedData = data;
                hasData = true;
              });
            },
            builder: (
              BuildContext context,
              List<Object?> candidateData,
              List<dynamic> rejectedData,
            ) {
              return widget.getEmptyWidget(candidateData);
            },
          );
  }
}
