import 'package:flutter/material.dart';

import '../../services/code_parser.dart';
import '../../services/text_input_parser.dart';

class QuestionTextOption extends StatefulWidget {
  final String question;

  const QuestionTextOption({super.key, required this.question});

  @override
  State<QuestionTextOption> createState() => _QuestionTextOptionState();
}

class _QuestionTextOptionState extends State<QuestionTextOption> {
  @override
  Widget build(BuildContext context) {
    return TextInputParser.parse(
      context,
      CodeParser.tokenize(widget.question),
    );
  }
}
