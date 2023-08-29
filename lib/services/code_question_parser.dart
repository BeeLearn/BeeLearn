import 'dart:core';

import 'package:beelearn/views/components/answer_code_drag_target.dart';
import 'package:flutter/material.dart';

class CodeQuestionParser {
  static String variableDelimeter = "%s";

  static Column parser(List<List<String>> lines) {
    final List<Widget> children = [];

    for (final line in lines) {
      children.add(
        Row(
          children: line
              .map<Widget>(
                (token) => token == variableDelimeter
                    ? const AnswerCodeDragTarget(
                        canResize: false,
                      )
                    : Text(token),
              )
              .toList(),
        ),
      );
      children.add(const SizedBox(height: 16));
    }

    return Column(
      children: children,
    );
  }
}
