import 'package:flutter/material.dart';

import '../../services/code_parser.dart';
import '../../services/text_input_parser.dart';

class QuestionTextOption extends StatefulWidget {
  final String question;
  final void Function(GlobalKey<FormState> formKey) onChanged;
  const QuestionTextOption({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  State<QuestionTextOption> createState() => _QuestionTextOptionState();
}

class _QuestionTextOptionState extends State<QuestionTextOption> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => widget.onChanged(_formKey),
      child: TextInputParser.parse(
        context,
        CodeParser.tokenize(widget.question),
      ),
    );
  }
}
