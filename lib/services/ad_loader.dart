import 'dart:math';

import 'package:applovin_max/applovin_max.dart';

import '../../types.dart';

class RewardedAdLoader {
  final int retryLimit;
  int _retryAttempt = 0;

  RewardedAdLoader({this.retryLimit = 4});

  int get retryDelay => pow(2, min(6, _retryAttempt)).toInt();

  setRewardedAdListener({
    Callback<MaxAd>? onAdLoadedCallback,
    Callback<MaxAd>? onAdHiddenCallback,
    Callback<MaxAd>? onAdClickedCallback,
    Callback<MaxAd>? onAdDisplayedCallback,
    Callback2<MaxAd, MaxError>? onAdDisplayFailedCallback,
    required Callback2<String, MaxError> onAdLoadFailedCallback,
    required Callback2<MaxAd, MaxReward> onAdReceivedRewardCallback,
  }) {
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          _retryAttempt = 0;
          if (onAdLoadedCallback != null) onAdLoadedCallback(ad);
        },
        onAdHiddenCallback: (ad) {
          if (onAdHiddenCallback != null) onAdHiddenCallback(ad);
        },
        onAdClickedCallback: (ad) {
          if (onAdClickedCallback != null) onAdClickedCallback(ad);
        },
        onAdDisplayedCallback: (ad) {
          if (onAdDisplayedCallback != null) onAdDisplayedCallback(ad);
        },
        onAdDisplayFailedCallback: (ad, error) {
          if (onAdDisplayFailedCallback != null) onAdDisplayFailedCallback(ad, error);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          onAdLoadFailedCallback(adUnitId, error);

          Future.delayed(Duration(milliseconds: 1000 * _retryAttempt), () => loadAd(adUnitId));
        },
        onAdReceivedRewardCallback: onAdReceivedRewardCallback,
      ),
    );
  }

  void loadAd(String adUnitId) {
    AppLovinMAX.loadRewardedAd(adUnitId);
  }

  showAd(String adUnitId) async {
    bool isReady = (await AppLovinMAX.isRewardedAdReady(adUnitId))!;
    if (isReady) AppLovinMAX.showRewardedAd(adUnitId);
  }
}
