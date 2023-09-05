import 'package:beelearn/serializers/question.dart';
import 'package:beelearn/views/app_theme.dart';
import 'package:beelearn/views/components/question_single_choice.dart';
import 'package:beelearn/views/components/question_text_option.dart';
import 'package:flutter/material.dart';

import '../services/code_question_parser.dart';

class QuestionView extends StatefulWidget {
  final Question question;

  const QuestionView({
    super.key,
    required this.question,
  });

  @override
  State<StatefulWidget> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  void Function()? onAnswer;
  late CodeQuestionParser codeQuestionParser = CodeQuestionParser();

  @override
  void initState() {
    super.initState();
  }

  Widget getView() {
    switch (widget.question.type) {
      case QuestionType.singleChoice:
        SingleChoiceQuestion question = widget.question as SingleChoiceQuestion;

        return QuestionSingleChoice<Choice>(
          items: question.choices,
          getText: (choice) => choice.name,
          onSelected: (value, onSubmit) {
            setState(() {
              onAnswer = () {
                /// If correct and has Answer before
                /// Next Page
                onSubmit();
              };
            });
          },
        );
      case QuestionType.textOption:
        TextOptionQuestion question = widget.question as TextOptionQuestion;

        return QuestionTextOption(
          question: question.question,
          onChanged: (formKey) {
            setState(() {
              onAnswer = () {
                formKey.currentState?.validate();
              };
            });
          },
        );
      default:
        return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Text(
              widget.question.title,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: getView(),
            ),
            Wrap(
              runSpacing: 16.0,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(Icons.lock_outline),
                  label: const Text("Answer"),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Theme(
                    data: AppTheme.light,
                    child: FilledButton(
                      onPressed: onAnswer,
                      style: FilledButton.styleFrom(
                        disabledBackgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.primary.withAlpha(200) : Theme.of(context).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: const Text("Continue"),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
