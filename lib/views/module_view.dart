import 'package:beelearn/models/module_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../serializers/module.dart';
import 'app_theme.dart';
import 'components/expanded_list.dart';

class ModuleView extends StatefulWidget {
  final int courseId;
  final String? courseName;

  const ModuleView({
    super.key,
    this.courseName,
    required this.courseId,
  });

  @override
  State createState() => _ModuleViewState();
}

class _ModuleViewState extends State<ModuleView> {
  late List<Module> _modules;

  @override
  Widget build(context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: context.pop),
          title: Text(widget.courseName ?? ""),
        ),
        body: FutureBuilder(
          future: ModuleModel.getModules(courseId: widget.courseId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _modules = snapshot.requireData.results;

                return SingleChildScrollView(
                  child: ExpandedList(
                    itemCount: _modules.length,
                    headerBuilder: (context, index, isExpanded) {
                      final module = _modules[index];
                      final isUnlocked = index == 0 || module.isUnLocked;

                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isUnlocked ? Theme.of(context).colorScheme.primaryContainer : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(module.name),
                      );
                    },
                    bodyBuilder: (context, index) {
                      final module = _modules[index];

                      return ListView.builder(
                        itemCount: module.lessons.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final lesson = module.lessons[index];
                          final isUnlocked = index == 0 || module.isUnLocked;

                          return ListTile(
                            onTap: () {
                              context.push("/topics/?lessonId=${lesson.id}");
                            },
                            enabled: isUnlocked,
                            isThreeLine: true,
                            leading: const Icon(Icons.book_outlined),
                            title: const Text("Lesson"),
                            subtitle: Text(lesson.name),
                            trailing: isUnlocked
                                ? null
                                : const Icon(
                                    Icons.lock,
                                    size: 18,
                                  ),
                          );
                        },
                      );
                    },
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
