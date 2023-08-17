import 'package:beelearn/views/components/reward_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

import '../components/streak_card.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({Key? key}) : super(key: key);
  @override
  State createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  String? nextURL;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchRewards() async {}

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            expandedHeight: kToolbarHeight + 24,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Profile",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          )
        ];
      },
      body: SingleChildScrollView(
        child: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RewardList(),
                  StreakCard(),
                ],
              )
            : const Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(child: RewardList()),
                  Flexible(child: StreakCard()),
                ],
              ),
      ),
    );
  }
}
