import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enhancement_model.dart';
import '../../serializers/enhancement.dart';

class EnhanceViewFragment extends StatefulWidget {
  final int topicId;
  final Function(Enhancement) onSelected;

  const EnhanceViewFragment({
    super.key,
    required this.topicId,
    required this.onSelected,
  });

  @override
  State<EnhanceViewFragment> createState() => _EnhanceViewFragmentState();
}

class _EnhanceViewFragmentState extends State<EnhanceViewFragment> {
  @override
  initState() {
    super.initState();

    getEnhancements();
  }

  Future<void> getEnhancements() {
    return EnhancementModel.fetchEnhancements(
      query: {"topic": widget.topicId.toString()},
    ).then((response) {
      Provider.of<EnhancementModel>(
        context,
        listen: false,
      ).setAll(response.results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getEnhancements,
      child: Consumer<EnhancementModel>(
        builder: (context, model, child) {
          final enhancements = model.items;

          return enhancements.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.rectangle_stack,
                        size: 48,
                        color: Theme.of(context).hintColor,
                      ),
                      Text(
                        "No History",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "Start new AI enhancement now",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: enhancements.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final enhancement = enhancements[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 16.0,
                        right: 0,
                      ),
                      onTap: () => widget.onSelected(enhancement),
                      title: Text(enhancement.topic.title),
                      leading: Icon(
                        enhancement.type == EnhancementType.enhance ? CupertinoIcons.sparkles : CupertinoIcons.sum,
                      ),
                      subtitle: Text(
                        enhancement.content,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          final enhancementModel = Provider.of<EnhancementModel>(
                            context,
                            listen: false,
                          );

                          return [
                            PopupMenuItem(
                              onTap: () {
                                EnhancementModel.deleteEnhancement(enhancement.id).then(
                                  (data) {
                                    enhancementModel.removeOne(enhancement);
                                  },
                                );
                              },
                              child: const Text("Delete"),
                            ),
                            const PopupMenuItem(
                              child: Text("Share"),
                            ),
                          ];
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
