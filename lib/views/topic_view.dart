import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:provider/provider.dart";

import '../models/topic_model.dart';
import '../models/user_model.dart';
import 'app_theme.dart';
import 'components/page_view_indicators.dart';

class TopicView extends StatelessWidget {
  final int lessonId;

  const TopicView({
    super.key,
    required this.lessonId,
  });

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TopicModel(),
        ),
      ],
      child: _TopicFragmentView(lessonId: lessonId),
    );
  }
}

class _TopicFragmentView extends StatefulWidget {
  final int lessonId;

  const _TopicFragmentView({
    super.key,
    required this.lessonId,
  });

  @override
  State createState() => _TopicFragmentViewState();
}

class _TopicFragmentViewState extends State<_TopicFragmentView> {
  String? _next;

  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    TopicModel.getTopics(lessonId: widget.lessonId).then(
      (topics) => setState(() {
        Provider.of<TopicModel>(context, listen: false).setAll(topics.results);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Consumer<TopicModel>(builder: (context, model, child) {
        final topics = model.topics;

        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: BackButton(onPressed: context.pop),
            title: LinearProgressPageIndicator(
              itemCount: topics.length,
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
            itemCount: topics.length,
            controller: _controller,
            itemBuilder: (context, index) {
              final topic = topics[index];

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
                                    (state) {
                                      topic.isLiked = state;
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
