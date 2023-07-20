import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course_model.dart';
import '../components/pill_chip.dart';
import 'category_single_tab.dart';
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
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              title: const CupertinoSearchTextField(),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(child: Text("For you")),
                  Tab(child: Text("New")),
                  Tab(child: Text("In progress")),
                  Tab(child: Text("Completed")),
                ],
              ),
              actions: [
                PillChip(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).splashColor),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  children: const [
                    Icon(
                      CupertinoIcons.flame_fill,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8.0),
                    Text("3"),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none,
                    color: Theme.of(context).indicatorColor,
                  ),
                ),
                const SizedBox(width: 8),
              ],
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
