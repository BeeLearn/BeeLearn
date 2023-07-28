import 'package:beelearn/models/user_model.dart';
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
                  children: [
                    const Icon(
                      CupertinoIcons.flame_fill,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8.0),
                    Consumer<UserModel>(
                      builder: (context, model, child) {
                        return Text(model.user.profile.lives.toString());
                      },
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none,
                    color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).indicatorColor : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            )
          ];
        },
        body: Consumer<UserModel>(
          builder: (context, model, child) {
            final user = model.user;

            return TabBarView(
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
                  initState: () async {
                    CourseModel.getCourses(query: {
                      "course_enrolled_users": "${user.id}",
                      "course_complete_users!": "${user.id}",
                    }).then(
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
                  initState: () async {
                    CourseModel.getCourses(query: {
                      "course_complete_users": "${user.id}",
                    }).then(
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
            );
          },
        ),
      ),
    );
  }
}
