import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course_model.dart';
import '../../views/components/course_card.dart';

class CategorySingleTab<T extends BaseModel> extends StatefulWidget {
  final Map<String, dynamic>? query;
  final Future<void> Function() initState;
  final dynamic Function(dynamic)? resolver;

  const CategorySingleTab({
    super.key,
    this.query,
    this.resolver,
    required this.initState,
  });

  @override
  State createState() => CategorySingleTabState<T>();
}

class CategorySingleTabState<T extends BaseModel> extends State<CategorySingleTab> with AutomaticKeepAliveClientMixin {
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
          return GridView.builder(
            itemCount: model.courses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // large screen 5
              childAspectRatio: 0.8, // large screen 1
            ),
            itemBuilder: (context, index) {
              final course = model.courses[index];

              return SizedBox(
                height: 200,
                child: CourseCard(
                  course: widget.resolver == null ? course : widget.resolver!(course),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
