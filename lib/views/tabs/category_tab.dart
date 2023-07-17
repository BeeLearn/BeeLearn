import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../components/course_card.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State createState() => CategoryTabState();
}

class CategoryTabState extends State<CategoryTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final model = Provider.of<CategoryModel>(context, listen: false);
    CategoryModel.getCategories().then((response) => model.setAll(response.results));
  }

  @override
  Widget build(context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: fetchCategories,
      child: Consumer<CategoryModel>(
        builder: (context, model, child) {
          return ListView.builder(
            itemCount: model.categories.length,
            itemBuilder: (context, index) {
              final category = model.categories[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category.name,
                      style: GoogleFonts.albertSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 188,
                    child: PageView.builder(
                      padEnds: false,
                      itemCount: category.courses.length,
                      controller: PageController(viewportFraction: 0.4), // large 0.6
                      itemBuilder: (context, index) {
                        final course = category.courses[index];

                        return CourseCard(course: course);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
