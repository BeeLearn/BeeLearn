import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/topic_model.dart';
import '../../models/user_model.dart';
import '../app_theme.dart';
import '../components/page_view_indicators.dart';

class TopicFragment extends StatefulWidget {
  final Map<String, dynamic> query;
  final int? nextLessonIndex;

  const TopicFragment({
    super.key,
    this.nextLessonIndex,
    required this.query,
  });

  @override
  State createState() => _TopicFragmentState();
}

class _TopicFragmentState extends State<TopicFragment> {
  String? _next;
  int currentPage = 0;

  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    TopicModel.getTopics(query: widget.query).then(
      (topics) => setState(() {
        Provider.of<TopicModel>(
          context,
          listen: false,
        ).setAll(topics.results);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Consumer<TopicModel>(builder: (context, model, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: BackButton(onPressed: context.pop),
            title: LinearProgressPageIndicator(
              itemCount: model.topics.length,
              pageController: _controller,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.sparkles),
              ),
            ],
            centerTitle: true,
          ),
          body: PageView.builder(
            itemCount: model.topics.length,
            controller: _controller,
            onPageChanged: (index) async {
              if (index == 0) return;

              final previousIndex = index - 1;
              final previousTopic = model.topics[previousIndex];

              if (previousTopic.isCompleted) return;

              final nextTopic = model.topics[index];
              final user = Provider.of<UserModel>(context, listen: false).user;

              previousTopic.setIsComplete(user).then((topic) {
                Provider.of<TopicModel>(
                  context,
                  listen: false,
                ).updateOne(previousIndex, topic);

                Provider.of<TopicModel>(
                  context,
                  listen: false,
                ).updateOne(index, nextTopic);
              });
            },
            itemBuilder: (context, index) {
              final topic = model.topics[index];

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                topic.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.albertSans(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.inverseSurface,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 32.0),
                            child: Text(
                              topic.content,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.inverseSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
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
                                      model.updateOne(index, topic);
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
            },
          ),
        );
      }),
    );
  }
}
