import 'package:beelearn/main_application.dart';
import 'package:beelearn/views/streak_view.dart';
import 'package:beelearn/views/user_lifeline_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../models/course_model.dart';
import '../../models/user_model.dart';
import '../components/pill_chip.dart';
import 'category_single_tab.dart';
import 'category_tab.dart';

class CategoryTabView extends StatefulWidget {
  const CategoryTabView({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryTabView();
}

class _CategoryTabView extends State<CategoryTabView> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  List<Tab> get _tabs => [
        const Tab(child: Text("For you")),
        const Tab(child: Text("New")),
        const Tab(child: Text("In progress")),
        const Tab(child: Text("Completed")),
      ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (MainApplication.isNewUser) {
        ShowCaseWidget.of(context).startShowCase([_one, _two, _three]);
      }
    });
  }

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
                    Showcase(
                      key: _one,
                      title: "Take on your next challenge",
                      description: "Use your hearts to keep learning!",
                      child: PillChip(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (context) => const UserLifeLineView(),
                          );
                        },
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 8.0),
                          Text(model.value.profile!.lives.toString())
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Showcase(
                      key: _two,
                      title: "Let that streak be consistent",
                      description: "View your streaks, and share",
                      child: PillChip(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (context) => const StreakView(),
                          );
                        },
                        children: [
                          Icon(
                            CupertinoIcons.flame_fill,
                            color: Colors.greenAccent[700],
                          ),
                          const SizedBox(width: 8.0),
                          Text(model.value.profile!.streaks.toString()),
                        ],
                      ),
                    ),
                    Showcase(
                      key: _three,
                      title: "Notifications",
                      description: "View all your notifications and alerts here",
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                );
              },
            ),
          ];
        },
        body: Consumer<UserModel>(
          builder: (context, model, child) {
            final user = model.value;

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
