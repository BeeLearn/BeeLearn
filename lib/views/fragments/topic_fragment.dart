import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/topic_question_controller.dart';
import '../../models/thread_model.dart';
import '../../models/topic_model.dart';
import '../../models/user_model.dart';
import '../../serializers/serializers.dart';
import '../../views/components/pill_chip.dart';
import '../../views/fragments/subscription_ad_fragment.dart';
import '../../views/thread_view.dart';
import '../components/page_view_indicators.dart';
import '../question_view.dart';

enum _TopicFragmentViewType { topicView, questionView }

class TopicFragment extends StatefulWidget {
  final Map<String, dynamic> query;

  const TopicFragment({
    super.key,
    required this.query,
  });

  @override
  State createState() => _TopicFragmentState();
}

/// Todo move items to top level as variable
class _TopicFragmentState extends State<TopicFragment> {
  late UserModel userModel;
  late TopicModel topicModel;

  int currentPage = 0;

  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    topicModel = Provider.of<TopicModel>(
      context,
      listen: false,
    );

    TopicModel.getTopics(query: widget.query).then(
      (topics) {
        topicModel.setAll(topics.results);
        topicModel.loading = false;
      },
    );

    userModel.addListener(onLifeFinished);

    // ensure user can't access course when lifeline is low
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        onLifeFinished();
      },
    );
  }

  void onLifeFinished() {
    if (userModel.value.profile!.lifeLine == 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SubscriptionAdFragment(
          title: "You don't have any lives left",
          onAdsLoaded: () {
            final user = userModel.value;
            user.profile!.temporaryLives += 1;
            userModel.value = user;

            Navigator.pop(context);
          },
          onBackPressed: () => Navigator.popUntil(
            context,
            (route) => route.isFirst,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    userModel.removeListener(onLifeFinished);
  }

  /// Markdown widget view
  Widget _getMarkdownContent(Topic topic) {
    return MarkdownWidget(
      data: topic.content,
      config: Theme.of(context).brightness == Brightness.dark
          ? MarkdownConfig.darkConfig.copy(
              configs: [
                const PConfig(
                  textStyle: TextStyle(fontSize: 14),
                ),
                PreConfig.darkConfig.copy(
                  textStyle: GoogleFonts.notoSans(),
                  styleNotMatched: GoogleFonts.notoSans(),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const BlockquoteConfig(
                  textColor: Colors.white60,
                ),
              ],
            )
          : MarkdownConfig.defaultConfig.copy(
              configs: [
                const PConfig(
                  textStyle: TextStyle(fontSize: 14),
                ),
                PreConfig(
                  textStyle: GoogleFonts.notoSans(),
                  styleNotMatched: GoogleFonts.notoSans(),
                ),
              ],
            ),
    );
  }

  Widget getTopicView(Topic topic, int index) {
    return Stack(
      children: [
        SafeArea(
          bottom: false,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      topic.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.albertSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
                  child: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                      ? SizedBox(
                          width: ResponsiveBreakpoints.of(context).screenWidth * 0.5,
                          height: double.infinity,
                          child: _getMarkdownContent(topic),
                        )
                      : _getMarkdownContent(topic),
                ),
              ),
              BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          useSafeArea: false,
                          context: context,
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => ThreadModel(),
                            child: ThreadView(reference: topic.threadReference),
                          ),
                        );
                      },
                      icon: const Icon(CupertinoIcons.chat_bubble),
                    ),
                    IconButton(
                      onPressed: () async {
                        /// Lazy update
                        topic.setIsLiked(userModel.value, !topic.isLiked);

                        topic.isLiked = !topic.isLiked;
                        topicModel.updateOne(topic);
                      },
                      isSelected: topic.isLiked,
                      selectedIcon: const Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.red,
                      ),
                      icon: const Icon(CupertinoIcons.heart),
                    ),
                    IconButton(
                      onPressed: () async {
                        context.loaderOverlay.show();

                        /// Todo Complete Lesson Share
                        Share.shareWithResult(
                          "Check out this course on BeeLearn",
                          subject: "We are",
                        ).whenComplete(
                          () => context.loaderOverlay.hide(),
                        );
                      },
                      icon: const Icon(CupertinoIcons.share),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// nextPage manually, used when an assessment has been completed
  Future<void> _nextPage(
    List<dynamic> items,
    List<_TopicFragmentViewType> viewTypes,
  ) async {
    if (currentPage < items.length - 1) {
      context.loaderOverlay.show();
      final nextViewType = viewTypes[currentPage + 1];

      if (nextViewType == _TopicFragmentViewType.topicView) {
        unlockTopic(items[currentPage + 1]);
        controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      context.loaderOverlay.hide();
    }
  }

  (List<_TopicFragmentViewType>, List<dynamic>) _getViewTypes(List<Topic> topics) {
    final List<_TopicFragmentViewType> viewTypes = [];
    final List<dynamic> items = [];

    for (final topic in topics) {
      viewTypes.add(_TopicFragmentViewType.topicView);
      items.add(topic);

      if (topic.topicQuestions.isNotEmpty) {
        items.addAll(topic.topicQuestions);
        viewTypes.addAll(
          List.filled(
            topic.topicQuestions.length,
            _TopicFragmentViewType.questionView,
          ),
        );
      }
    }

    return (viewTypes, items);
  }

  /// Check if user can scroll right
  /// Only when an assessment has been taken or viewType is topic can a view be scrolled left
  bool _canScrollNext(
    List<dynamic> items,
    List<_TopicFragmentViewType> viewTypes,
  ) {
    final viewType = viewTypes[currentPage];

    switch (viewType) {
      case _TopicFragmentViewType.topicView:
        // always true if current view is topicView
        return true;
      case _TopicFragmentViewType.questionView:
        if (currentPage < items.length - 1) {
          final TopicQuestion topicQuestion = items[currentPage];
          // This is mutated when  question is answered
          // or is true when a question is previously answered
          return topicQuestion.isAnswered;
        }

        return false;
    }
  }

  /// complete topic
  Future<void> completeTopic(Topic topic) async {
    if (!topic.isCompleted) {
      final newTopic = await topic.setIsComplete(userModel.value);
      topicModel.updateOne(newTopic);
    }
  }

  /// unlock topic
  Future<void> unlockTopic(Topic topic) async {
    if (!topic.isUnlocked) {
      // Lazy update
      topic.setIsUnlocked(userModel.value);

      topic.isUnlocked = true;
      topicModel.updateOne(topic);
    }
  }

  /// Mark question as answered by user
  Future<void> _markQuestionAsAnswered(TopicQuestion topicQuestion) async {
    if (!topicQuestion.isAnswered) {
      // Lazy update
      topicQuestionController.updateTopicQuestion(
        id: topicQuestion.id,
        body: {
          "answered_users": {
            "add": [userModel.value.id],
          }
        },
      );

      topicQuestion.isAnswered = true;
      final topic = topicModel.getEntityById(topicQuestion.topic)!;
      final index = topic.topicQuestions.indexWhere(
        (topicQuestion) => topicQuestion.id == topicQuestion.id,
      );

      topic.topicQuestions[index] = topicQuestion;
      topicModel.updateOne(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopicModel>(
      builder: (context, model, child) {
        final (viewTypes, items) = _getViewTypes(model.items);

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: const CloseButton(),
            title: LinearProgressPageIndicator(
              itemCount: items.length,
              pageController: controller,
            ),
            actions: [
              PillChip(
                children: [
                  const Icon(
                    Icons.favorite,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 4.0),
                  Selector<UserModel, int>(
                    selector: (context, model) => model.value.profile!.lifeLine,
                    builder: (context, lives, child) {
                      return Text("$lives");
                    },
                  ),
                ],
              ),
              const SizedBox(width: 4.0),
            ],
          ),
          body: model.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PageView.builder(
                  itemCount: items.length,
                  controller: controller,
                  physics: items.isNotEmpty && _canScrollNext(items, viewTypes) ? null : const LeftBlockedScrollPhysics(),
                  onPageChanged: (index) {
                    if (index > 0) {
                      final currentIndex = index - 1;
                      final viewType = viewTypes[currentIndex];
                      if (viewType == _TopicFragmentViewType.topicView) completeTopic(items[currentIndex]);
                    }

                    setState(() => currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final viewType = viewTypes[index];
                    final item = items[index];

                    switch (viewType) {
                      case _TopicFragmentViewType.topicView:
                        return getTopicView(item, index);
                      case _TopicFragmentViewType.questionView:
                        return QuestionView(
                          topicQuestion: items[index],

                          /// Todo rename callback as afterValidation
                          markQuestionAsCompleted: () async {
                            final topicQuestion = items[currentPage];
                            // Mark question as answered
                            await _markQuestionAsAnswered(topicQuestion);
                          },
                          nextPage: () => _nextPage(items, viewTypes),
                        );
                      default:
                        throw UnimplementedError("viewType not implemented");
                    }
                  },
                ),
        );
      },
    );
  }
}
