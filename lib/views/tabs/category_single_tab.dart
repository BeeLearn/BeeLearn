import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../models/course_model.dart';
import '../../views/components/course_card.dart';

class CategorySingleTab<T extends CourseModel> extends StatefulWidget {
  final Map<String, dynamic>? query;
  final Future<void> Function() initState;

  const CategorySingleTab({
    super.key,
    this.query,
    required this.initState,
  });

  @override
  State createState() => CategorySingleTabState<T>();
}

class CategorySingleTabState<T extends CourseModel> extends State<CategorySingleTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    widget.initState();
  }

  @override
  Widget build(context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: widget.initState,
      child: Consumer<T>(
        builder: (context, model, child) {
          final courses = model.items;

          return ResponsiveGridView.builder(
            itemCount: courses.length,
            gridDelegate: const ResponsiveGridDelegate(
              maxCrossAxisExtent: 180,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final course = courses[index];

              return CourseCard(
                course: course,
                onUpdate: (course) {
                  Provider.of<T>(context, listen: false).updateOne(course);
                },
              );
            },
          );
        },
      ),
    );
  }
}
