import 'package:beelearn/models/enhancement_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fragments/enhance_view_fragment.dart';

class EnhancementView extends StatelessWidget {
  final int topicId;

  const EnhancementView({super.key, required this.topicId});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text("AI Enhancement History"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => EnhancementModel(),
          ),
        ],
        child: EnhanceViewFragment(topicId: topicId),
      ),
    );
  }
}
