import 'package:beelearn/socket_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_application.dart';
import '../../models/module_model.dart';
import '../../serializers/lesson.dart';
import '../../serializers/module.dart';
import '../components/expanded_list.dart';
import '../topic_view.dart';

class ModuleFragment extends StatefulWidget {
  final Map<String, dynamic> query;

  const ModuleFragment({super.key, required this.query});

  @override
  State<StatefulWidget> createState() => _ModuleFragmentState();
}

class _ModuleFragmentState extends State<ModuleFragment> {
  late ModuleModel moduleModel;
  @override
  initState() {
    super.initState();

    moduleModel = Provider.of<ModuleModel>(
      context,
      listen: false,
    );

    fetchModules().then(
      (value) => moduleModel.loading = false,
    );

    client?.subscribe(
      namespace: "modules",
      onError: (response) {},
      onSuccess: (response) {
        moduleModel.updateOrAddOne(Module.fromJson(response.data));
      },
    );

    client?.subscribe(
      namespace: "lessons",
      onError: (response) {},
      onSuccess: (response) {
        final lesson = Lesson.fromJson(response.data);

        moduleModel.updateLessonOne(
          moduleId: lesson.moduleId,
          lesson: lesson,
        );
      },
    );
  }

  Future<void> fetchModules() {
    return ModuleModel.getModules(query: widget.query).then((response) {
      moduleModel.setAll(response.results);
    });
  }

  showTopicViewDialog(Lesson lesson) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return TopicView(query: {"lesson": lesson.id.toString()});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModuleModel>(
      builder: (context, models, child) {
        final modules = models.items;

        return models.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: fetchModules,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ExpandedList(
                    itemCount: modules.length,
                    sharedPreferences: MainApplication.preferences,
                    generateKey: (index) => "module_${index}_expansion_state",
                    headerBuilder: (context, index, isExpanded) {
                      final module = modules[index];
                      final isUnlocked = index == 0 || module.isUnlocked;

                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isUnlocked ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: isUnlocked
                              ? const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                )
                              : const Icon(Icons.lock),
                        ),
                        title: Text(module.name),
                      );
                    },
                    bodyBuilder: (context, moduleIndex) {
                      final module = modules[moduleIndex];

                      return ListView.builder(
                        itemCount: module.lessons.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final lesson = module.lessons[index];
                          final isUnlocked = (moduleIndex == 0 && index == 0) || lesson.isUnlocked;

                          return ListTile(
                            onTap: () => showTopicViewDialog(lesson),
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
                ),
              );
      },
    );
  }
}
