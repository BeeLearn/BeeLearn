import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../djira_client/request.dart';
import '../../main_application.dart';
import '../../models/module_model.dart';
import '../../serializers/module.dart';
import '../components/expanded_list.dart';
import '../topic_view.dart';

class ModuleFragment extends StatefulWidget {
  final int courseId;

  const ModuleFragment({super.key, required this.courseId});

  @override
  State<StatefulWidget> createState() => _ModuleFragmentState();
}

class _ModuleFragmentState extends State<ModuleFragment> {
  @override
  initState() {
    super.initState();

    final moduleModel = Provider.of<ModuleModel>(context, listen: false);

    ModuleModel.getModules(courseId: widget.courseId).then((response) {
      moduleModel.setAll(response.results);
    });

    Request.subscribe(
      namespace: "modules",
      onError: (response) {},
      onSuccess: (response) {
        final module = Module.fromJson(response.data);
        moduleModel.updateOrAddOne(module);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModuleModel>(
      builder: (context, models, child) {
        final modules = models.items;

        return modules.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: ExpandedList(
                  itemCount: modules.length,
                  sharedPreferences: MainApplication.preferences,
                  generateKey: (index) => "module_${index}_expansion_state",
                  headerBuilder: (context, index, isExpanded) {
                    final module = modules[index];
                    final isUnlocked = index == 0 || module.isUnLocked;

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
                  bodyBuilder: (context, index) {
                    final module = modules[index];

                    return ListView.builder(
                      itemCount: module.lessons.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final lesson = module.lessons[index];
                        final isUnlocked = index == 0 || module.isUnLocked;

                        return ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              useSafeArea: false,
                              builder: (context) {
                                return TopicView(query: {"lesson_id": lesson.id});
                              },
                            );
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
      },
    );
  }
}
