import 'package:beelearn/services/ad_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../models/topic_model.dart';
import '../../models/user_model.dart';
import '../../serializers/topic.dart';
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

    TopicModel.getTopics(query: widget.query).then((topics) {
      topicModel.setAll(topics.results);
      topicModel.loading = false;
    });

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

  /// Set current visible topic as completed
  setCurrentTopicAsCompleted() {
    final topic = topicModel.items[currentPage];

    if (!topic.isCompleted) topic.setIsComplete(userModel.user);
  }

  Widget getTopicView(Topic topic, int index) {
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
                  child: Markdown(
                    data: topic.content,
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
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.chat_bubble),
                ),
                IconButton(
                  onPressed: () {
                    final user = Provider.of<UserModel>(context, listen: false).user;
                    setState(
                      () {
                        topic.setIsLiked(user, !topic.isLiked).then(
                          (topic) {
                            topicModel.updateOne(topic);
                          },
                        );
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
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.share),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getQuestionView(Topic topic, int index) {
    return QuestionView(question: topic.question!);
  }

  List<dynamic> getViewTypes(List<Topic> topics) {
    final List<_TopicFragmentViewType> viewTypes = [];
    final List<dynamic> items = [];

    for (int index = 0; index < topics.length; index++) {
      viewTypes.add(_TopicFragmentViewType.topicView);
      items.add(topics[index]);

      if (topics[index].question != null) {
        items.add(topics[index]);
        viewTypes.add(_TopicFragmentViewType.questionView);
      }
    }

    return [viewTypes, items];
  }

  bool canScrollNext(List<_TopicFragmentViewType> viewTypes) {
    final viewType = viewTypes[currentPage];

    switch (viewType) {
      case _TopicFragmentViewType.topicView:
        return true;
      case _TopicFragmentViewType.questionView:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        /// Todo if event not sent resend
        /// Show modal that if quit progress will be reset
        /// Only premium user can save progress when not quit
        return Future.value(true);
      },
      child: Consumer<TopicModel>(
        builder: (context, model, child) {
          final [viewTypes, topics] = getViewTypes(model.items);

          Topic? currentTopic;
          _TopicFragmentViewType? currentViewType;

          if (topics.isNotEmpty) currentTopic = topics[currentPage];
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
                  visible: currentPage == topics.length - 1,
                  child: TextButton(
                    onPressed: () {
                      // Todo
                      /// show lesson completion dialog with animations
                    },
                    child: const Text("Continue"),
                  ),
                ),
                Visibility(
                  visible: currentViewType != null && currentViewType == _TopicFragmentViewType.questionView,
                  child: TextButton(
                    onPressed: () {
                      // Todo
                      /// Show ads if not premium user
                      /// If premium skip to next page
                      /// Record progress
                      adLoader.showAd(adUnitId);
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
                : LoaderOverlay(
                    child: PageView.builder(
                      itemCount: topics.length,
                      controller: controller,
                      physics: topics.isNotEmpty && canScrollNext(viewTypes) ? null : const LeftBlockedScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final viewType = viewTypes[index];
                        final topic = topics[index];

                        switch (viewType) {
                          case _TopicFragmentViewType.topicView:
                            return getTopicView(topic, index);
                          case _TopicFragmentViewType.questionView:
                            return getQuestionView(topic, index);
                        }
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }
}
