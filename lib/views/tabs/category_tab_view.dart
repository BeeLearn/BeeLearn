import 'package:badges/badges.dart' as badges;
import 'package:beelearn/services/date_service.dart';
import 'package:beelearn/views/notification_view.dart';
import 'package:beelearn/widget_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../main_application.dart';
import '../../models/models.dart';
import '../components/pill_chip.dart';
import '../streak_view.dart';
import '../user_lifeline_view.dart';
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
        const Tab(
          key: categoryCatalogueTabViewKey,
          child: Text("For you"),
        ),
        const Tab(
          key: categoryNewCatalogueTabViewKey,
          child: Text("New"),
        ),
        const Tab(
          key: categoryInProgressCatalogueTabViewKey,
          child: Text("In progress"),
        ),
        const Tab(
          key: categoryCompletedCatalogueTabViewKey,
          child: Text("Completed"),
        ),
      ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (MainApplication.isNewUser) {
        ShowCaseWidget.of(context).startShowCase(
          [
            _one,
            _two,
            _three,
          ],
        );
      }
    });
  }

  @override
  Widget build(context) {
    return DefaultTabController(
      key: categoryCatalogueTabViewKey,
      length: _tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            Selector2<UserModel, StreakModel, (int, int)>(
              selector: (context, userModel, streakModel) => (
                userModel.value.profile!.lives,
                streakModel.totalCompletedWeekStreaks,
              ),
              builder: (context, data, child) {
                final (lives, totalStreaks) = data;

                return SliverAppBar(
                  snap: true,
                  pinned: true,
                  floating: true,
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
                        key: categoryLifeRefillActionButtonKey,
                        onTap: () {
                          if (MediaQuery.of(context).orientation == Orientation.portrait) {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: kReleaseMode,
                              builder: (context) => const UserLifeLineView(key: lifeRefillModalViewKey),
                            );
                          } else {
                            showBottomSheet(
                              context: context,
                              builder: (context) => const Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: UserLifeLineView(key: lifeRefillModalViewKey),
                              ),
                            );
                          }
                        },
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 8.0),
                          Text("$lives")
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Showcase(
                      key: _two,
                      title: "Let that streak be consistent",
                      description: "View your streaks, and share",
                      child: PillChip(
                        key: categoryStreakActionButtonKey,
                        onTap: () {
                          if (MediaQuery.of(context).orientation == Orientation.portrait) {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: kReleaseMode,
                              builder: (context) => const StreakView(key: streakModalViewKey),
                            );
                          } else {
                            showBottomSheet(
                              context: context,
                              builder: (context) => const StreakView(key: streakModalViewKey),
                            );
                          }
                        },
                        children: [
                          Icon(
                            CupertinoIcons.flame_fill,
                            color: Colors.greenAccent[700],
                          ),
                          const SizedBox(width: 8.0),
                          Text("$totalStreaks"),
                        ],
                      ),
                    ),
                    Showcase(
                      key: _three,
                      title: "Notifications",
                      description: "View all your notifications and alerts here",
                      child: IconButton(
                        key: categoryNotificationActionButtonKey,
                        onPressed: () => showDialog(
                          context: context,
                          useSafeArea: false,
                          builder: (context) => const NotificationView(key: notificationModalViewKey),
                        ),
                        icon: badges.Badge(
                          badgeContent: Selector<UserModel, int>(
                            selector: (context, model) => model.value.unreadNotifications,
                            builder: (context, value, child) {
                              return Text("$value");
                            },
                          ),
                          child: const Icon(Icons.notifications_none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                );
              },
            ),
          ];
        },
        body: Selector<UserModel, int>(
          selector: (context, model) => model.value.id,
          builder: (context, userId, child) {
            return TabBarView(
              children: [
                const CategoryTab(),
                CategorySingleTab<NewCourseModel>(
                  initState: () async {
                    final now = DateTime.now();
                    final sevenDaysAgo = now.subtract(const Duration(days: 7));
                    final format = DateService.defaultFormatter.format;

                    final courses = await CourseModel.getCourses(
                      query: {
                        "created_at__range": "${format(now)},${format(sevenDaysAgo)}",
                      },
                    );

                    if (context.mounted) {
                      final newCourseModel = Provider.of<NewCourseModel>(
                        context,
                        listen: false,
                      );

                      newCourseModel.loading = false;
                      newCourseModel.setAll(courses.results);
                    }
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
                    final courses = await CourseModel.getCourses(
                      query: {
                        "course_enrolled_users": "$userId",
                        "course_complete_users!": "$userId",
                      },
                    );

                    if (context.mounted) {
                      final inProgressCourseModel = Provider.of<InProgressCourseModel>(
                        context,
                        listen: false,
                      );

                      inProgressCourseModel.loading = false;
                      inProgressCourseModel.setAll(courses.results);
                    }
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
                    final courses = await CourseModel.getCourses(
                      query: {
                        "course_complete_users": "$userId",
                      },
                    );

                    if (context.mounted) {
                      final completedCourseModel = Provider.of<CompletedCourseModel>(
                        context,
                        listen: false,
                      );

                      completedCourseModel.loading = false;
                      completedCourseModel.setAll(courses.results);
                    }
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
