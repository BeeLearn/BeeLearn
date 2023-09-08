import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/course_model.dart';
import '../../models/user_model.dart';
import '../components/pill_chip.dart';
import 'category_single_tab.dart';
import 'category_tab.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key}) : super();

  List<Tab> get _tabs => [
        const Tab(child: Text("For you")),
        const Tab(child: Text("New")),
        const Tab(child: Text("In progress")),
        const Tab(child: Text("Completed")),
      ];

  @override
  Widget build(context) {
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            Consumer<UserModel>(
              builder: (context, model, child) {
                return SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  title: GestureDetector(
                    onTap: () => context.go("/search"),
                    child: const AbsorbPointer(
                      child: CupertinoSearchTextField(
                        enabled: false,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: _tabs,
                  ),
                  actions: [
                    PillChip(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).splashColor),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 8.0),
                        Text(model.user.profile.lives.toString())
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    PillChip(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).splashColor),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      children: [
                        const Icon(
                          CupertinoIcons.flame_fill,
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(width: 8.0),
                        Text(model.user.profile.streaks.toString()),
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
                );
              },
            ),
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
                        final newCourseModel = Provider.of<NewCourseModel>(
                          context,
                          listen: false,
                        );

                        newCourseModel.loading = false;
                        newCourseModel.setAll(courses.results);
                      },
                    );
                  },
                  emptyState: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/illustrations/il_notification.svg",
                          width: 124,
                          height: 124,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "No new course found",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          "New add and updated courses will be found here",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                CategorySingleTab<InProgressCourseModel>(
                  initState: () async {
                    CourseModel.getCourses(query: {
                      "course_enrolled_users": "${user.id}",
                      "course_complete_users!": "${user.id}",
                    }).then(
                      (courses) {
                        final inProgressCourseModel = Provider.of<InProgressCourseModel>(
                          context,
                          listen: false,
                        );

                        inProgressCourseModel.loading = false;
                        inProgressCourseModel.setAll(courses.results);
                      },
                    );
                  },
                  emptyState: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/illustrations/il_adventure.svg",
                          width: 164,
                          height: 164,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Course in progress",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          "Start a course to record progress here",
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                      ],
                    ),
                  ),
                ),
                CategorySingleTab<CompletedCourseModel>(
                  initState: () async {
                    CourseModel.getCourses(query: {
                      "course_complete_users": "${user.id}",
                    }).then(
                      (courses) {
                        final completedCourseModel = Provider.of<CompletedCourseModel>(
                          context,
                          listen: false,
                        );

                        completedCourseModel.loading = false;
                        completedCourseModel.setAll(courses.results);
                      },
                    );
                  },
                  emptyState: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/illustrations/il_awesome.svg",
                          width: 124,
                          height: 124,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "No Course completed",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          "Complete a course to get saved here",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
