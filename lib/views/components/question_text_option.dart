import 'package:flutter/material.dart';

import '../../services/code_parser.dart';
import '../../services/text_input_parser.dart';
import '../fragments/text_input_parser_fragment.dart';

class QuestionTextOption extends StatefulWidget {
  final String question;
  final void Function(
    GlobalKey<FormState> formKey,
    List<GlobalKey<TextInputFragmentState>> fragments,
  ) onChanged;
  final void Function(List<GlobalKey<TextInputFragmentState>> fragmentKeys) onInit;

  const QuestionTextOption({
    super.key,
    required this.onInit,
    required this.question,
    required this.onChanged,
  });

  @override
  State<QuestionTextOption> createState() => QuestionTextOptionState();
}

class QuestionTextOptionState extends State<QuestionTextOption> {
  final _formKey = GlobalKey<FormState>();

  late Widget _parsedWidget;
  late List<GlobalKey<TextInputFragmentState>> fragmentKeys;

  @override
  void initState() {
    super.initState();

    final parsedResult = TextInputParser.parse(
      context,
      CodeParser.tokenize(widget.question),
    );

    _parsedWidget = parsedResult.$1;
    fragmentKeys = parsedResult.$2;

    widget.onInit(fragmentKeys);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => widget.onChanged(_formKey, fragmentKeys),
      child: _parsedWidget,
    );
  }
}
