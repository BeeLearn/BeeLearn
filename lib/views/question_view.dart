import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import '../serializers/serializers.dart';
import '../services/code_question_parser.dart';
import '../views/app_theme.dart';
import '../views/components/question_drag_drop.dart';
import '../views/components/question_drag_sort.dart';
import '../views/components/question_multiple_choice.dart';
import '../views/components/question_single_choice.dart';
import '../views/components/question_text_option.dart';
import '../views/fragments/subscription_ad_fragment.dart';

class QuestionView extends StatefulWidget {
  final TopicQuestion topicQuestion;
  final Future<void> Function() nextPage;
  final Future<void> Function() markQuestionAsCompleted;

  const QuestionView({
    super.key,
    required this.topicQuestion,
    required this.nextPage,
    required this.markQuestionAsCompleted,
  });

  @override
  State<StatefulWidget> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  late final UserModel _userModel;
  final onAnswerListener = ValueNotifier<void Function()?>(null);
  final onValidateListener = ValueNotifier<void Function()?>(null);

  late CodeQuestionParser codeQuestionParser = CodeQuestionParser();

  @override
  void initState() {
    super.initState();

    _userModel = Provider.of(
      context,
      listen: false,
    );
  }

  void _answerQuestion() {
    if (_userModel.value.isPremium) {
      if (onAnswerListener.value != null) onAnswerListener.value!();
    } else {
      showDialog(
        context: context,
        builder: (context) => SubscriptionAdFragment(
          title: "Watch ads to answer question",
          onAdsLoaded: () {
            if (onAnswerListener.value != null) onAnswerListener.value!();
            Navigator.pop(context);
          },
          onBackPressed: () => Navigator.pop(context),
        ),
      );
    }
  }

  /// Decrease user lives if answer is invalid
  Future<void> _isAnswerInvalid() async {
    final user = _userModel.value;

    if (user.isPremium) return;

    final profile = user.profile!;

    // Deduct life from temporaryLives if any
    if (profile.temporaryLives > 0) {
      profile.temporaryLives -= 1;
      user.profile = profile;
      _userModel.value = user;
      return;
    }

    await userController.updateUser(
      id: _userModel.value.id,
      body: {
        "profile": {
          "lives": _userModel.value.profile!.lives - 1,
        },
      },
    );
  }

  Widget getView() {
    switch (widget.topicQuestion.question.type) {
      case QuestionType.singleChoice:
        final question = widget.topicQuestion.question as SingleChoiceQuestion;

        return QuestionSingleChoice<Choice>(
          choices: question.choices,
          onInit: (answer) => onAnswerListener.value = answer,
          getText: (choice) => choice.name,
          onSelected: (selectedChoice, onSubmit) {
            onValidateListener.value = () async {
              onSubmit();
              final isCorrect = selectedChoice.isAnswer;

              if (isCorrect) {
                await widget.markQuestionAsCompleted();
                onValidateListener.value = widget.nextPage;
              } else {
                /// Todo prevent for premium users
                _isAnswerInvalid();
                onValidateListener.value = null;
              }
            };
          },
        );
      case QuestionType.multipleChoice:
        final question = widget.topicQuestion.question as MultiChoiceQuestion;

        return QuestionMultipleChoice(
          choices: question.choices,
          onInit: (answer) => onAnswerListener.value = answer,
          getText: (choice) => choice.name,
          onReset: () => onValidateListener.value = null,
          onSelected: (selectedChoices, onSubmit) {
            onValidateListener.value = () {
              onSubmit();
              final isCorrect = selectedChoices.every((choice) => choice.isAnswer);

              if (isCorrect) {
                widget.markQuestionAsCompleted();
                onValidateListener.value = widget.nextPage;
              } else {
                /// Todo prevent for premium users
                _isAnswerInvalid();
                onValidateListener.value = null;
              }
            };
          },
        );
      case QuestionType.textOption:
        final question = widget.topicQuestion.question as TextOptionQuestion;

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
            onValidateListener.value = () async {
              if (formKey.currentState!.validate()) {
                bool isCorrect = fragmentKeys.every((key) => key.currentState!.validateField());

                if (isCorrect) {
                  await widget.markQuestionAsCompleted();
                  onValidateListener.value = widget.nextPage;
                }
              } else {
                _isAnswerInvalid();
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
        final question = widget.topicQuestion.question as DragDropQuestion;

        return QuestionDragDrop(
          question: question,
          onChange: (targets, validateTargets) {
            if (targets.every((target) => target.hasData)) {
              onValidateListener.value = () async {
                if (validateTargets()) {
                  await widget.markQuestionAsCompleted();
                  onValidateListener.value = widget.nextPage;
                }
              };
            } else {
              /// Todo prevent for premium users
              _isAnswerInvalid();
              onValidateListener.value = null;
            }
          },
        );
      case QuestionType.reorderChoice:
        final question = widget.topicQuestion.question as ReorderChoiceQuestion;
        return QuestionDragSortChoice(
          choices: question.choices,
          onInit: (orderChoices) {
            onAnswerListener.value = orderChoices;
          },
          onReorder: (newChoices, onSubmit) {
            onValidateListener.value = () async {
              final isValid = onSubmit();

              if (isValid) {
                await widget.markQuestionAsCompleted();
                onValidateListener.value = widget.nextPage;
              } else {
                /// Todo prevent for premium users
                _isAnswerInvalid();
                onValidateListener.value = null;
              }
            };
          },
        );
    }
  }

  Widget get body {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(child: getView()),
        Wrap(
          runSpacing: 16.0,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _answerQuestion,
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
        ),
      ],
    );
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
              widget.topicQuestion.question.title,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
