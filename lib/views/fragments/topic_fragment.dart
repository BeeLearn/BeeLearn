import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/topic_model.dart';
import '../../models/user_model.dart';
import '../../serializers/topic.dart';
import '../components/page_view_indicators.dart';
import '../question_view.dart';

class TopicFragment extends StatefulWidget {
  final Map<String, dynamic> query;

  const TopicFragment({
    super.key,
    required this.query,
  });

  @override
  State createState() => _TopicFragmentState();
}

enum _TopicFragmentViewType { topicView, questionView }

class _TopicFragmentState extends State<TopicFragment> {
  late UserModel _userModel;
  late TopicModel _topicModel;

  final ValueNotifier<int> currentPage = ValueNotifier(0);
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );
    _topicModel = Provider.of<TopicModel>(
      context,
      listen: false,
    );

    TopicModel.getTopics(query: widget.query).then(
      (topics) {
        print("Hey Hulu Hulu Hulu");
        print(topics);
        print(topics.results.length);
        _topicModel.setAll(topics.results);
      },
    ).catchError((error) => print(error));

    _controller.addListener(() {
      final page = _controller.page!.round();

      if (currentPage.value == page) return;

      currentPage.value = page;
    });
  }

  /// Set current visible topic as completed
  setCurrentTopicAsCompleted() {
    final index = currentPage.value;
    final topic = _topicModel.topics[index];

    if (!topic.isCompleted) topic.setIsComplete(_userModel.user);
  }

  Widget getTopicView(Topic topic, int index) {
    print(topic.content);

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
                  // if (topic.enhancement != null)
                  //   IconButton(
                  //     icon: const Icon(Icons.refresh),
                  //     onPressed: () {
                  //       Provider.of<TopicModel>(
                  //         context,
                  //         listen: false,
                  //       ).setEnhancement(index, null);
                  //     },
                  //   )
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16.0),
                  child: Markdown(
                    data: topic.content,
                    // style: GoogleFonts.openSans(
                    //   fontSize: 16,
                    //   fontWeight: FontWeight.w300,
                    //   color: Theme.of(context).colorScheme.inverseSurface,
                    // ),
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
                            _topicModel.updateOne(index, topic);
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
          final [viewTypes, topics] = getViewTypes(model.topics);

          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: BackButton(
                onPressed: () => Navigator.pop(context),
              ),
              title: LinearProgressPageIndicator(
                itemCount: topics.length,
                pageController: _controller,
              ),
              actions: const [
                /// Legacy code, remove course enhancement
                /// Todo, Brainstorm on a better approach
                // ValueListenableBuilder<int>(
                //   valueListenable: currentPage,
                //   builder: (context, currentPage, child) {
                //     return IconButton(
                //       onPressed: () async {
                //         final topicModel = Provider.of<TopicModel>(
                //           context,
                //           listen: false,
                //         );
                //         final topic = topicModel.topics[currentPage];
                //         final Enhancement? enhancement = await showDialog(
                //           context: context,
                //           useSafeArea: false,
                //           builder: (context) => EnhancementView(topicId: topic.id),
                //         );
                //
                //         topicModel.setEnhancement(currentPage, enhancement);
                //       },
                //       icon: const Icon(CupertinoIcons.sparkles),
                //     );
                //   },
                // )
              ],
              centerTitle: true,
            ),
            body: PageView.builder(
              itemCount: topics.length,
              controller: _controller,
              physics: currentPage.value == 0 || model.topics[currentPage.value].isCompleted ? null : const NeverScrollableScrollPhysics(),

              /// Todo Prevent scrolling if course is not unlocked
              onPageChanged: (index) async {
                //   if (index == 0) return;
                //
                //   final previousIndex = index - 1;
                //   final previousTopic = model.topics[previousIndex];
                //
                //   if (previousTopic.isCompleted) return;
                //
                //   final user = _userModel.user;
                //   final nextTopic = model.topics[index];
                //
                //   previousTopic.setIsComplete(user).then((topic) {
                //     _topicModel.updateOne(previousIndex, topic);
                //     _topicModel.updateOne(index, nextTopic);
                //   });
                //
                //   if (index == model.topics.length - 1 && !nextTopic.isCompleted) {
                //     nextTopic.setIsComplete(user).then((topic) {
                //       _topicModel.updateOne(index, topic);
                //     });
                //   }
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
          );
        },
      ),
    );
  }
}
