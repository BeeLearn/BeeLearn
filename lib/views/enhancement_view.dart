import 'package:beelearn/models/enhancement_model.dart';
import 'package:beelearn/models/topic_model.dart';
import 'package:beelearn/serializers/enhancement.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'fragments/enhance_view_fragment.dart';

class EnhancementView extends StatelessWidget {
  final int topicId;

  const EnhancementView({super.key, required this.topicId});

  onMenuSelected(BuildContext context, EnhancementType type) {
    context.loaderOverlay.show();
    TopicModel.enhanceTopic(id: topicId, type: type).then(
      (response) {
        Provider.of<EnhancementModel>(
          context,
          listen: false,
        ).updateOrAddOne(response);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Topic Enhanced Successfully"),
          ),
        );
      },
    ).whenComplete(() => context.loaderOverlay.hide());
  }

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EnhancementModel(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text("AI Enhancement History"),
          actions: [
            PopupMenuButton<EnhancementType>(
              icon: const Icon(Icons.add),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text("Enhance lesson"),
                    onTap: () => onMenuSelected(context, EnhancementType.enhance),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    child: const Text("Summarize"),
                    onTap: () => onMenuSelected(context, EnhancementType.summarize),
                  ),
                ];
              },
            ),
          ],
        ),
        body: EnhanceViewFragment(
          topicId: topicId,
          onSelected: (enhancement) => Navigator.pop(context, enhancement),
        ),
      ),
    );
  }
}
