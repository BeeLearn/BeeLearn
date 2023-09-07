import 'dart:core';

import 'package:beelearn/views/fragments/answer_drag_drop_fragment.dart';
import 'package:flutter/material.dart';

class CodeQuestionParser {
  static (Column, List<GlobalKey<AnswerDragDropFragmentState>>) parser(List<List<String>> lines) {
    final List<Widget> children = [];
    List<GlobalKey<AnswerDragDropFragmentState>> targetKeys = [];

    for (final line in lines) {
      children.add(
        Row(
          children: line.map<Widget>((token) {
            if (token.startsWith("%") && token.endsWith("%")) {
              final key = GlobalKey<AnswerDragDropFragmentState>();
              final target = AnswerDragDropFragment(
                key: key,
                token: token,
              );
              targetKeys.add(key);
              return target;
            } else {
              return Text(token);
            }
          }).toList(),
        ),
      );
      children.add(const SizedBox(height: 16));
    }

    return (
      Column(
        children: children,
      ),
      targetKeys
    );
  }
}
