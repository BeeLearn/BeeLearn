import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/topic_comment_model.dart';
import '../../models/topic_model.dart';
import '../../models/user_model.dart';
import '../../serializers/topic.dart';
import '../../services/ad_loader.dart';
import '../../views/topic_comment_view.dart';
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

class _TopicFragmentState extends State<TopicFragment> {
  late UserModel userModel;
  late TopicModel topicModel;

  int currentPage = 0;

  final String adUnitId = "45261f3464c633f7";
  final PageController controller = PageController();
  final RewardedAdLoader adLoader = RewardedAdLoader();

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
    ).catchError((error, stackTrace) => log(
          "Fucked up",
          error: error,
          stackTrace: stackTrace,
        ));
    adLoader.setRewardedAdListener(
      onAdLoadFailedCallback: (adUnit, error) {
        context.loaderOverlay.hide();
      },
      onAdReceivedRewardCallback: (ad, reward) {
        context.loaderOverlay.hide();
        controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );

    adLoader.loadAd(adUnitId);
  }

  Widget getTopicView(Topic topic, int index) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // final config = isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    // codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);

    return Stack(
      children: [
        SafeArea(
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
                  child: MarkdownWidget(
                    data: topic.content,
                    // config: config.copy(
                    //   configs: [
                    //     isDark ? PreConfig.darkConfig.copy(wrapper: codeWrapper) : const PreConfig().copy(wrapper: codeWrapper),
                    //   ],
                    // )

                    //  styleSheet: MarkdownStyle(),
                    //   highlightBuilder: (text, language, infoString) {
                    //     final prism = Prism(
                    //       mouseCursor: SystemMouseCursors.text,
                    //       style: Theme.of(context).brightness == Brightness.dark ? const PrismStyle.dark() : const PrismStyle(),
                    //     );
                    //     return prism.render(text, language ?? 'plain');
                    //   },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      useSafeArea: false,
                      context: context,
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => TopicCommentModel(),
                        child: TopicCommentView(topicId: topic.id),
                      ),
                    );
                  },
                  icon: const Icon(CupertinoIcons.chat_bubble),
                ),
                IconButton(
                  onPressed: () async {
                    await topic.setIsLiked(userModel.user, !topic.isLiked).then(
                      (topic) {
                        topicModel.updateOne(topic);
                      },
                    );
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
                    Share.shareWithResult("Check out this course on BeeLearn", subject: "We are").whenComplete(
                      () => context.loaderOverlay.hide(),
                    );
                  },
                  icon: const Icon(CupertinoIcons.share),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _nextPage(List<Topic> topics, List<_TopicFragmentViewType> viewTypes) async {
    if (currentPage < topics.length - 1) {
      final nextViewType = viewTypes[currentPage + 1];
      if (nextViewType == _TopicFragmentViewType.topicView) {
        context.loaderOverlay.show();
        unlockTopic(topics[currentPage + 1]).then((value) {
          controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceIn,
          );
        }).whenComplete(() => context.loaderOverlay.hide());
      }
    }
  }

  Widget getQuestionView(List<Topic> topics, List<_TopicFragmentViewType> viewTypes, int index) {
    return QuestionView(
      question: topics[index].question!,
      nextPage: () => _nextPage(topics, viewTypes),
    );
  }

  (List<_TopicFragmentViewType>, List<Topic>) getViewTypes(List<Topic> topics) {
    final List<_TopicFragmentViewType> viewTypes = [];
    final List<Topic> items = [];

    for (int index = 0; index < topics.length; index++) {
      viewTypes.add(_TopicFragmentViewType.topicView);
      items.add(topics[index]);

      if (topics[index].question != null) {
        items.add(topics[index]);
        viewTypes.add(_TopicFragmentViewType.questionView);
      }
    }

    return (viewTypes, items);
  }

  /// Check if user can scroll left
  bool _canScrollNext(
    List<Topic> topics,
    List<_TopicFragmentViewType> viewTypes,
  ) {
    final viewType = viewTypes[currentPage];

    switch (viewType) {
      case _TopicFragmentViewType.topicView:
        return true;
      case _TopicFragmentViewType.questionView:
        if (currentPage < topics.length - 1) {
          final nextTopic = topics[currentPage + 1];
          return nextTopic.isUnlocked;
        }

        return false;
    }
  }

  /// complete topic
  Future<void> completeTopic(Topic topic) async {
    if (!topic.isCompleted) {
      final newTopic = await topic.setIsComplete(userModel.user);
      topicModel.updateOne(newTopic);
    }
  }

  /// unlock topic
  Future<void> unlockTopic(Topic topic) async {
    if (!topic.isUnlocked) {
      final newTopic = await topic.setIsUnlocked(userModel.user);
      topicModel.updateOne(newTopic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopicModel>(
      builder: (context, model, child) {
        final (viewTypes, topics) = getViewTypes(model.items);

        _TopicFragmentViewType? currentViewType;

        if (viewTypes.isNotEmpty) currentViewType = viewTypes[currentPage];

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: BackButton(
              onPressed: () => Navigator.pop(context),
            ),
            title: LinearProgressPageIndicator(
              itemCount: topics.length,
              pageController: controller,
            ),
            actions: [
              Visibility(
                visible: topics.isNotEmpty && currentPage == topics.length - 1 && !(topics[currentPage].isUnlocked || topics[currentPage].isCompleted),
                child: TextButton(
                  onPressed: () async {
                    final topic = topics[currentPage];

                    // Ignore if error
                    unlockTopic(topic);
                    completeTopic(topic);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        padding: EdgeInsets.zero,
                        content: ListTile(
                          leading: const Icon(CupertinoIcons.sparkles),
                          title: const Text("Hurray, Lesson completed"),
                          trailing: Text(
                            "+8xp",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                        backgroundColor: Colors.black,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text("Continue"),
                ),
              ),
              Visibility(
                visible: currentViewType != null && currentPage != topics.length - 1 && currentViewType == _TopicFragmentViewType.questionView,
                child: TextButton(
                  onPressed: () async {
                    await unlockTopic(topics[currentPage + 1]);

                    controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text("Skip"),
                ),
              ),
            ],
          ),
          body: model.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PageView.builder(
                  itemCount: topics.length,
                  controller: controller,
                  physics: topics.isNotEmpty && _canScrollNext(topics, viewTypes) ? null : const LeftBlockedScrollPhysics(),
                  onPageChanged: (index) {
                    if (index > 0) {
                      final currentIndex = index - 1;
                      final viewType = viewTypes[currentIndex];
                      if (viewType == _TopicFragmentViewType.topicView) completeTopic(topics[currentIndex]);
                    }
                    setState(() => currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final viewType = viewTypes[index];
                    final topic = topics[index];

                    switch (viewType) {
                      case _TopicFragmentViewType.topicView:
                        return getTopicView(topic, index);
                      case _TopicFragmentViewType.questionView:
                        return getQuestionView(topics, viewTypes, index);
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
