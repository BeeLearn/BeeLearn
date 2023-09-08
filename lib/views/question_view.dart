import 'dart:developer';

import 'package:flutter/material.dart';

import '../serializers/question.dart';
import '../services/code_question_parser.dart';
import '../views/app_theme.dart';
import '../views/components/question_drag_drop.dart';
import '../views/components/question_multiple_choice.dart';
import '../views/components/question_single_choice.dart';
import '../views/components/question_text_option.dart';

class QuestionView extends StatefulWidget {
  final Question question;
  final void Function() nextPage;

  const QuestionView({
    super.key,
    required this.question,
    required this.nextPage,
  });

  @override
  State<StatefulWidget> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final onAnswerListener = ValueNotifier<void Function()?>(null);
  final onValidateListener = ValueNotifier<void Function()?>(null);

  late CodeQuestionParser codeQuestionParser = CodeQuestionParser();

  @override
  void initState() {
    super.initState();
  }

  Widget getView() {
    switch (widget.question.type) {
      case QuestionType.singleChoice:
        final question = widget.question as SingleChoiceQuestion;

        return QuestionSingleChoice<Choice>(
          choices: question.choices,
          onInit: (answer) => onAnswerListener.value = answer,
          getText: (choice) => choice.name,
          onSelected: (selectedChoice, onSubmit) {
            onValidateListener.value = () {
              onSubmit();
              final isCorrect = selectedChoice.isAnswer;
              if (isCorrect) onValidateListener.value = widget.nextPage;

              /// Todo show success dialog
            };
          },
        );
      case QuestionType.multipleChoice:
        final question = widget.question as MultiChoiceQuestion;
        return QuestionMultipleChoice(
          choices: question.choices,
          onInit: (answer) => onAnswerListener.value = answer,
          getText: (choice) => choice.name,
          onReset: () => onValidateListener.value = null,
          onSelected: (selectedChoices, onSubmit) {
            onValidateListener.value = () {
              onSubmit();
              final isCorrect = selectedChoices.every((choice) => choice.isAnswer);
              // Todo show success dialog
              // Todo validate = nextPage
            };
          },
        );
      case QuestionType.textOption:
        final question = widget.question as TextOptionQuestion;

        return QuestionTextOption(
          question: question.question,
          onInit: (fragmentKeys) {
            onAnswerListener.value = () {
              for (final key in fragmentKeys) {
                key.currentState?.inputPlaceholder();
              }
            };
          },
          onChanged: (formKey, fragmentKeys) {
            onValidateListener.value = () {
              if (formKey.currentState!.validate()) {
                bool isCorrect = fragmentKeys.every((key) => key.currentState!.validateField());
                log(isCorrect.toString());
                if (isCorrect) onValidateListener.value = widget.nextPage;

                /// Todo show success message
              }
            };

            if (fragmentKeys.every(
              (key) => key.currentState!.inputController.text.isEmpty,
            )) {
              onValidateListener.value = null;
            }
          },
        );
      case QuestionType.dragDrop:
        final question = widget.question as DragDropQuestion;
        return QuestionDragDrop(
          question: question,
          onChange: (targets, validateTargets) {
            if (targets.every((target) => target.hasData)) {
              onValidateListener.value = () {
                log("This is called not expected");
                if (validateTargets()) {
                  // On Continue click nextPage or if lesson complete quit
                  onValidateListener.value = () {
                    log("AHHHHH Validate scam");

                    widget.nextPage();
                    // onValidateListener.value = null;
                  };
                }
              };
            } else {
              onValidateListener.value = null;
            }
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
                  onPressed: () {
                    if (onAnswerListener.value != null) onAnswerListener.value!();
                  },
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
                    child: ValueListenableBuilder(
                      valueListenable: onValidateListener,
                      builder: (valueContext, value, child) {
                        return FilledButton(
                          onPressed: value,
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            disabledBackgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight.withAlpha(164) : null,
                          ),
                          child: const Text("Continue"),
                        );
                      },
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
