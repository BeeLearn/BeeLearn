import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_theme.dart';
import 'components/expanded_list.dart';

class ModuleView extends StatefulWidget {
  final int courseId;

  const ModuleView({super.key, required this.courseId});

  @override
  State createState() => _ModuleViewState();
}

class _ModuleViewState extends State<ModuleView> {
  @override
  Widget build(context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: context.pop),
          title: const Text("How do vaccines work"),
        ),
        body: SingleChildScrollView(
          child: ExpandedList(
            itemCount: 3,
            headerBuilder: (context, index, isExpanded) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                title: const Text("Classes and Objects"),
              );
            },
            bodyBuilder: (context, index) {
              return ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      context.push("/lessons/?moduleId=1");
                    },
                    leading: const Icon(Icons.book_outlined),
                    title: const Text("Lesson"),
                    subtitle: const Text("What is an object"),
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
