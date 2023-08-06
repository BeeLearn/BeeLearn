import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../models/course_model.dart';
import '../serializers/course.dart';
import 'components/course_card.dart';

class SearchView<T> extends StatefulWidget {
  const SearchView({super.key});

  @override
  State createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _isLoading = false;
  List<Course> _courses = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget get emptyStateWidget {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            child: Icon(Icons.search_rounded),
          ),
          Text(
            "Search courses",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "Type title, category or keyword",
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget get loadingStateWidget {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get searchListWidget {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ResponsiveGridView.builder(
        itemCount: _courses.length,
        gridDelegate: const ResponsiveGridDelegate(
          maxCrossAxisExtent: 180,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final course = _courses[index];

          return CourseCard(course: course);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(
            color: Theme.of(context).indicatorColor,
          ),
          onSubmitted: (value) {
            setState(() {
              _isLoading = true;
            });

            CourseModel.getCourses(
              query: {"search": value},
            ).then(
              (response) {
                setState(() {
                  _courses = response.results;
                });
              },
            ).whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            });
          },
        ),
      ),
      body: (_isLoading
          ? loadingStateWidget
          : _courses.isEmpty
              ? emptyStateWidget
              : searchListWidget),
    );
  }
}
