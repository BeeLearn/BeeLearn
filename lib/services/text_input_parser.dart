import 'package:beelearn/views/fragments/text_input_parser_fragment.dart';
import 'package:flutter/material.dart';

import 'text_parser.dart';

class TextInputParser {
  static (Column, List<GlobalKey<TextInputFragmentState>>) parse(BuildContext context, List<List<String>> lines) {
    List<GlobalKey<TextInputFragmentState>> fragmentKeys = [];

    final widget = Column(
      children: lines.map(
        (line) {
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: line.map(
                  (token) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: TextParser.tokenize(token).map((token) {
                        if (token.startsWith("%") && token.endsWith("%")) {
                          final key = GlobalKey<TextInputFragmentState>();
                          final fragment = TextInputFragment(
                            key: key,
                            placeholder: token,
                            onSubmit: (value) {},
                          );

                          fragmentKeys.add(key);

                          return IntrinsicWidth(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 98,
                                minWidth: 32,
                                minHeight: 32,
                                maxHeight: 44,
                              ),
                              child: fragment,
                            ),
                          );
                        } else {
                          return token.trim().isEmpty
                              ? SizedBox(width: token.length.toDouble() * 4)
                              : Text(
                                  token,
                                  textAlign: TextAlign.center,
                                );
                        }
                      }).toList(),
                    );
                  },
                ).toList(),
              ),
            ),
          );
        },
      ).toList(),
    );

    return (widget, fragmentKeys);
  }
}
