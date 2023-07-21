import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/topic_model.dart';
import '../serializers/topic.dart';
import 'app_theme.dart';
import 'components/page_view_indicators.dart';

class TopicView extends StatefulWidget {
  final int lessonId;

  const TopicView({
    super.key,
    required this.lessonId,
  });

  @override
  State createState() => TopicViewState();
}

class TopicViewState extends State<TopicView> {
  String? _next;
  List<Topic> _topics = [];

  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    TopicModel.getTopics(lessonId: widget.lessonId).then(
      (response) => setState(() {
        _topics = response.results;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: BackButton(onPressed: context.pop),
          title: LinearProgressPageIndicator(
            itemCount: _topics.length,
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
          itemCount: _topics.length,
          controller: _controller,
          itemBuilder: (context, index) {
            final topic = _topics[index];

            return Stack(
              children: [
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            topic.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 32.0),
                        child: Text(
                          topic.content,
                          style: GoogleFonts.albertSans(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomAppBar(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.chat_bubble),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              topic.setIsLiked(!topic.isLiked);
                            });
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
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
