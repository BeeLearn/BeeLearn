import 'package:beelearn/services/text_parser.dart';
import 'package:flutter/material.dart';

class TextInputParser {
  static Column parse(BuildContext context, List<List<String>> lines) {
    return Column(
      children: lines.map(
        (line) {
          return Row(
            children: line.map(
              (token) {
                return Row(
                  children: TextParser.tokenize(token).map((token) {
                    return token.startsWith("%") && token.endsWith("%")
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 32,
                            ),
                            child: IntrinsicWidth(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 98,
                                ),
                                child: const TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : token.trim().isEmpty
                            ? SizedBox(width: token.length.toDouble() * 4)
                            : Text(
                                token,
                                textAlign: TextAlign.left,
                              );
                  }).toList(),
                );
              },
            ).toList(),
          );
        },
      ).toList(),
    );
  }
}
