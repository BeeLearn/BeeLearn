import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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

  /*fetchLessons() {
    LessonModel.getLessons(courseId: widget.courseId).then((lessons) {
      setState(() {
        _next = lessons.next;
        _topics = lessons.results;
      });
    });
  }*/
/*
  loadMoreLessons() {
    LessonModel.getLessons(nextURL: _next).then((lessons) {
      setState(() {
        _next = lessons.next;
        _lessons.addAll(lessons.results);
      });
    });
  }*/
/*
  @override
  void initState() {
    super.initState();

    fetchLessons();

    _controller.addListener(() {
      if (_next != null && _controller.page!.round() == _lessons.length - 1) {
        loadMoreLessons();
      }
    });
  }*/

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
          centerTitle: true,
        ),
        body: PageView.builder(
          itemCount: _topics.length,
          controller: _controller,
          itemBuilder: (context, index) {
            final lesson = _topics[index];

            return Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 32.0),
                        child: Text(
                          lesson.content,
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
                          onPressed: () {},
                          isSelected: lesson.isLiked,
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
