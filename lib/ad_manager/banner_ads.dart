import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:maltaweatherforecast/ad_manager/remove_ads.dart';
import 'package:shimmer/shimmer.dart';
import '/core/services/services.dart';
import '/core/theme/theme.dart';
import 'app_open_ads.dart';
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}
class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdEnabled = true;

  final removeAds = Get.find<RemoveAds>();

  @override
  void initState() {
    super.initState();
    _fetchRemoteConfigAndLoadAd();
    loadBannerAd();
  }

  Future<void> _fetchRemoteConfigAndLoadAd() async {
    try {
      await RemoteConfigService().init();
      final showBanner = RemoteConfigService().getBool('BannerAd', 'BannerAd');
      if (!mounted) return;
      setState(() => _isAdEnabled = showBanner);
      if (showBanner) {
        loadBannerAd();
      }
    }
    catch (e) {
      print('RemoteConfig error: $e');
    }
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ?'ca-app-pub-8172082069591999/3961150447'
          :'ca-app-pub-5405847310750111/9215247053',
      size: AdSize.banner,
      request: const AdRequest(extras: {'collapsible': 'bottom'}),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed: ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    final appOpenAdController = Get.find<AppOpenAdManager>();
    return Obx(() {
      if (!_isAdEnabled ||
          removeAds.isSubscribedGet.value ||
          appOpenAdController.isAdVisible.value) {
        return const SizedBox();
      }
      return _isAdLoaded && _bannerAd != null
          ? SafeArea(
        child: Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width:1.5),
            borderRadius: BorderRadius.circular(2.0),
          ),
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      )
          :  SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Shimmer.fromColors(
          baseColor: getBgColor(Get.context!),
          highlightColor: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      );
    });
  }

}
