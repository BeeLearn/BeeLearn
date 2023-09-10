import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../models/course_model.dart';
import '../../models/user_model.dart';
import '../../views/components/course_card.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key}) : super();

  @override
  State createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  late UserModel _userModel;

  @override
  void initState() {
    super.initState();

    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    fetchFavourites();
  }

  Future<void> fetchFavourites() async {
    final user = _userModel.value;

    CourseModel.getCourses(
      query: {"module__lesson__topic__likes": "${user.id}"},
    ).then((response) {
      final favouriteCourseModel = Provider.of<FavouriteCourseModel>(
        context,
        listen: false,
      );

      favouriteCourseModel.loading = false;
      favouriteCourseModel.setAll(response.results);
    });
  }

  Widget get _emptyState => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/illustrations/il_love.svg",
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 8.0),
            Text(
              "No liked course",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "All liked topics can be found here",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      );

  @override
  Widget build(context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: kToolbarHeight + 16.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Favourites",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            ),
          ),
        ];
      },
      body: RefreshIndicator(
        onRefresh: fetchFavourites,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Consumer<FavouriteCourseModel>(
            builder: (context, model, child) {
              final courses = model.items;

              return model.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : courses.isEmpty
                      ? _emptyState
                      : ResponsiveGridView.builder(
                          itemCount: courses.length,
                          gridDelegate: const ResponsiveGridDelegate(
                            maxCrossAxisExtent: 180,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final course = courses[index];

                            return CourseCard(
                              course: course,
                              onTap: () => context.go(
                                "/topics/?lesson__module__course=${course.id}&likes=${_userModel.value.id}",
                              ),
                            );
                          },
                        );
            },
          ),
        ),
      ),
    );
  }
}
