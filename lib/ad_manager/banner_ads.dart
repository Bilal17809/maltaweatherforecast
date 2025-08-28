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
    if (!_isAdEnabled || removeAds.isSubscribedGet.value) {
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
  }
}
// class BannerAdManager extends GetxController {
//   final _adInstances = <String, BannerAd>{};
//   final _adStatusMap = <String, RxBool>{};
//   final isBannerAdEnabled = true.obs;
//   final AppOpenAdManager appOpenAdManager = Get.put(AppOpenAdManager());
//
//   @override
//   onInit() {
//     super.onInit();
//     initRemoteConfig();
//   }
//
//   String get _adUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-8172082069591999/3961150447';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-5405847310750111/9215247053';
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }
//
//   Future<void> initRemoteConfig() async {
//     try {
//       await RemoteConfigService().init();
//       final showBanner = RemoteConfigService().getBool('BannerAd', 'BannerAd');
//       isBannerAdEnabled.value = showBanner;
//
//       if (showBanner) {
//         for (var i = 1; i <= 2; i++) {
//           loadBannerAd('ad$i');
//         }
//       }
//     } catch (e) {
//       debugPrint("Failed to init banner remote config: $e");
//     }
//   }
//
//   void loadBannerAd(String key) {
//     _adInstances[key]?.dispose();
//
//     final screenWidth = Get.context!.mediaQuerySize.width.toInt();
//     final ad = BannerAd(
//       adUnitId: _adUnitId,
//       size: AdSize(height: 55, width: screenWidth),
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           _adStatusMap[key] ??= false.obs;
//           _adStatusMap[key]!.value = true;
//           debugPrint("BannerAd loaded for: $key");
//         },
//         onAdFailedToLoad: (_, error) {
//           _adStatusMap[key] ??= false.obs;
//           _adStatusMap[key]!.value = false;
//           debugPrint("BannerAd load failed ($key): ${error.message}");
//         },
//       ),
//     );
//
//     ad.load();
//     _adInstances[key] = ad;
//   }
//
//   Widget showBannerAd(String key) {
//     return Obx(() {
//       final ad = _adInstances[key];
//       final isLoaded = _adStatusMap[key]?.value ?? false;
//
//       if (appOpenAdManager.isAdVisible.value) return const SizedBox();
//
//       if (isBannerAdEnabled.value && ad != null && isLoaded) {
//         return SafeArea(
//           bottom: true,
//           child: SizedBox(
//             width: ad.size.width.toDouble(),
//             height: ad.size.height.toDouble(),
//             child: AdWidget(ad: ad),
//           ),
//         );
//       } else {
//         return SafeArea(
//           bottom: true,
//           child: Shimmer.fromColors(
//             baseColor: getPrimaryColor(Get.context!).withValues(alpha: 0.4),
//             highlightColor: getPrimaryColor(
//               Get.context!,
//             ).withValues(alpha: 0.6),
//             child: Container(
//               height: 50,
//               margin: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: kWhite,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   @override
//   void onClose() {
//     for (final ad in _adInstances.values) {
//       ad.dispose();
//     }
//     super.onClose();
//   }
// }
