import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../services/ad_loader.dart';
import '../../services/view_service.dart';

class SubscriptionAdFragment extends StatefulWidget {
  final String title;
  final String? description;
  final Function() onAdsLoaded;
  final void Function() onBackPressed;

  const SubscriptionAdFragment({
    super.key,
    this.description,
    required this.title,
    required this.onAdsLoaded,
    required this.onBackPressed,
  });

  @override
  State<SubscriptionAdFragment> createState() => _SubscriptionAdFragmentState();
}

class _SubscriptionAdFragmentState extends State<SubscriptionAdFragment> {
  late String _adUnitId;

  late UserModel _userModel;
  late RewardedAdLoader _rewardedAdLoader;

  @override
  void initState() {
    super.initState();

    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    _adUnitId = FirebaseRemoteConfig.instance.getString("APP_LOVIN_REWARD_AD");

    _rewardedAdLoader = RewardedAdLoader()
      ..setAdListener(
        onAdLoadFailedCallback: (adUnit, error) {},
        onAdReceivedRewardCallback: (ad, reward) => widget.onAdsLoaded(),
      )
      ..loadAd(_adUnitId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _userModel.value.profile!.lifeLine <= 0,
      child: AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: widget.onBackPressed,
              icon: const Icon(Icons.close),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(widget.title),
            )
          ],
        ),
        content: Text(
          widget.description ??
              'Subscribe to BeeHive monthly membership '
                  'for unlimited access or watch an ads.',
        ),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                _rewardedAdLoader.showAd(_adUnitId);
              },
              child: const Text("Watch an Ads"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => ViewService.showPremiumDialog(context),
              child: const Text("Subscribe"),
            ),
          ),
        ],
      ),
    );
  }
}
