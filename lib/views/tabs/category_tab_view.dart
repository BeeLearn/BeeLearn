import 'package:beelearn/models/course_model.dart';
import 'package:beelearn/views/tabs/category_single_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_tab.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key}) : super();

  @override
  Widget build(context) {
    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              title: CupertinoSearchTextField(),
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(child: Text("For you")),
                  Tab(child: Text("New")),
                  Tab(child: Text("In progress")),
                  Tab(child: Text("Completed")),
                ],
              ),
            )
          ];
        },
        body: TabBarView(
          children: [
            const CategoryTab(),
            CategorySingleTab<NewCourseModel>(
              initState: () async {
                CourseModel.getCourses(query: {}).then(
                  (courses) {
                    Provider.of<NewCourseModel>(
                      context,
                      listen: false,
                    ).setAll(courses.results);
                  },
                );
              },
            ),
            CategorySingleTab<InProgressCourseModel>(
              resolver: (userCourse) => userCourse.course,
              initState: () async {
                UserCourseBaseModel.getCourses(query: {"is_complete": "false"}).then(
                  (courses) {
                    Provider.of<InProgressCourseModel>(
                      context,
                      listen: false,
                    ).setAll(courses.results);
                  },
                );
              },
            ),
            CategorySingleTab<CompletedCourseModel>(
              resolver: (userCourse) => userCourse.course,
              initState: () async {
                UserCourseBaseModel.getCourses(query: {"is_complete": "true"}).then(
                  (courses) {
                    Provider.of<CompletedCourseModel>(
                      context,
                      listen: false,
                    ).setAll(courses.results);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
