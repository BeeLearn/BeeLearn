import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/reward_model.dart';

class RewardList extends StatefulWidget {
  const RewardList({super.key});

  @override
  State createState() => _RewardListState();
}

class _RewardListState extends State<RewardList> {
  String? nextURL;

  @override
  void initState() {
    super.initState();

    RewardModel.getRewards().then((response) {
      Provider.of<RewardModel>(context, listen: false).setAll(response.results);

      setState(() {
        nextURL = response.next;
      });
    });
  }

  @override
  Widget build(context) {
    return Consumer<RewardModel>(
      builder: (context, model, child) {
        return SizedBox(
          height: 172,
          child: PageView.builder(
            itemCount: model.rewards.length,
            padEnds: false,
            controller: PageController(viewportFraction: 1 / 3),
            itemBuilder: (context, index) {
              final reward = model.rewards[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: reward.isUnlocked
                          ? Theme.of(context).brightness == Brightness.light
                              ? reward.lightModeColor
                              : reward.darkModeColor
                          : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          reward.icon,
                          width: 64,
                          height: 64,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    reward.title,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
