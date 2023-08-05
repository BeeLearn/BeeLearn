import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' show format;

import '../../models/enhancement_model.dart';

class EnhanceViewFragment extends StatefulWidget {
  final int topicId;

  const EnhanceViewFragment({super.key, required this.topicId});

  @override
  State<EnhanceViewFragment> createState() => _EnhanceViewFragmentState();
}

class _EnhanceViewFragmentState extends State<EnhanceViewFragment> {
  @override
  initState() {
    super.initState();

    EnhancementModel.fetchEnhancements(
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
    return Consumer<EnhancementModel>(
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
                    contentPadding: const EdgeInsets.only(left: 16.0, right: 0),
                    title: Text(enhancement.topic.title),
                    subtitle: Text(
                      format(
                        DateTime.parse(enhancement.createAt),
                      ),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          child: Text("Delete"),
                        ),
                        const PopupMenuItem(
                          child: Text("Share"),
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}
