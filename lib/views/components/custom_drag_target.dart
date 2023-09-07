import 'package:flutter/material.dart';

import '../../views/components/custom_draggable.dart';

class CustomDragTarget extends StatefulWidget {
  final DragData acceptData;
  final Widget Function(List<DragData?> data) getEmptyWidget;
  final Widget Function(DragData currentData) getWidget;

  final void Function(DragData currentData, DragData previousData) onChange;

  const CustomDragTarget({
    super.key,
    required this.onChange,
    required this.getWidget,
    required this.getEmptyWidget,
    required this.acceptData,
  });

  @override
  State createState() => _CustomDragTargetState();
}

class _CustomDragTargetState extends State<CustomDragTarget> {
  bool hasData = false;
  late DragData acceptedData;

  @override
  Widget build(BuildContext context) {
    return hasData
        ? widget.getWidget(acceptedData)
        : DragTarget<DragData>(
            onWillAccept: (data) => data.runtimeType == widget.acceptData.runtimeType,
            onAccept: (data) {
              setState(() {
                hasData = true;
                acceptedData = data;
              });

              widget.onChange(data, widget.acceptData);
            },
            builder: (BuildContext context, List<DragData?> candidateData, List<dynamic> rejectedData) => widget.getEmptyWidget(candidateData),
          );
  }
}
